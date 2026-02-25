# Schema: Gotcha

Formato obrigatório para registrar armadilhas/pegadinhas.

## Campos

```yaml
id: gotcha-[PROJETO]-[CATEGORIA]-[HASH4]   # Único, gerado automaticamente
title: string                                # Título curto e descritivo
category: enum                               # Ver categorias abaixo
severity: high | medium | low
scope: global | project                      # Global = vale pra qualquer projeto
agent: dev | qa | architect | devops | sm    # Quem descobriu

wrong: string | code block                   # O que causa o problema
right: string | code block                   # A solução correta
reason: string                               # Por quê (1 frase)

files: string[]                              # Arquivos afetados (paths)
tags: string[]                               # Tags livres para busca
discovered_in: string                        # Story/tarefa onde foi descoberto
date: YYYY-MM-DD                             # Data da descoberta
hit_count: number                            # Quantas vezes foi atingida (para Evolution Engine)
```

## Categorias

| Categoria | Quando usar |
|-----------|------------|
| `API` | Endpoints, requests, responses, auth |
| `Frontend` | Componentes, estado, rendering, CSS |
| `Backend` | Server, middleware, business logic |
| `Database` | Queries, migrations, schemas, RLS |
| `Config` | Variáveis de ambiente, build, tooling |
| `Deploy` | CI/CD, Docker, plataformas, infra |
| `Testing` | Testes, mocks, fixtures, coverage |
| `Security` | Vulnerabilidades, auth, permissions |
| `Performance` | N+1, memory leaks, bottlenecks |
| `Library` | Bugs/comportamentos de libs externas |
| `TypeScript` | Tipos, generics, type narrowing |

## Exemplo

```markdown
### gotcha-convertfy-Database-a3f2

**Supabase RLS retorna 200 em insert bloqueado**

- **Severity:** high
- **Scope:** global (vale pra qualquer projeto Supabase)
- **Agent:** @dev
- **Errado:** Verificar apenas `response.status === 200` como sucesso
- **Certo:** Verificar `response.data.length > 0` após insert
- **Por quê:** Supabase retorna 200 mesmo quando RLS bloqueia, mas o array data vem vazio
- **Files:** src/api/cadastro.ts
- **Tags:** supabase, rls, insert, silent-fail
- **Discovered in:** Story 1.2
- **Date:** 2026-02-15
- **Hit count:** 2 → promovido para agent-dna/dev.md
```
