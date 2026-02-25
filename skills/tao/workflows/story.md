# Workflow: Criar Story

Usado quando o usuário pede `*story [título]` ou `/tao @sm story`.

## Passos

### 1. Determinar Número
- Liste `docs/stories/` para encontrar o último número
- Incremente: se último é `005-`, próximo é `006-`

### 2. Coleta de Informação
- Se o usuário deu descrição suficiente → gere direto
- Se falta info → pergunte (máx 2 perguntas focadas)

### 3. Gerar Story
Crie arquivo `docs/stories/[NNN]-[slug].md` com template:

```markdown
# Story [NNN]: [Título]

## Descrição
Como [persona], quero [funcionalidade], para que [benefício].

## Acceptance Criteria
- [ ] AC1
- [ ] AC2

## Tasks
- [ ] Task 1
- [ ] Task 2

## Definição de Pronto
- [ ] Código implementado
- [ ] Testes passando
- [ ] Lint/typecheck ok

## Arquivos Modificados
<!-- Atualizado durante desenvolvimento -->
```

### 4. Confirmar
- Mostre a story ao usuário
- Pergunte se quer ajustar algo
