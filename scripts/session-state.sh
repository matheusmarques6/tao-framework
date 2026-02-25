#!/bin/bash
# Tao Session State Manager
# Salva e restaura estado da sessão para recovery
# Uso: session-state.sh save|load|clear

STATE_DIR=".tao"
STATE_FILE="$STATE_DIR/session-state.json"

mkdir -p "$STATE_DIR"

case "$1" in
  save)
    # Captura estado atual
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    MODIFIED=$(git diff --name-only 2>/dev/null | tr '\n' ',' | sed 's/,$//')
    STAGED=$(git diff --cached --name-only 2>/dev/null | tr '\n' ',' | sed 's/,$//')
    LAST_COMMIT=$(git log -1 --format="%H" 2>/dev/null || echo "none")
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    cat > "$STATE_FILE" << EOF
{
  "version": "1.0",
  "timestamp": "$TIMESTAMP",
  "git": {
    "branch": "$BRANCH",
    "lastCommit": "$LAST_COMMIT",
    "modifiedFiles": "$MODIFIED",
    "stagedFiles": "$STAGED"
  },
  "task": {
    "agent": "${2:-unknown}",
    "description": "${3:-none}",
    "status": "${4:-in_progress}"
  }
}
EOF
    echo "State saved to $STATE_FILE"
    ;;

  load)
    if [ -f "$STATE_FILE" ]; then
      cat "$STATE_FILE"
    else
      echo '{"error": "No session state found"}'
      exit 1
    fi
    ;;

  clear)
    rm -f "$STATE_FILE"
    echo "State cleared"
    ;;

  *)
    echo "Usage: session-state.sh save|load|clear [agent] [description] [status]"
    exit 1
    ;;
esac
