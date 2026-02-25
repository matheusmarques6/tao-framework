#!/bin/bash
# Tao Loop — Stop Hook
# Intercepta tentativa de parar e alimenta a próxima iteração
# Chamado automaticamente pelo Claude Code no evento Stop

STATE_FILE=".tao/loop-state.json"

# Se não tem loop ativo, deixa sair
if [ ! -f "$STATE_FILE" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Ler estado
ACTIVE=$(cat "$STATE_FILE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('active', False))" 2>/dev/null || echo "False")
ITERATION=$(cat "$STATE_FILE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('iteration', 0))" 2>/dev/null || echo "0")
MAX_ITER=$(cat "$STATE_FILE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('max_iterations', 50))" 2>/dev/null || echo "50")
PROMPT=$(cat "$STATE_FILE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('prompt', ''))" 2>/dev/null || echo "")

# Se loop não está ativo, deixa sair
if [ "$ACTIVE" != "True" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Ler transcript para verificar promise de conclusão
TRANSCRIPT_DIR="$HOME/.claude/projects"
LAST_MSG=""

# Tentar encontrar a mensagem mais recente do assistente
if [ -n "$CLAUDE_SESSION_ID" ]; then
  TRANSCRIPT_FILE=$(find "$TRANSCRIPT_DIR" -name "*.jsonl" -newer "$STATE_FILE" 2>/dev/null | tail -1)
  if [ -n "$TRANSCRIPT_FILE" ]; then
    LAST_MSG=$(tail -20 "$TRANSCRIPT_FILE" 2>/dev/null | grep -o '<promise>[^<]*</promise>' | tail -1 || echo "")
  fi
fi

# Verificar se há promise COMPLETE
if echo "$LAST_MSG" | grep -q '<promise>COMPLETE</promise>'; then
  # Loop concluído com sucesso
  python3 -c "
import json
with open('$STATE_FILE', 'r+') as f:
    d = json.load(f)
    d['active'] = False
    d['completed'] = True
    f.seek(0)
    json.dump(d, f, indent=2)
    f.truncate()
" 2>/dev/null
  echo '{"decision": "allow"}'
  exit 0
fi

# Verificar limite de iterações
if [ "$MAX_ITER" -gt 0 ] && [ "$ITERATION" -ge "$MAX_ITER" ]; then
  python3 -c "
import json
with open('$STATE_FILE', 'r+') as f:
    d = json.load(f)
    d['active'] = False
    d['stopped_reason'] = 'max_iterations_reached'
    f.seek(0)
    json.dump(d, f, indent=2)
    f.truncate()
" 2>/dev/null
  echo '{"decision": "allow"}'
  exit 0
fi

# Incrementar iteração
NEW_ITER=$((ITERATION + 1))
python3 -c "
import json
with open('$STATE_FILE', 'r+') as f:
    d = json.load(f)
    d['iteration'] = $NEW_ITER
    f.seek(0)
    json.dump(d, f, indent=2)
    f.truncate()
" 2>/dev/null

# Bloquear saída e alimentar próxima iteração
cat << EOFJ
{
  "decision": "block",
  "reason": "$PROMPT",
  "systemMessage": "[Tao Loop] Iteracao $NEW_ITER — Continuando execucao do PRD. Leia prd.json para proxima story pendente."
}
EOFJ
