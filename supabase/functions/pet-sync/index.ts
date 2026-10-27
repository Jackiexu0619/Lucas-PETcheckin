import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const sb = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...cors, "Content-Type": "application/json; charset=utf-8", "Cache-Control": "no-store" },
  });
}

async function sha256Text(input: string) {
  const bytes = new TextEncoder().encode(input);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function profileFromKey(recoveryKey: string) {
  const recoveryHash = await sha256Text(recoveryKey);
  const { data, error } = await sb.from("pet_profiles").select("id,created_at,updated_at,last_sync_at").eq("recovery_hash", recoveryHash).maybeSingle();
  if (error) throw error;
  return { profile: data, recoveryHash };
}

async function payloadHash(payload: unknown) {
  return sha256Text(JSON.stringify(payload));
}


/**
 * One-time additive repair for the 23 user-imported collocations on 2026-10-25.
 * Snapshot 87 has 65 structures. Subsequent whole-state device syncs dropped
 * those additions while accumulating newer Test records. Only copy missing
 * structures, never roll back words/tests/plans or other fields.
 *
 * Executed on authenticated pull, so the repaired payload and server-side
 * canonical hash are persisted atomically within the normal sync protocol.
 */
async function restoreMissingUserPhrases(profileId: string, current: any) {
  const structures = current?.payload?.structures;
  if (!Array.isArray(structures)) return current;
  const { data: snap, error: snapErr } = await sb.from("pet_snapshots")
    .select("payload").eq("profile_id", profileId).eq("id", 87).maybeSingle();
  if (snapErr) throw snapErr;
  const candidates = (Array.isArray(snap?.payload?.structures) ? snap.payload.structures : [])
    .filter((s: any) => s?.source === "user_provided_20261025_school_phrases" &&
      typeof s.id === "string" && s.id.startsWith("school_fixed_20261025_"));
  // Do not invent missing source assets or partially restore an unverified batch.
  if (candidates.length !== 23 || new Set(candidates.map((s: any) => s.id)).size !== 23) return current;
  const known = new Set(structures.map((s: any) => s?.id));
  const missing = candidates.filter((s: any) => !known.has(s.id));
  if (!missing.length) return current;

  const payload = { ...current.payload, structures: [...structures, ...missing] };
  const hash = await payloadHash(payload);
  const now = new Date().toISOString();
  // Optimistic compare-and-swap: never overwrite newly submitted learner activity.
  const { data: updated, error } = await sb.from("pet_current_state")
    .update({ payload, payload_hash: hash, updated_at: now,
      app_version: current.app_version, source_device: current.source_device })
    .eq("profile_id", profileId).eq("payload_hash", current.payload_hash)
    .select("schema_version,app_version,payload,payload_hash,source_device,updated_at").maybeSingle();
  if (error) throw error;
  if (updated) {
    console.info("Restored missing user phrases", missing.length, "for profile", profileId);
    return updated;
  }
  const { data: newer, error: readErr } = await sb.from("pet_current_state")
    .select("schema_version,app_version,payload,payload_hash,source_device,updated_at")
    .eq("profile_id", profileId).maybeSingle();
  if (readErr) throw readErr;
  return newer;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ ok: false, error: "method_not_allowed" }, 405);

  try {
    const body = await req.json();
    const action = String(body?.action || "");
    const recoveryKey = String(body?.recovery_key || "");
    if (!recoveryKey || recoveryKey.length < 24) return json({ ok: false, error: "invalid_recovery_key" }, 400);

    if (action === "init") {
      const { profile, recoveryHash } = await profileFromKey(recoveryKey);
      let profileId = profile?.id;
      if (!profileId) {
        const { data, error } = await sb.from("pet_profiles").insert({ recovery_hash: recoveryHash }).select("id").single();
        if (error) throw error;
        profileId = data.id;
      }

      const payload = body.payload ?? {};
      const hash = await payloadHash(payload);
      const now = new Date().toISOString();
      const state = {
        profile_id: profileId,
        schema_version: String(body.schema_version || "1"),
        app_version: String(body.app_version || "unknown"),
        payload,
        payload_hash: hash,
        source_device: body.source_device ? String(body.source_device) : null,
        updated_at: now,
      };
      const { error: upErr } = await sb.from("pet_current_state").upsert(state, { onConflict: "profile_id" });
      if (upErr) throw upErr;
      const { error: snapErr } = await sb.from("pet_snapshots").insert({
        profile_id: profileId,
        snapshot_type: "manual",
        label: "Initial cloud backup",
        schema_version: state.schema_version,
        app_version: state.app_version,
        payload,
        payload_hash: hash,
        source_device: state.source_device,
      });
      if (snapErr) throw snapErr;
      await sb.from("pet_profiles").update({ last_sync_at: now }).eq("id", profileId);
      return json({ ok: true, profile_id: profileId, synced_at: now, payload_hash: hash });
    }

    const { profile } = await profileFromKey(recoveryKey);
    if (!profile) return json({ ok: false, error: "profile_not_found" }, 404);
    const profileId = profile.id;

    if (action === "pull") {
      const { data, error } = await sb.from("pet_current_state").select("schema_version,app_version,payload,payload_hash,source_device,updated_at").eq("profile_id", profileId).maybeSingle();
      if (error) throw error;
      const state = await restoreMissingUserPhrases(profileId, data);
      return json({ ok: true, state });
    }

    if (action === "push") {
      const payload = body.payload ?? {};
      const hash = await payloadHash(payload);
      const expectedHash = body.expected_hash ? String(body.expected_hash) : null;
      const { data: current, error: curErr } = await sb.from("pet_current_state").select("schema_version,app_version,payload,payload_hash,source_device,updated_at").eq("profile_id", profileId).maybeSingle();
      if (curErr) throw curErr;

      if (current && expectedHash && current.payload_hash !== expectedHash && current.payload_hash !== hash) {
        return json({ ok: false, error: "sync_conflict", conflict: true, state: current }, 409);
      }

      if (current?.payload_hash === hash) {
        const now = new Date().toISOString();
        await sb.from("pet_profiles").update({ last_sync_at: now }).eq("id", profileId);
        return json({ ok: true, unchanged: true, synced_at: now, payload_hash: hash });
      }

      if (current) {
        const dayStart = new Date();
        dayStart.setUTCHours(0, 0, 0, 0);
        const { count } = await sb.from("pet_snapshots")
          .select("id", { count: "exact", head: true })
          .eq("profile_id", profileId)
          .eq("snapshot_type", "daily")
          .gte("created_at", dayStart.toISOString());
        if (!count) {
          await sb.from("pet_snapshots").insert({
            profile_id: profileId,
            snapshot_type: "daily",
            label: "Daily automatic snapshot",
            schema_version: current.schema_version,
            app_version: current.app_version,
            payload: current.payload,
            payload_hash: current.payload_hash,
            source_device: current.source_device,
          });
        }
      }

      const now = new Date().toISOString();
      const state = {
        profile_id: profileId,
        schema_version: String(body.schema_version || "1"),
        app_version: String(body.app_version || "unknown"),
        payload,
        payload_hash: hash,
        source_device: body.source_device ? String(body.source_device) : null,
        updated_at: now,
      };
      const { error } = await sb.from("pet_current_state").upsert(state, { onConflict: "profile_id" });
      if (error) throw error;
      await sb.from("pet_profiles").update({ last_sync_at: now }).eq("id", profileId);
      return json({ ok: true, synced_at: now, payload_hash: hash });
    }

    if (action === "snapshot") {
      const type = ["manual", "pre_upgrade", "auto"].includes(String(body.snapshot_type)) ? String(body.snapshot_type) : "manual";
      const { data: current, error } = await sb.from("pet_current_state").select("schema_version,app_version,payload,payload_hash,source_device").eq("profile_id", profileId).single();
      if (error) throw error;
      const { data, error: snapErr } = await sb.from("pet_snapshots").insert({
        profile_id: profileId,
        snapshot_type: type,
        label: body.label ? String(body.label).slice(0, 200) : null,
        schema_version: current.schema_version,
        app_version: current.app_version,
        payload: current.payload,
        payload_hash: current.payload_hash,
        source_device: current.source_device,
      }).select("id,created_at").single();
      if (snapErr) throw snapErr;
      return json({ ok: true, snapshot: data });
    }

    if (action === "snapshots") {
      const limit = Math.max(1, Math.min(50, Number(body.limit || 20)));
      const { data, error } = await sb.from("pet_snapshots")
        .select("id,snapshot_type,label,schema_version,app_version,payload_hash,source_device,created_at")
        .eq("profile_id", profileId)
        .order("created_at", { ascending: false })
        .limit(limit);
      if (error) throw error;
      return json({ ok: true, snapshots: data });
    }

    if (action === "restore") {
      const snapshotId = Number(body.snapshot_id);
      if (!Number.isFinite(snapshotId)) return json({ ok: false, error: "invalid_snapshot_id" }, 400);
      const { data: snap, error: snapErr } = await sb.from("pet_snapshots")
        .select("id,schema_version,app_version,payload,payload_hash,source_device,created_at")
        .eq("profile_id", profileId).eq("id", snapshotId).maybeSingle();
      if (snapErr) throw snapErr;
      if (!snap) return json({ ok: false, error: "snapshot_not_found" }, 404);

      const { data: current } = await sb.from("pet_current_state").select("schema_version,app_version,payload,payload_hash,source_device").eq("profile_id", profileId).maybeSingle();
      if (current) {
        await sb.from("pet_snapshots").insert({
          profile_id: profileId,
          snapshot_type: "manual",
          label: "Before cloud restore",
          schema_version: current.schema_version,
          app_version: current.app_version,
          payload: current.payload,
          payload_hash: current.payload_hash,
          source_device: current.source_device,
        });
      }
      const now = new Date().toISOString();
      const { error } = await sb.from("pet_current_state").upsert({
        profile_id: profileId,
        schema_version: snap.schema_version,
        app_version: snap.app_version,
        payload: snap.payload,
        payload_hash: snap.payload_hash,
        source_device: snap.source_device,
        updated_at: now,
      }, { onConflict: "profile_id" });
      if (error) throw error;
      await sb.from("pet_profiles").update({ last_sync_at: now }).eq("id", profileId);
      return json({ ok: true, restored_snapshot_id: snapshotId, state: { schema_version: snap.schema_version, app_version: snap.app_version, payload: snap.payload, payload_hash: snap.payload_hash, updated_at: now } });
    }

    return json({ ok: false, error: "unknown_action" }, 400);
  } catch (err) {
    console.error(err);
    return json({ ok: false, error: "server_error", detail: err instanceof Error ? err.message : String(err) }, 500);
  }
});