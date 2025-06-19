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
