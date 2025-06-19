#!/bin/bash

# Asegurarse de que la variable $GITHUB_TOKEN esté definida en el entorno de Codex
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Error: GITHUB_TOKEN no está definido"
  exit 1
fi

# Clonar los repositorios con autenticación solo si no existen
echo "📦 Clonando repositorios de Codex..."
[ ! -d ../app ] && git clone https://$GITHUB_TOKEN@github.com/intrale/app.git ../app
[ ! -d ../backend ] && git clone https://$GITHUB_TOKEN@github.com/intrale/backend.git ../backend
[ ! -d ../users ] && git clone https://$GITHUB_TOKEN@github.com/intrale/users.git ../users

# Se otorgan permisos a gradle
chmod +x ../app/gradlew
chmod +x ../backend/gradlew
chmod +x ../users/gradlew

# Asegurarse de que /workspace/codex tenga remoto configurado si es un repo válido
if [ -d /workspace/codex/.git ]; then
  cd /workspace/codex
  if ! git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️ Agregando remote origin a /workspace/codex"
    git remote add origin https://$GITHUB_TOKEN@github.com/intrale/codex.git
  fi
fi

# Verificación de acceso al proyecto clásico intrale/projects/1 usando curl
echo "🔎 Verificando acceso al tablero intrale/projects/1 con curl..."

columns=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
                 -H "Accept: application/vnd.github.inertia-preview+json" \
                 https://api.github.com/projects/1/columns)

if echo "$columns" | grep -q '"name": "Todo"'; then
  echo "✅ Acceso correcto al proyecto 'intrale', columna 'Todo' encontrada."
else
  echo "❌ No se pudo acceder correctamente al proyecto o no se encontró la columna 'Todo'."
  echo "$columns"
  exit 1
fi
