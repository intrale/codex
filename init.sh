#!/bin/bash

# Asegurarse de que la variable $GITHUB_TOKEN esté definida en el entorno de Codex
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ Error: GITHUB_TOKEN no está definido"
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

# Verificación de acceso a Projects v2 con GraphQL
echo "🔎 Verificando acceso al Project v2 de la organización 'intrale'..."

graphql_query='{
  organization(login: "intrale") {
    projectV2(number: 1) {
      id
      title
    }
  }
}'

response=$(curl -s -X POST https://api.github.com/graphql \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"$graphql_query\"}")

if echo "$response" | grep -q '"id"'; then
  echo "✅ Acceso correcto al proyecto v2 de 'intrale'."
else
  echo "❌ No se pudo acceder correctamente al proyecto v2 de 'intrale'."
  echo "$response"
  exit 1
fi
