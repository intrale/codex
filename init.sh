#!/bin/bash
# Instalando Android SDK...
echo "📦 Instalando Android SDK..."

ANDROID_SDK_ROOT="/workspace/android-sdk"
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"

cd "$ANDROID_SDK_ROOT/cmdline-tools"
curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip -q commandlinetools.zip
rm commandlinetools.zip
mv cmdline-tools latest

export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_SDK_ROOT="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "✅ Android SDK instalado correctamente."

cd /workspace

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
[ ! -d ../platform ] && git clone https://$GITHUB_TOKEN@github.com/intrale/platform.git ../platform

# Configurar remotes
configure_remote "../app" "app"
configure_remote "../backend" "backend"
configure_remote "../users" "users"
configure_remote "../platform" "platform"
configure_remote "/workspace/codex" "codex"

# Otorgar permisos de ejecución a gradle
chmod +x ../app/gradlew
chmod +x ../backend/gradlew
chmod +x ../users/gradlew
chmod +x ../platform/gradlew

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
