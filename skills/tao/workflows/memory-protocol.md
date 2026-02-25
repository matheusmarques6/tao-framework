# Protocolo de Memória do Tao

Todo agente com `memory: project` DEVE seguir este protocolo.

## Estrutura da Memória

```
~/.claude/agent-memory/tao-{agent}/
├── MEMORY.md           # Índice (máx 200 linhas, auto-carregado)
├── gotchas.md          # Armadilhas descobertas
├── patterns.md         # Padrões confirmados do projeto
└── preferences.md      # Preferências do usuário
```

## O que salvar (por categoria)

### gotchas.md — Armadilhas e Pegadinhas
**Quando:** Algo inesperado aconteceu que causou erro ou confusão.

Formato:
```markdown
## [CATEGORIA] Título curto
- **Errado:** `código ou abordagem que falhou`
- **Certo:** `código ou abordagem correta`
- **Por quê:** explicação em 1 frase
- **Arquivos:** paths relevantes
- **Severidade:** alta|média|baixa
- **Descoberto em:** Story X / Tarefa Y
```

### patterns.md — Padrões Confirmados
**Quando:** Algo funcionou bem e é reutilizável.

Formato:
```markdown
## [CATEGORIA] Título curto
- **Padrão:** descrição do padrão
- **Exemplo:** código ou referência
- **Quando usar:** situações onde se aplica
- **Confirmado em:** N projetos/usos
```

### preferences.md — Preferências do Usuário
**Quando:** O usuário corrige algo ou expressa preferência.

Formato:
```markdown
## Preferência
- **O que:** descrição
- **Origem:** correção do usuário / instrução explícita
```

## Regras de Escrita

1. **Verifique antes de salvar** — Já existe entry similar? Atualize em vez de duplicar
2. **Seja conciso** — Máx 5 linhas por entry
3. **Categorize** — Use categorias: API, Frontend, Backend, Database, Config, Deploy, Testing
4. **Mantenha o MEMORY.md atualizado** — Índice com links para os outros arquivos
5. **Limpe obsoletos** — Se uma gotcha foi resolvida permanentemente, mova para "Resolvidas"

## Regras de Leitura

1. **Sempre consulte Agent DNA** antes de começar uma tarefa
2. **Sempre consulte gotchas** antes de começar uma tarefa
3. **Filtre por relevância** — Grep pela keyword da tarefa
4. **Não carregue tudo** — Leia MEMORY.md (índice), depois acesse arquivo específico

## Memória Global vs Projeto

| Tipo | Escopo | Localização |
|------|--------|-------------|
| **Projeto** | Específico deste projeto | `~/.claude/agent-memory/tao-{agent}/` |
| **Global** | Compartilhado entre projetos | `~/.claude/tao-global/` |
| **DNA** | Regras comportamentais aprendidas | `~/.claude/tao-global/agent-dna/` |

### O que é Global:
- Padrões de linguagem/framework (ex: "sempre use async/await com try/catch em Node")
- Preferências do usuário que valem pra tudo
- Gotchas de bibliotecas (ex: "Zustand persist precisa de type parameter explícito")

### O que é Projeto:
- Estrutura específica deste codebase
- Padrões de naming deste projeto
- Bugs específicos deste sistema

### O que é DNA:
- Regras comportamentais derivadas de experiência (ex: "SEMPRE verificar RLS antes de testar inserts Supabase")
- Aprendidas pela Retrospective ao final de cada projeto
- Injetadas pelo Master em toda delegação

## Compartilhamento entre Agentes

Todos os agentes leem da mesma memória global. Mas cada agente escreve no SEU arquivo:
- @dev escreve gotchas de código
- @qa escreve gotchas de teste
- @architect escreve padrões de design
- @devops escreve gotchas de deploy

O Master pode consultar a memória de QUALQUER agente para tomar decisões melhores.
O Master SEMPRE injeta o Agent DNA relevante ao delegar.
