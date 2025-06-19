#!/bin/bash

# Asegurarse de que la variable $GITHUB_TOKEN esté definida en el entorno de Codex
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Error: GITHUB_TOKEN no está definido"
  exit 1
fi

# Instalar GitHub CLI (gh)
echo "🔧 Instalando GitHub CLI..."
apt update
apt install -y curl gnupg lsb-release

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > \
  /etc/apt/sources.list.d/github-cli.list

apt update
apt install -y gh

echo "✅ GitHub CLI instalado."

# Autenticación automática de gh usando GITHUB_TOKEN
echo "🔐 Autenticando GitHub CLI..."
echo "$GITHUB_TOKEN" | gh auth login --with-token

# Verificación de autenticación previa al clonado
echo "🔎 Verificando acceso a GitHub con gh..."
if ! gh repo view intrale/app > /dev/null 2>&1; then
  echo "❌ No se puede acceder al repositorio intrale/app con el token actual."
  exit 1
fi

echo "✅ Autenticación verificada."

# Clonar los repositorios con autenticación solo si no existen
echo "📦 Clonando repositorios de Codex..."
[ ! -d ../app ] && gh repo clone intrale/app ../app
[ ! -d ../backend ] && gh repo clone intrale/backend ../backend
[ ! -d ../users ] && gh repo clone intrale/users ../users

# Se otorgan permisos a gradle
chmod +x ../app/gradlew
chmod +x ../backend/gradlew
chmod +x ../users/gradlew

# Asegurarse de que /workspace/codex tenga remoto configurado si es un repo válido
if [ -d /workspace/codex/.git ]; then
  cd /workspace/codex
  if ! git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️ Agregando remote origin a /workspace/codex"
    git remote add origin https://github.com/intrale/codex.git
  fi
fi

# Verificación de acceso al proyecto clásico intrale/projects/1
echo "🔎 Verificando acceso al tablero intrale/projects/1..."

project_id=1
columns=$(gh api /projects/$project_id/columns --header "Accept: application/vnd.github.inertia-preview+json" 2>/dev/null)

if echo "$columns" | grep -q '"name": "Todo"'; then
  echo "✅ Acceso correcto al proyecto 'intrale', columna 'Todo' encontrada."
else
  echo "❌ No se pudo acceder correctamente al proyecto o no se encontró la columna 'Todo'."
  echo "$columns"
  exit 1
fi
