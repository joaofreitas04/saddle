#!/usr/bin/env bash
# resolve_docs.sh — derive official docs domains for load-bearing deps from
# registry metadata (deterministic; no guessing, no memory).
# Usage: resolve_docs.sh node <pkg> [pkg...]
#        resolve_docs.sh python|rust|go <name> [name...]
# Output (grep-friendly):
#   DOCS  <pkg> homepage=<url>        resolved base
#   PROBE <pkg> <candidate-url>       llms.txt candidates — probe these with
#                                     the host's web tool; record hit or miss
#                                     with a date in the dep's KB card.
# Node mode queries the npm registry (same trust surface as installs).
set -u
ECO="${1:?usage: resolve_docs.sh <node|python|rust|go> <pkg...>}"; shift

cand() { # emit llms.txt probe candidates for a base url
  local p="$1" u="${2%/}"
  echo "PROBE $p $u/llms.txt"
  echo "PROBE $p $u/llms-full.txt"
  echo "PROBE $p $u/docs/llms.txt"
}

for p in "$@"; do
  case "$ECO" in
    node)
      # Pin the public registry and ignore any repo/user .npmrc — an untrusted
      # repo must not redirect metadata lookups to a registry it controls.
      NPMV() { npm_config_userconfig=/dev/null npm view --registry=https://registry.npmjs.org "$@" 2>/dev/null | tail -1; }
      H=$(NPMV "$p" homepage)
      if [ -z "$H" ]; then
        H=$(NPMV "$p" repository.url \
            | sed -E 's#^git\+##; s#\.git$##; s#^git://#https://#; s#^git@github\.com:#https://github.com/#')
      fi
      H="${H%%#*}"   # strip #readme-style fragments
      case "$H" in http://*|https://*) ;; *) H="" ;; esac
      if [ -n "$H" ]; then echo "DOCS $p homepage=$H"; cand "$p" "$H"
      else echo "DOCS $p homepage=unknown"; fi
      ;;
    python)
      echo "DOCS $p resolve=https://pypi.org/pypi/$p/json field=info.project_urls (Documentation, then Homepage)"
      ;;
    rust)
      echo "DOCS $p homepage=https://docs.rs/$p"
      cand "$p" "https://docs.rs/$p"
      ;;
    go)
      echo "DOCS $p homepage=https://pkg.go.dev/$p"
      ;;
    *)
      echo "DOCS error unsupported-ecosystem $ECO"; exit 1
      ;;
  esac
done
