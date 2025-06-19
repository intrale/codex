#!/bin/bash

# Asegurarse de que la variable $GITHUB_TOKEN esté definida
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ Error: GITHUB_TOKEN no está definido"
  exit 1
fi

# Función para configurar remote autenticado si no existe o está mal configurado
configure_remote() {
  local path=$1
  local repo_name=$2

  if [ -d "$path/.git" ]; then
    cd "$path"
    remote_url=$(git remote get-url origin 2>/dev/null || echo "")
    expected_url="https://$GITHUB_TOKEN@github.com/intrale/$repo_name.git"

    if [[ -z "$remote_url" || "$remote_url" != "$expected_url" ]]; then
      echo "🔧 Configurando remote origin para $repo_name"
      git remote remove origin 2>/dev/null
      git remote add origin "$expected_url"
    fi
    cd - > /dev/null
  fi
}

# Clonar los repos si no existen
echo "📦 Clonando repositorios de Codex..."
[ ! -d ../app ] && git clone https://$GITHUB_TOKEN@github.com/intrale/app.git ../app
[ ! -d ../backend ] && git clone https://$GITHUB_TOKEN@github.com/intrale/backend.git ../backend
[ ! -d ../users ] && git clone https://$GITHUB_TOKEN@github.com/intrale/users.git ../users

# Configurar remotes
configure_remote "../app" "app"
configure_remote "../backend" "backend"
configure_remote "../users" "users"
configure_remote "/workspace/codex" "codex"

# Otorgar permisos de ejecución a gradle
chmod +x ../app/gradlew
chmod +x ../backend/gradlew
chmod +x ../users/gradlew

# Verificar acceso al Project v2 de GitHub con GraphQL (escapado correcto)
echo "🔎 Verificando acceso al Project v2 de la organización 'intrale'..."

response=$(curl -s -X POST https://api.github.com/graphql \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ organization(login: \\\"intrale\\\") { projectV2(number: 1) { id title } } }\"}")

if echo "$response" | grep -q '"id"'; then
  echo "✅ Acceso correcto al proyecto v2 de 'intrale'."
else
  echo "❌ No se pudo acceder correctamente al proyecto v2 de 'intrale'."
  echo "$response"
  exit 1
fi
