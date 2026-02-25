#!/bin/bash
# Tao IDE Sync — Sincroniza agentes para múltiplas IDEs
# Uso: sync.sh [all|claude|cursor|windsurf] [project-path]

TAO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AGENTS_DIR="$TAO_ROOT/agents"
PROJECT_PATH="${2:-.}"

sync_claude() {
  local target="$PROJECT_PATH/.claude/agents"
  mkdir -p "$target"

  for agent_file in "$AGENTS_DIR"/*.md; do
    local name=$(basename "$agent_file")
    # Claude Code: copia direto (formato nativo)
    cp "$agent_file" "$target/$name"
  done

  echo "[tao] Claude Code: $(ls "$target"/*.md 2>/dev/null | wc -l) agentes sincronizados → $target"
}

sync_cursor() {
  local target="$PROJECT_PATH/.cursor/rules/tao"
  mkdir -p "$target"

  for agent_file in "$AGENTS_DIR"/*.md; do
    local name=$(basename "$agent_file" .md)

    # Pula constitution (não é agente)
    [ "$name" = "constitution" ] && continue

    # Cursor: formato condensado (sem frontmatter YAML)
    {
      # Extrai título e descrição do frontmatter
      local display_name=$(grep "^name:" "$agent_file" | head -1 | sed 's/name: //' | sed 's/"//g')
      local description=$(grep "^description:" "$agent_file" | head -1 | sed 's/description: //' | sed 's/"//g')

      echo "# $display_name"
      echo ""
      echo "> $description"
      echo ""

      # Extrai conteúdo após o frontmatter (após segundo ---)
      sed -n '/^---$/,/^---$/!p' "$agent_file" | tail -n +2

      echo ""
      echo "---"
      echo "*Tao Agent - Synced from tao-framework/agents/$name.md*"
    } > "$target/$name.mdc"
  done

  echo "[tao] Cursor: $(ls "$target"/*.mdc 2>/dev/null | wc -l) agentes sincronizados → $target"
}

sync_windsurf() {
  local target="$PROJECT_PATH/.windsurf/rules/tao"
  mkdir -p "$target"

  for agent_file in "$AGENTS_DIR"/*.md; do
    local name=$(basename "$agent_file" .md)

    [ "$name" = "constitution" ] && continue

    local display_name=$(grep "^name:" "$agent_file" | head -1 | sed 's/name: //' | sed 's/"//g')
    local description=$(grep "^description:" "$agent_file" | head -1 | sed 's/description: //' | sed 's/"//g')

    # Windsurf: formato XML-tagged
    {
      echo "<agent-identity>"
      echo "Name: $display_name"
      echo "Description: $description"
      echo "</agent-identity>"
      echo ""

      echo "<instructions>"
      sed -n '/^---$/,/^---$/!p' "$agent_file" | tail -n +2
      echo "</instructions>"

      echo ""
      echo "---"
      echo "*Tao Agent - Synced from tao-framework/agents/$name.md*"
    } > "$target/$name.md"
  done

  echo "[tao] Windsurf: $(ls "$target"/*.md 2>/dev/null | wc -l) agentes sincronizados → $target"
}

# Sync constitution como regra global
sync_constitution() {
  local claude_rules="$PROJECT_PATH/.claude/rules"
  local cursor_rules="$PROJECT_PATH/.cursor/rules"
  local windsurf_rules="$PROJECT_PATH/.windsurf/rules"

  if [ -f "$AGENTS_DIR/constitution.md" ]; then
    if [ "$1" = "all" ] || [ "$1" = "claude" ]; then
      mkdir -p "$claude_rules"
      cp "$AGENTS_DIR/constitution.md" "$claude_rules/tao-constitution.md"
    fi
    if [ "$1" = "all" ] || [ "$1" = "cursor" ]; then
      mkdir -p "$cursor_rules"
      cp "$AGENTS_DIR/constitution.md" "$cursor_rules/tao-constitution.mdc"
    fi
    if [ "$1" = "all" ] || [ "$1" = "windsurf" ]; then
      mkdir -p "$windsurf_rules"
      cp "$AGENTS_DIR/constitution.md" "$windsurf_rules/tao-constitution.md"
    fi
  fi
}

# Main
case "${1:-all}" in
  all)
    sync_claude
    sync_cursor
    sync_windsurf
    sync_constitution "all"
    echo "[tao] Sync completo para todas as IDEs"
    ;;
  claude)
    sync_claude
    sync_constitution "claude"
    ;;
  cursor)
    sync_cursor
    sync_constitution "cursor"
    ;;
  windsurf)
    sync_windsurf
    sync_constitution "windsurf"
    ;;
  *)
    echo "Uso: sync.sh [all|claude|cursor|windsurf] [project-path]"
    exit 1
    ;;
esac
