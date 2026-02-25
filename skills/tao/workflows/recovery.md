# Sistema de Recovery do Tao

## Estratégias de Recuperação

Quando um agente falha, o Master aplica a estratégia adequada:

### 1. RETRY (mesma abordagem)
**Quando:** Erro transitório (timeout, rate limit, arquivo locked)
**Ação:** Re-executa o mesmo agente com mesmo contexto
**Limite:** Máx 2 retries

### 2. RETRY_WITH_MORE_CONTEXT (abordagem expandida)
**Quando:** Agente falhou por falta de informação
**Ação:** Master coleta mais contexto e re-executa
**Limite:** Máx 1 retry com contexto expandido

### 3. ROLLBACK_AND_RETRY (voltar e tentar diferente)
**Quando:** Agente fez mudanças que quebraram algo
**Ação:**
1. `git stash` ou `git checkout -- .` das mudanças
2. Passa o erro como contexto para o agente
3. Re-executa com instrução de abordagem diferente
**Limite:** Máx 1 rollback

### 4. ESCALATE_TO_ANOTHER_AGENT (escalar)
**Quando:** @dev não consegue resolver → escala para @architect
**Mapeamento:**
- @dev falha → @architect (talvez o design precisa mudar)
- @qa falha → @dev (talvez o código precisa de fix)
- @devops falha → @dev (talvez o build está quebrado)

### 5. ESCALATE_TO_HUMAN (parar e perguntar)
**Quando:** Todas as estratégias falharam, ou erro desconhecido
**Ação:** Master para e reporta ao usuário:
- O que foi tentado
- Por que falhou
- Sugestões de ação manual

## Fluxo de Decisão

```
Agente falha
  → É erro transitório? → RETRY (máx 2x)
  → É falta de contexto? → RETRY_WITH_MORE_CONTEXT
  → Agente fez mudanças ruins? → ROLLBACK_AND_RETRY
  → Outro agente pode ajudar? → ESCALATE_TO_ANOTHER_AGENT
  → Nada funcionou → ESCALATE_TO_HUMAN
```

## Formato de Erro para o Master

Quando um agente falha, reporte ao Master:

```
FALHA:
- Agente: [@agent]
- Tarefa: [o que tentou fazer]
- Erro: [mensagem/tipo do erro]
- Mudanças feitas: [arquivos modificados antes da falha]
- Tentativas: [N de M]
```
