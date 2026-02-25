# Schema: Session Metrics

Campos de métricas adicionados ao Session Digest para alimentar o Evolution Engine.
Incluídos automaticamente pelo Master ao gerar cada digest.

## Campos (adicionais ao session-digest)

```yaml
metrics:
  qa_cycles: number              # Idas e voltas dev→qa nesta sessão
  blocked: boolean               # Alguma story ficou bloqueada?
  blocked_reason: string | null  # Se blocked, por quê
  known_gotcha_hit: boolean      # Bateu num gotcha que já estava na memória?
  known_gotcha_ids: string[]     # IDs dos gotchas conhecidos que foram atingidos
  recovery_used: string | null   # Estratégia de recovery usada (null se nenhuma)
  recovery_count: number         # Quantas vezes recovery foi ativado
  stories_completed: number      # Stories completadas nesta sessão
  stories_blocked: number        # Stories bloqueadas nesta sessão
  total_agent_delegations: number # Quantas delegações Master→Agent
  agent_breakdown:               # Delegações por agente
    dev: number
    qa: number
    architect: number
    devops: number
    sm: number
```

## Exemplo (dentro do session digest)

```markdown
#### Metrics
- **QA cycles:** 2 (S-001: 1, S-002: 1)
- **Blocked:** não
- **Known gotcha hit:** sim — gotcha-global-Database-a3f2
- **Recovery:** RETRY_WITH_MORE_CONTEXT (1x)
- **Stories:** 3 completed, 0 blocked
- **Delegations:** 7 total (dev: 3, qa: 2, architect: 1, devops: 1, sm: 0)
```

## Como o Evolution Engine usa estas métricas

| Métrica | Insight | Ação |
|---------|---------|------|
| `qa_cycles > 1` para mesma categoria | @dev falha consistentemente nesta área | Adicionar pre-flight check ao DNA |
| `known_gotcha_hit = true` | Gotcha na memória mas agente não consultou | Promover gotcha para regra DNA (forçar) |
| `recovery_count > 0` pela mesma razão | Problema recorrente | Adicionar prevenção ao DNA |
| `blocked_reason` repetido | Padrão de bloqueio | Adicionar aviso ao DNA do @sm |
| Alto `agent_breakdown.qa` relativo | Muitas reprovações | Reforçar checks no DNA do @dev |
