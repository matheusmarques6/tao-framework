# Workflow: Retrospective — Evolution Engine

Executado ao final de cada projeto/PRD. Analisa toda a experiência acumulada e evolui o comportamento dos agentes.

## Quando executar

- Ao completar um PRD (`<promise>COMPLETE</promise>`)
- Quando o usuário pede `*retrospective` ou `/tao *retrospective`
- Manualmente ao final de um ciclo de desenvolvimento

## Inputs

```
.tao/digests/          → Todos os session digests do projeto
.tao/gotchas/          → Gotchas descobertas
.tao/patterns/         → Patterns descobertos
prd.json               → PRD com métricas de stories (iterations, status)
~/.claude/tao-global/  → Memória global existente
```

## Processo

### 1. Coleta de Métricas

Analise todos os digests e o prd.json para extrair:

```yaml
project_metrics:
  total_stories: N
  stories_passed: N
  stories_blocked: N
  total_iterations: N
  avg_iterations_per_story: N
  total_qa_cycles: N          # Quantas idas e voltas dev→qa
  avg_qa_cycles_per_story: N
  recovery_events: N          # Quantas vezes recovery foi ativado
  gotchas_discovered: N
  patterns_discovered: N
  known_gotcha_hits: N        # Bateu num gotcha que já estava na memória
```

### 2. Análise de Padrões de Falha

Para cada agente, identifique:

```
@dev:
  - Categorias de erro mais frequentes
  - Stories que precisaram de 2+ ciclos QA (e por quê)
  - Gotchas que já existiam mas foram atingidas mesmo assim

@qa:
  - O que reprovou mais frequentemente
  - False positives (reprovações revertidas)
  - Áreas que nunca foram testadas mas deveriam

@architect:
  - Decisões que precisaram ser revertidas
  - Designs que causaram retrabalho no @dev

@devops:
  - Deploys que falharam na 1a tentativa
  - Problemas de configuração recorrentes

@sm:
  - Stories mal decompostas (bloqueadas por dependência)
  - Estimativas vs realidade
```

### 3. Geração de Regras (Agent DNA)

Para cada padrão identificado com **2+ ocorrências**:

```markdown
### [CATEGORIA] Regra derivada
- **Origem:** [projeto], [gotcha/pattern IDs]
- **Ação:** [SEMPRE/NUNCA] + [comportamento específico]
- **Confirmado em:** [N ocorrências]
- **Data:** [YYYY-MM-DD]
```

**Critérios de promoção:**
| Condição | Ação |
|----------|------|
| Gotcha atingida 2+ vezes no projeto | → Regra no agent-dna do agente responsável |
| Gotcha atingida em 2+ projetos | → Regra GLOBAL no agent-dna |
| Pattern confirmado em 2+ contextos | → Regra de abordagem no agent-dna |
| Ciclo dev→qa > 1 para mesma categoria | → Pre-flight check no dev.md |
| Recovery ativado 2+ vezes pela mesma razão | → Prevenção no agent-dna |

### 4. Atualização do Agent DNA

Para cada agente com novas regras:

1. Ler `~/.claude/tao-global/agent-dna/{agent}.md`
2. Verificar se regra similar já existe (evitar duplicata)
3. Adicionar nova regra na seção "Regras Aprendidas"
4. Atualizar estatísticas do agente
5. Salvar

### 5. Promoção Cross-Project

```
Gotcha scope=project usada em 2+ projetos → promover para scope=global
Pattern scope=project confirmado em 2+ projetos → promover para scope=global
Axiom de digest repetido em 2+ projetos → promover para agent-dna
```

### 6. Depreciação

```
Gotcha não atingida em 5+ projetos → marcar deprecated
Pattern não usado em 5+ projetos → marcar deprecated
Regra DNA contradita por experiência nova → atualizar ou remover
```

### 7. Geração do Evolution Report

Salvar em `.tao/evolution-report.md`:

```markdown
# Evolution Report: [Projeto]

## Data: [YYYY-MM-DD]

## Métricas do Projeto
[tabela de métricas do passo 1]

## Novas Regras DNA
[lista de regras adicionadas ao agent-dna]

## Promoções
[gotchas/patterns promovidos para global]

## Depreciações
[entries marcadas como deprecated]

## Tendências
- Ciclos QA: [melhorando/estável/piorando] vs projeto anterior
- Bloqueios: [melhorando/estável/piorando]
- Gotchas conhecidas atingidas: [melhorando/estável/piorando]

## Recomendações
[3-5 ações concretas para o próximo projeto]
```

## Output

Ao finalizar, mostrar:

```
[Tao] Retrospective concluída
  Projeto: [nome]
  Métricas: [N] stories, [N] iterações, [N] ciclos QA
  Novas regras DNA: [N] (dev: N, qa: N, architect: N)
  Promoções: [N] gotchas → global, [N] patterns → global
  Depreciações: [N]
  Report: .tao/evolution-report.md
```

## Regras

1. NUNCA inventar métricas — tudo derivado de dados reais (digests, prd.json)
2. NUNCA criar regra DNA com menos de 2 ocorrências
3. NUNCA depreciar algo com menos de 5 projetos sem uso
4. Regras DNA devem ser ACIONÁVEIS — "SEMPRE faça X" ou "NUNCA faça Y"
5. Manter agent-dna conciso — máx 20 regras por agente (remover as mais antigas/fracas)
