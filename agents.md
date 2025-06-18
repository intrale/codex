# agents.md

## 📘 Descripción General

Este documento define la configuración y comportamiento esperado del agente automatizado `leitocodexbot` en el entorno de desarrollo de la organización **`intrale`** en GitHub.

`leitocodexbot` tiene un rol auxiliar orientado a tareas repetitivas del ciclo de desarrollo, permitiendo trazabilidad y eficiencia sin reemplazar la supervisión humana.

---

## 🔧 Consideraciones Iniciales

- Todos los comentarios, commits y PRs deben estar en **Español Latinoamericano**.
- El entorno cuenta con `GITHUB_TOKEN` con permisos sobre toda la organización.
- Organización y tablero objetivo en GitHub: **`intrale`**

---

## 🗂️ Estructura del Workspace y Reglas de Interpretación

El agente `leitocodexbot` debe tener en cuenta la siguiente estructura dentro del entorno de desarrollo para poder ejecutar tareas, crear subtareas, entender el contexto de los módulos y realizar pruebas adecuadamente:

### `/workspace/codex/`

- Contiene **todo lo relacionado con el entorno Codex**.
- **No incluye el código funcional de los módulos**, sino herramientas auxiliares, lógica de automatización y soporte general.
- Dentro de este directorio, la carpeta **`docs/`** incluye:
  - Documentación detallada sobre la arquitectura general.
  - Descripción de funcionalidades y diseño de cada módulo.

### `/workspace/backend/`

- Contiene el **código base y común a todos los módulos**.
- Este código es **heredado o reutilizado** por los módulos funcionales.
- Antes de desarrollar funcionalidades o generar pruebas unitarias en otros módulos, el agente debe **entender este código base**.

### `/workspace/users/`

- Contiene la implementación de todos los **endpoints relacionados con usuarios, perfiles y negocios**.
- El agente debe considerar este módulo para tareas de:
  - Registro y autenticación de usuarios.
  - Asignación y validación de roles.
  - Registro y aprobación de negocios.

---

## 🔁 Ejecución de Tareas Automáticas

Cuando se indique que el agente debe **"ejecutar tareas"**, debe:

1. Buscar todos los issues en la columna **"Todo"** del tablero.
2. Para cada issue:
  - Analizar el título y la descripción.
  - Determinar si puede resolver la tarea automáticamente.
  - Si puede:
    - Mover a **"In Progress"**, asignar a `leitocodexbot`.
    - Ejecutar los cambios requeridos.
    - Comentar en el issue lo realizado.
    - Mover a **"Ready"** si fue exitoso.
  - Si no puede:
    - Mover a **"Blocked"**.
    - Comentar el motivo y adjuntar el **stacktrace** si aplica.

3. Validaciones al finalizar:
  - No debe haber issues asignados a `leitocodexbot` en **"In Progress"**.
  - No debe haber issues en la columna **"Todo"**.
  - Si quedan sin ejecutar, debe comentarse el motivo.

---

## 🔹 Creación de Subtareas

Cuando se indique crear subtareas:

1. Revisar todos los issues en **"Todo"**.
2. Evaluar título y descripción para determinar viabilidad.
3. Para funcionalidades complejas:
  - Generar subtareas con prefijo `[subtask]`.
  - Aplicar el principio de responsabilidad única.
  - Especificar rutas exactas dentro del workspace.
  - Crear tareas separadas para pruebas, documentación y configuración.
4. Mover las subtareas a **"Backlog"**.
5. Comentar en el issue original con enlaces.
6. Mover el issue original a **"Backlog"**.

---

## 🤖 Agente `leitocodexbot`

### Rol principal
Automatizar tareas operativas: generación de código, ramas, PRs, comentarios, issues y gestión del tablero.

### Permisos
- Lectura/escritura en todos los repos.
- Crear y editar issues.
- Crear ramas: `feature/`, `bugfix/`, `docs/`, `refactor/`
- Hacer commits estructurados.
- Generar y comentar Pull Requests.
- Etiquetar y mover issues.
- Asignar PRs a `leitolarreta`.

### Buenas prácticas
- Referenciar el número del issue (`Closes #n`).
- Titular PRs con `[auto]`.
- Evitar alterar archivos binarios o sensibles.
- Ramas con nombres claros y descriptivos.

### Restricciones
- ❌ No hacer merges automáticos.
- ❌ No eliminar ramas remotas.
- ❌ No modificar archivos críticos sin aprobación (`.env`, `settings.gradle`, etc.)

---

## 🌱 Nomenclatura de Ramas

| Tipo            | Prefijo            | Uso                                  |
|-----------------|--------------------|---------------------------------------|
| Funcionalidad   | `feature/<desc>`   | Nuevas características                |
| Corrección      | `bugfix/<desc>`    | Correcciones de errores               |
| Documentación   | `docs/<desc>`      | Actualizaciones de documentación      |
| Refactorización | `refactor/<desc>`  | Reestructuración sin impacto externo  |

---

## 📦 Pull Requests generados

- Título: `[auto] <descripción>`
- Descripción técnica clara.
- Relacionado con un issue.
- Asignado a `leitolarreta`.
- Comentar en el issue con link al PR.
- ❌ No hacer merge del PR por parte del bot.

---

## ✅ Consideraciones Finales

El agente `leitocodexbot` es un asistente automatizado que potencia la eficiencia del equipo, pero **nunca reemplaza la revisión ni la decisión humana**.  
Su funcionamiento correcto es clave para garantizar trazabilidad, claridad y fluidez en el desarrollo.
