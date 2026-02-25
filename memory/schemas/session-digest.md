# Schema: Session Digest

Resumo compacto de cada sessão de trabalho. Gerado automaticamente ao final.

## Campos

```yaml
id: session-[PROJETO]-[YYYY-MM-DD]-[NNN]
date: YYYY-MM-DD
duration: string                              # Estimativa (curta/média/longa)
agent_flow: string[]                          # Sequência de agentes usados
project: string

# O que foi feito
task_summary: string                          # 1-2 frases do objetivo
stories_touched: string[]                     # Stories trabalhadas
files_modified: string[]                      # Arquivos criados/modificados
files_created: string[]                       # Arquivos novos

# O que foi aprendido
user_corrections: list                        # Vezes que o usuário corrigiu algo
axioms_learned: list                          # Regras derivadas da sessão
gotchas_discovered: string[]                  # IDs de gotchas novas
patterns_discovered: string[]                 # IDs de patterns novos
decisions_made: string[]                      # IDs de decisions novas

# Métricas (para Evolution Engine)
metrics:
  qa_cycles: number                           # Idas e voltas dev→qa
  blocked: boolean                            # Alguma story ficou bloqueada?
  blocked_reason: string | null               # Se blocked, por quê
  known_gotcha_hit: boolean                   # Bateu num gotcha que já estava na memória?
  known_gotcha_ids: string[]                  # IDs dos gotchas atingidos
  recovery_used: string | null                # Estratégia de recovery usada
  recovery_count: number                      # Quantas vezes recovery ativado
  stories_completed: number                   # Stories completadas
  stories_blocked: number                     # Stories bloqueadas
  dna_rules_applied: number                   # Quantas DNA rules foram seguidas
  dna_rules_list: string[]                    # Quais DNA rules foram seguidas

# Status
outcome: completed | partial | blocked        # Como terminou
blockers: string[]                            # Se blocked, o que impediu
next_steps: string[]                          # Sugestões para próxima sessão
```

## Exemplo

```markdown
### session-convertfy-2026-02-25-001

- **Date:** 2026-02-25
- **Duration:** média (~45min)
- **Agent flow:** @architect → @dev → @qa
- **Project:** admin-convertfy

#### O que foi feito
- **Task:** Implementar endpoint de cadastro rápido de loja
- **Stories:** Story 1.2
- **Files modified:** src/api/cadastro.ts, src/types/loja.ts
- **Files created:** src/api/__tests__/cadastro.test.ts

#### O que foi aprendido
- **User corrections:**
  - "Não use `any`, sempre defina o tipo" → salvo em preferences
- **Axioms learned:**
  - Neste projeto, toda API route precisa de validação Zod no input
  - Supabase RLS está ativo — sempre testar com usuário sem permissão
- **Gotchas:** gotcha-convertfy-Database-a3f2
- **Patterns:** pattern-convertfy-API-c4d3

#### Metrics
- **QA cycles:** 1
- **Blocked:** não
- **Known gotcha hit:** sim — gotcha-global-Database-a3f2
- **Recovery:** nenhum
- **Stories:** 1 completed, 0 blocked
- **DNA rules applied:** 2 (API-try-catch-wrapper, Zod-input-validation)

#### Status
- **Outcome:** completed
- **Next steps:** Implementar Story 1.3 (UI do cadastro)
```

## Regras

1. Gerado pelo Master ao final de cada fluxo multi-agente
2. Axioms são regras derivadas — se o usuário corrigiu algo, vira axiom
3. Se axiom se repete em 2+ sessões → promover para pattern global
4. Se axiom se repete em 3+ sessões → promover para agent-dna
5. Session digests são append-only (nunca editados depois)
6. **Metrics é obrigatório** — alimenta o Evolution Engine
7. Localização: `.tao/digests/` no projeto
