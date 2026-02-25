# Schema: Decision (ADR Leve)

Formato para registrar decisões técnicas importantes.

## Campos

```yaml
id: decision-[PROJETO]-[NNN]
title: string
status: proposed | accepted | deprecated | superseded
agent: architect | dev | devops
date: YYYY-MM-DD

context: string                 # Por que essa decisão foi necessária
decision: string                # O que foi decidido
alternatives: list              # Alternativas consideradas
consequences_positive: list     # Pontos positivos
consequences_negative: list     # Pontos negativos (trade-offs)

superseded_by: string | null    # Se foi substituída, qual é a nova
related_stories: string[]       # Stories relacionadas
tags: string[]
```

## Exemplo

```markdown
### decision-convertfy-001

**Usar Zustand em vez de Redux para estado global**

- **Status:** accepted
- **Agent:** @architect
- **Date:** 2026-02-10
- **Context:** Precisamos de estado global para dados do usuário e preferências. Redux existe no projeto mas adiciona muita boilerplate.
- **Decision:** Migrar para Zustand com persist middleware
- **Alternatives:**
  1. Redux Toolkit — Menos boilerplate que Redux puro, mas ainda mais complexo que Zustand
  2. Jotai — Atomic, bom para estado granular, mas dificulta persist
  3. Context API — Nativo, mas re-renders excessivos sem memo cuidadoso
- **Positivo:** Menos código, API simples, persist built-in, sem providers
- **Negativo:** Devtools menos maduros que Redux, equipe precisa aprender API nova
- **Related stories:** Story 3.1, Story 3.2
- **Tags:** state-management, zustand, migration
```
