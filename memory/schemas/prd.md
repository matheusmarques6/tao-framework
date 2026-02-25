# Schema: PRD (Product Requirements Document)

Formato do `prd.json` que o Tao Loop lê e atualiza.

## Estrutura

```json
{
  "version": "1.0",
  "project": "nome-do-projeto",
  "created": "YYYY-MM-DD",
  "updated": "YYYY-MM-DD",

  "overview": {
    "title": "Título do projeto/feature",
    "description": "Descrição em 2-3 frases",
    "goals": ["Objetivo 1", "Objetivo 2"],
    "non_goals": ["O que NÃO faz parte do escopo"]
  },

  "stories": [
    {
      "id": "S-001",
      "title": "Título da story",
      "epic": "Nome do epic (opcional)",
      "priority": "critical | high | medium | low",
      "agent": "dev | qa | architect | devops | sm",

      "user_story": {
        "as_a": "persona",
        "i_want": "funcionalidade",
        "so_that": "benefício"
      },

      "acceptance_criteria": [
        {
          "id": "AC-001-1",
          "description": "Critério verificável",
          "completed": false
        }
      ],

      "tasks": [
        {
          "id": "T-001-1",
          "description": "Tarefa técnica",
          "completed": false
        }
      ],

      "dev_notes": "Contexto técnico, decisões, constraints",

      "status": "pending | in_progress | passed | failed | blocked",
      "passes": false,
      "notes": "",
      "completed_at": null,
      "iteration": null
    }
  ],

  "settings": {
    "git_enabled": true,
    "auto_commit": true,
    "commit_prefix": "feat",
    "max_iterations": 50,
    "quality_gates": true
  }
}
```

## Campos que o Loop PODE editar

| Campo | Quem edita | Quando |
|-------|-----------|--------|
| `stories[].status` | Loop | Ao iniciar/concluir story |
| `stories[].passes` | Loop | Quando QA aprova |
| `stories[].notes` | Loop | Ao concluir story |
| `stories[].completed_at` | Loop | Ao marcar passes=true |
| `stories[].iteration` | Loop | Em qual iteração completou |
| `stories[].acceptance_criteria[].completed` | Loop | Ao verificar cada AC |
| `stories[].tasks[].completed` | Loop | Ao concluir cada task |
| `updated` | Loop | A cada modificação |

## Campos IMUTÁVEIS (Loop não pode editar)

- `overview` (requisitos do produto)
- `stories[].user_story` (o que foi pedido)
- `stories[].acceptance_criteria[].description` (critérios originais)
- `stories[].priority`
- `settings`
