# Tao Memory Protocol v2.0

Sistema completo de memória organizada do framework com suporte a Evolution Engine.

---

## Arquitetura de Memória

```
Memória
├── GLOBAL (cross-project)                    ~/.claude/tao-global/
│   ├── MEMORY.md                             Índice geral
│   ├── gotchas/                              Armadilhas por categoria
│   │   ├── _index.md                         Índice de gotchas
│   │   ├── api.md
│   │   ├── frontend.md
│   │   ├── backend.md
│   │   ├── database.md
│   │   ├── config.md
│   │   ├── deploy.md
│   │   ├── testing.md
│   │   ├── security.md
│   │   ├── performance.md
│   │   ├── library.md
│   │   └── typescript.md
│   ├── patterns/                             Padrões por categoria
│   │   ├── _index.md
│   │   └── [mesmas categorias].md
│   ├── decisions/                            Decisões globais
│   │   └── _index.md
│   ├── preferences.md                       Preferências do usuário
│   └── agent-dna/                           ← NOVO: Evolução comportamental
│       ├── dev.md                           Regras aprendidas do @dev
│       ├── qa.md                            Regras aprendidas do @qa
│       ├── architect.md                     Regras aprendidas do @architect
│       ├── devops.md                        Regras aprendidas do @devops
│       └── sm.md                            Regras aprendidas do @sm
│
├── PROJETO (por projeto)                     .tao/
│   ├── state.json                            Estado da sessão atual
│   ├── gotchas/                              Gotchas deste projeto
│   │   ├── _index.md
│   │   └── [por categoria].md
│   ├── patterns/                             Padrões deste projeto
│   │   ├── _index.md
│   │   └── [por categoria].md
│   ├── decisions/                            ADRs deste projeto
│   │   ├── _index.md
│   │   └── decision-[NNN].md
│   ├── digests/                              Resumos de sessão
│   │   └── [YYYY-MM-DD]-[NNN].md
│   ├── evolution-report.md                  ← NOVO: Relatório da retrospective
│   └── codebase-map.md                       Mapeamento do projeto
│
└── AGENTE (por agente, auto do Claude Code)  ~/.claude/agent-memory/tao-{agent}/
    └── MEMORY.md                             Aprendizados específicos do agente
```

## Fluxo de Dados

```
Agente descobre algo
  ↓
Classifica: gotcha? pattern? decision? preference?
  ↓
Define escopo: global ou projeto?
  ↓
Categoriza: API? Frontend? Database? ...
  ↓
Verifica duplicata: já existe similar? → atualiza em vez de criar
  ↓
Salva no arquivo correto com schema correto
  ↓
Atualiza _index.md da categoria
```

## Fluxo de Evolução (NOVO)

```
Projeto completa (todas stories passes=true)
  ↓
Retrospective analisa digests + métricas
  ↓
Identifica padrões de falha e sucesso
  ↓
Gera regras comportamentais
  ↓
Atualiza agent-dna/{agent}.md
  ↓
Próximo projeto: agentes iniciam com regras aprendidas
```

## Regras de Escopo

| Tipo de descoberta | Escopo | Exemplo |
|-------------------|--------|---------|
| Bug/comportamento de lib externa | **Global** | "Zustand persist precisa de type param" |
| Padrão de linguagem/framework | **Global** | "Sempre use async/await com try/catch" |
| Preferência do usuário | **Global** | "Nunca use any" |
| Bug específico deste código | **Projeto** | "O endpoint /api/users espera query param `id`" |
| Padrão deste projeto | **Projeto** | "Neste projeto, routes ficam em src/app/api/" |
| Decisão arquitetural | **Projeto** | "Usamos Zustand em vez de Redux" |
| Configuração específica | **Projeto** | "Build precisa de NODE_ENV=production" |

## Regras de Leitura (antes de cada tarefa)

```
1. Ler agent-dna/{agent}.md → regras comportamentais do agente alvo
2. Ler MEMORY.md global (índice — máx 200 linhas)
3. Grep keyword da tarefa em global/gotchas/ (só categorias relevantes)
4. Grep keyword da tarefa em projeto/gotchas/ (só categorias relevantes)
5. Se @architect: ler decisions/_index.md do projeto
6. Se resumindo sessão: ler último digest
```

**NUNCA leia todos os arquivos de memória. Sempre filtre por relevância.**

## Regras de Escrita

1. **Use o schema correto** — Ver schemas/ para formato obrigatório
2. **Verifique duplicatas** — Grep no _index.md antes de criar
3. **Atualize o índice** — Toda entry nova → adicionar ao _index.md
4. **Seja conciso** — Máx 10 linhas por entry
5. **Categorize corretamente** — Uma gotcha de API não vai em frontend.md
6. **Data sempre** — Toda entry tem data de criação
7. **Métricas nos digests** — Sempre incluir bloco Metrics (schema: metrics.md)

## Regras de Manutenção

| Ação | Quando | Quem |
|------|--------|------|
| Criar entry | Ao descobrir algo novo | Qualquer agente |
| Atualizar entry | Informação mais precisa disponível | Qualquer agente |
| Promover emerging → confirmed | Pattern usado com sucesso 2+ vezes | @master |
| Promover projeto → global | Gotcha/pattern útil em 2+ projetos | @master |
| Promover gotcha → DNA rule | Gotcha atingida 2+ vezes apesar de documentada | Retrospective |
| Deprecar entry | Não é mais relevante (lib atualizada, código removido) | Qualquer agente |
| Limpar deprecated | A cada 10 sessões ou quando memória > 500 linhas | @master |

## Formato dos Índices (_index.md)

```markdown
# Índice: [Categoria]

| ID | Título | Severidade | Data | Status |
|----|--------|-----------|------|--------|
| gotcha-xxx-001 | Título curto | high | 2026-02-25 | active |
| gotcha-xxx-002 | Outro título | medium | 2026-02-20 | deprecated |

Total: N active, M deprecated
Last updated: YYYY-MM-DD
```

## Promoção Automática (axiom → pattern → global → DNA)

```
Sessão 1: Usuário corrige algo → salva como axiom no digest
Sessão 2: Mesmo axiom aparece → promove para pattern (emerging)
Sessão 3: Pattern funciona de novo → promove para confirmed
Projeto 2: Pattern aparece → promove para global
Retrospective: Gotcha atingida 2+ vezes → promove para DNA rule (comportamental)
```

## Codebase Map (por projeto)

```markdown
# Codebase Map: [nome-do-projeto]

## Stack
- Runtime: Node 20 / Python 3.12 / etc
- Framework: Next.js 14 / Express / etc
- Database: Supabase / PostgreSQL / etc
- State: Zustand / Redux / etc

## Estrutura
- src/app/ — Routes (App Router)
- src/components/ — Componentes React
- src/lib/ — Utilitários
- src/api/ — API routes
- tests/ — Testes

## Convenções
- Imports: absolutos com @/
- Naming: camelCase para funções, PascalCase para componentes
- Testes: Vitest com .test.ts

## Dependências Críticas
- [lib]: [o que faz] — [gotchas conhecidas]

Last updated: YYYY-MM-DD
```
