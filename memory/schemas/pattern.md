# Schema: Pattern

Formato obrigatório para registrar padrões confirmados.

## Campos

```yaml
id: pattern-[PROJETO]-[CATEGORIA]-[HASH4]
title: string
category: enum                                # Mesmas categorias de gotcha
scope: global | project
agent: dev | qa | architect | devops | sm
confidence: confirmed | emerging              # Confirmado (2+ usos) ou emergente (1 uso)

pattern: string                               # Descrição do padrão
example: string | code block                  # Exemplo de uso
when_to_use: string                           # Situações onde se aplica
when_not_to_use: string                       # Quando NÃO usar (opcional)

tags: string[]
confirmed_in: string[]                        # Projetos/stories onde foi confirmado
date: YYYY-MM-DD
```

## Níveis de Confiança

| Nível | Critério | Ação |
|-------|---------|------|
| `emerging` | Usado 1 vez com sucesso | Registrar, observar |
| `confirmed` | Usado 2+ vezes com sucesso | Promover, recomendar |

Padrão `emerging` que falha no segundo uso → converter em `gotcha`.

## Exemplo

```markdown
### pattern-global-API-b7c1

**Try/catch wrapper para API routes com logging**

- **Confidence:** confirmed
- **Scope:** global
- **Agent:** @dev
- **Padrão:** Toda API route wrapped com try/catch que loga erro + retorna status code correto
- **Exemplo:**
  ```typescript
  export async function handler(req, res) {
    try {
      const result = await service.execute(req.body);
      return res.status(200).json(result);
    } catch (error) {
      console.error(`[API] ${req.method} ${req.url}:`, error);
      return res.status(error.statusCode || 500).json({ error: error.message });
    }
  }
  ```
- **Quando usar:** Toda nova API route
- **Quando NÃO usar:** Middleware (tem pattern próprio)
- **Tags:** api, error-handling, node
- **Confirmed in:** admin-convertfy, projeto-x
- **Date:** 2026-02-20
```
