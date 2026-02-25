# Workflow: Criar Plano de Execução

Este workflow é usado quando o usuário pede `*plan [feature]` ou `/tao @sm plan`.

## Passos

### 1. Coleta de Contexto
- Verifique se existe `docs/prd/` no projeto
- Se sim, use Grep para buscar APENAS trechos relevantes à feature
- Verifique se existe `docs/architecture/` para entender o sistema atual
- Liste stories existentes em `docs/stories/` para evitar duplicação

### 2. Análise
- Identifique componentes afetados
- Mapeie dependências técnicas
- Estime complexidade (P/M/G)

### 3. Geração do Plano
- Crie stories atômicas
- Defina ordem de execução baseada em dependências
- Atribua agentes recomendados (@architect → @dev → @qa)
- Salve em `docs/stories/`

### 4. Apresentação
- Mostre resumo ao usuário
- Peça confirmação antes de criar os arquivos
