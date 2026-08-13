#!/usr/bin/env bash
# init.sh — idempotent environment bring-up + health check.
# Agents run this at the START of every session, before touching code.
# Output is deliberately grep-friendly: "INIT OK <step>" / "INIT FAIL <step>".
set -u

fail() { echo "INIT FAIL $1"; exit 1; }
ok()   { echo "INIT OK $1"; }

# --- 1. Required tools ------------------------------------------------------
# Add one line per required tool. Example: need bun, need python3, need go
need() { command -v "$1" >/dev/null 2>&1 || fail "missing-tool $1"; }
need git
# need {{REQUIRED_TOOL}}
ok tools

# --- 2. Dependencies (idempotent) -------------------------------------------
# Single command only (chain with && if needed — `a; b` would mask a's failure).
# Output goes to a log so failures are diagnosable without editing this script.
{{INSTALL_CMD}} > .init-install.log 2>&1 || { tail -20 .init-install.log; fail "install"; }
ok deps

# --- 3. Services (only if this project needs them) --------------------------
# Start databases / dev servers idempotently; skip if already running.
# Example:
#   pgrep -f "{{DEV_SERVER_PROC}}" >/dev/null || ({{RUN_CMD}} > .dev-server.log 2>&1 &)
#   sleep 2
ok services

# --- 4. Health check ---------------------------------------------------------
# Prove the world basically works BEFORE any work happens
# (a fast-gate run — ./scripts/verify fast — is a good default health check).
{{HEALTH_CHECK_CMD}} || fail "health"
ok health

# --- 5. Orientation summary --------------------------------------------------
echo "INIT SUMMARY branch=$(git branch --show-current) last-commit=$(git log -1 --format=%h)"
echo "INIT SUMMARY progress-tail:"
tail -n 5 progress.md 2>/dev/null || echo "  (no progress.md yet)"
echo "INIT DONE"
