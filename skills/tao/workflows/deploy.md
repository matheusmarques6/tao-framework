# Workflow: Deploy

Usado quando o usuário pede `/tao *deploy`, `/tao @devops deploy` ou qualquer variação.

## Passos

### 1. Detecção de Ambiente
- Identifique a plataforma de deploy (Vercel, Docker, Railway, etc.)
- Identifique o ambiente alvo (staging, production)
- Se ambíguo, pergunte ao usuário

### 2. Pré-validação
- `git status` — há mudanças não commitadas?
- Build passa? (`npm run build` ou equivalente)
- Testes passam? (`npm test` ou equivalente)
- Se qualquer validação falhar → pare e reporte

### 3. Confirmação
- Mostre ao usuário:
  - Plataforma detectada
  - Ambiente alvo
  - Branch atual
  - Último commit
- **Espere confirmação explícita antes de continuar**

### 4. Execução
- Execute o deploy conforme plataforma
- Monitore output

### 5. Pós-deploy
- Verifique se URL responde (se aplicável)
- Reporte resultado com URL e status
