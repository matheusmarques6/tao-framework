#!/bin/bash
# Tao Quality Gate - Script determinístico
# Executa checks obrigatórios e retorna resultado estruturado
# Exit 0 = tudo passou, Exit 1 = algum falhou

RESULTS=""
PASSED=0
FAILED=0
SKIPPED=0

check() {
  local name="$1"
  local cmd="$2"

  if command -v $(echo "$cmd" | awk '{print $1}') &>/dev/null || [ -f "package.json" ]; then
    if eval "$cmd" &>/dev/null 2>&1; then
      RESULTS="$RESULTS\n  PASS: $name"
      PASSED=$((PASSED + 1))
    else
      RESULTS="$RESULTS\n  FAIL: $name"
      FAILED=$((FAILED + 1))
    fi
  else
    RESULTS="$RESULTS\n  SKIP: $name (not available)"
    SKIPPED=$((SKIPPED + 1))
  fi
}

echo "Tao Quality Gate"
echo "================"

# Detectar package manager
if [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm"
elif [ -f "yarn.lock" ]; then
  PM="yarn"
elif [ -f "bun.lockb" ]; then
  PM="bun"
else
  PM="npm"
fi

# Checks obrigatórios (Constitution IV - Quality First)
if [ -f "package.json" ]; then
  # Verificar quais scripts existem
  if grep -q '"lint"' package.json 2>/dev/null; then
    check "Lint" "$PM run lint"
  fi

  if grep -q '"typecheck"' package.json 2>/dev/null; then
    check "TypeCheck" "$PM run typecheck"
  fi

  if grep -q '"test"' package.json 2>/dev/null; then
    check "Tests" "$PM test"
  fi

  if grep -q '"build"' package.json 2>/dev/null; then
    check "Build" "$PM run build"
  fi
fi

# Verificar secrets expostos
if git ls-files | grep -qE '\.env$|credentials|\.key$|\.pem$' 2>/dev/null; then
  RESULTS="$RESULTS\n  FAIL: Secrets detected in tracked files"
  FAILED=$((FAILED + 1))
else
  RESULTS="$RESULTS\n  PASS: No secrets in tracked files"
  PASSED=$((PASSED + 1))
fi

# Verificar console.log em produção
if grep -r "console\.log" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" src/ 2>/dev/null | grep -v "test\|spec\|__test__\|\.test\.\|\.spec\." | head -1 | grep -q .; then
  RESULTS="$RESULTS\n  WARN: console.log found in production code"
else
  RESULTS="$RESULTS\n  PASS: No console.log in production"
  PASSED=$((PASSED + 1))
fi

# Resultado
echo -e "\nResults:$RESULTS"
echo ""
echo "Summary: $PASSED passed, $FAILED failed, $SKIPPED skipped"

if [ $FAILED -gt 0 ]; then
  echo "Status: BLOCKED (Constitution IV violated)"
  exit 1
else
  echo "Status: PASSED"
  exit 0
fi
