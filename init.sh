#!/bin/bash

# Asegurarse de que la variable $GITHUB_PAT esté definida en el entorno de Codex
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Error: GITHUB_TOKEN no está definido"
  exit 1
fi

# Clonar el repositorio de Codex
git clone https://github.com/intrale/app.git ../app
git clone https://github.com/intrale/backend.git ../backend
git clone https://github.com/intrale/users.git ../users