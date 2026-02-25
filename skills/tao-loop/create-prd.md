# Workflow: Criar PRD

Usado quando o usuário quer iniciar um loop mas não tem prd.json.

## Modo Rápido (descrição curta)

Se o usuário deu uma descrição curta:
1. Extraia objetivos implícitos
2. Gere stories automaticamente
3. Mostre ao usuário para confirmar
4. Salve prd.json

## Modo Guiado (interativo)

### Perguntas (máx 5):

1. **O que é o projeto/feature?**
   → Preenche overview.title e overview.description

2. **Quais são os objetivos principais?** (liste até 5)
   → Preenche overview.goals

3. **O que NÃO faz parte?** (limites do escopo)
   → Preenche overview.non_goals

4. **Tem stack/tecnologia definida?** (ou devo analisar o projeto?)
   → Preenche dev_notes das stories

5. **Prefere stories granulares (muitas pequenas) ou abrangentes (poucas grandes)?**
   → Define granularidade da decomposição

### Decomposição Automática

Ao receber as respostas:

1. Identifique os módulos/componentes necessários
2. Para cada módulo, crie stories na ordem:
   - @architect: design/interface (se necessário)
   - @dev: implementação
   - @qa: testes
3. Defina dependências (story X depende de Y)
4. Ordene por prioridade + dependências
5. Numere sequencialmente: S-001, S-002, ...

### Regras de Stories

- Cada story cabe em 1 iteração do loop
- Acceptance criteria são ESPECÍFICOS e VERIFICÁVEIS
- Tasks são atômicas (1 ação por task)
- dev_notes incluem TUDO que o agente precisa saber
- agent field define quem executa

### Saída

Gere `prd.json` seguindo o schema em `memory/schemas/prd.md`.
Mostre resumo ao usuário:

```
PRD Criado: [título]
Stories: N total
  - S-001: [título] (@architect)
  - S-002: [título] (@dev)
  - S-003: [título] (@qa)
  ...
Estimativa: [P/M/G]

Iniciar loop? (sim/não)
```
