#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash) — blocks contract-forbidden operations.
# Exit 2 blocks the call; the stderr message is shown to the model.
# Verify this hook's own teeth after install: pipe a synthetic forbidden
# command through it and require exit 2 (validation.md item 7).
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)
PATTERNS=(
  "git push --force" "git push -f" "push --force-with-lease"
  "git reset --hard" "git clean -fd" "git branch -D" "git checkout \."
  "--no-verify"
  "> scripts/verify" ">scripts/verify" "rm .*scripts/verify" "chmod .*scripts/verify"
)
for p in "${PATTERNS[@]}"; do
  if printf '%s' "$CMD" | grep -Eq "$p"; then
    echo "BLOCKED: '$CMD' matches forbidden pattern '$p' (AGENTS.md golden rules). The user has prevented you from doing this." >&2
    exit 2
  fi
done
exit 0
