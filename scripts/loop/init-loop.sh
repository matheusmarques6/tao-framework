#!/bin/bash
# Tao Loop — Inicializador
# Cria estado do loop e prepara para execução autônoma
# Uso: init-loop.sh [prd-path] [max-iterations]

PRD_PATH="${1:-prd.json}"
MAX_ITER="${2:-50}"
STATE_DIR=".tao"
STATE_FILE="$STATE_DIR/loop-state.json"
PROGRESS_FILE="$STATE_DIR/progress.md"

# Verificar se PRD existe
if [ ! -f "$PRD_PATH" ]; then
  echo "Erro: PRD não encontrado em $PRD_PATH"
  exit 1
fi

# Criar diretórios
mkdir -p "$STATE_DIR/gotchas" "$STATE_DIR/patterns" "$STATE_DIR/decisions" "$STATE_DIR/digests"

# Contar stories pendentes
TOTAL=$(python3 -c "
import json
with open('$PRD_PATH') as f:
    d = json.load(f)
    stories = d.get('stories', [])
    total = len(stories)
    pending = len([s for s in stories if not s.get('passes', False)])
    print(f'{pending}/{total}')
" 2>/dev/null || echo "?/?")

# Criar estado do loop
cat > "$STATE_FILE" << EOF
{
  "active": true,
  "iteration": 1,
  "max_iterations": $MAX_ITER,
  "prd_path": "$PRD_PATH",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "completed": false,
  "prompt": "Voce e o Tao Loop. Leia $PRD_PATH e .tao/progress.md. Execute a proxima story pendente (passes=false). Siga o protocolo: delegue para o agente correto com DNA RULES, verifique quality gates, marque passes=true quando concluir. Se TODAS as stories passaram, execute retrospective e output <promise>COMPLETE</promise>."
}
EOF

# Criar progress.md se não existe
if [ ! -f "$PROGRESS_FILE" ]; then
  cat > "$PROGRESS_FILE" << EOF
# Tao Loop Progress

## PRD: $(python3 -c "import json; print(json.load(open('$PRD_PATH')).get('overview',{}).get('title','Unknown'))" 2>/dev/null)
- Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- Stories: $TOTAL

## Session Log
<!-- APPEND ONLY — cada story completada é registrada aqui -->

## File List
<!-- CUMULATIVE — todos os arquivos modificados -->

## Codebase Patterns
<!-- ADD ONLY — padrões descobertos durante desenvolvimento -->

## Quality Gates
- [ ] typecheck
- [ ] lint
- [ ] tests
- [ ] build
EOF
fi

echo "[Tao Loop] Inicializado"
echo "  PRD: $PRD_PATH"
echo "  Stories: $TOTAL"
echo "  Max iterations: $MAX_ITER"
echo "  State: $STATE_FILE"
echo "  Progress: $PROGRESS_FILE"
echo ""
echo "Para iniciar: execute /tao-loop"
