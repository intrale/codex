# agents.md

## 📘 Descripción General

Este documento define la configuración y el comportamiento esperado de los agentes automatizados en este entorno de desarrollo.  
Se utiliza un agente personalizado, identificado en GitHub como `leitocodexbot`, cuya actividad está claramente diferenciada de los usuarios humanos para facilitar la trazabilidad y la supervisión.

---

## 🔧 Consideraciones Iniciales

- Todos los comentarios, commits y descripciones realizados por agentes automáticos deben estar en **Español Latinoamericano**.
- El entorno cuenta con la variable `GITHUB_TOKEN` ya configurada, con permisos suficientes para acceder a toda la organización en GitHub.
- Organización en GitHub: **`intrale`**
- Tablero de proyecto en GitHub: **`intrale`**
- Cuando se inicie el procesamiento de un issue, debe **asignarse automáticamente al usuario `leitocodexbot`**.
- Cuando se indique que el agente debe **"buscar tareas"**, se refiere a que debe:
    - Buscar issues pendientes en las columnas **"Todo"** o **"Blocked"** del tablero.
    - Ejecutarlos siguiendo los pasos definidos en este documento.
- Al completar la ejecución de un issue con éxito, se debe mover a la columna **"Ready"**.
- Si ocurre un error en la ejecución, se debe mover el issue a **"Blocked"** y agregar un comentario detallando el motivo del fallo.
- Todos los repositorios involucrados están disponibles en el directorio `workspace`, cada uno en su carpeta correspondiente.
- Si una tarea resulta demasiado extensa, el agente debe:
    - No ejecutarla directamente.
    - Crear **sub-issues** asociados para dividir el trabajo en partes manejables.
    - Mover los sub-issues a la columna **"AutoBacklog"**.
    - Mover el issue original a **"Blocked"** con un comentario explicativo.

---

## 🤖 Agente Definido: `leitocodexbot`

**Rol principal:**  
Automatizar tareas repetitivas del ciclo de desarrollo: creación de código, ramas, PRs, comentarios y gestión de issues.

**Permisos:**
- Clonar, leer y escribir en todos los repos dentro de la organización
- Crear y editar issues
- Crear ramas bajo los prefijos `feature/`, `bugfix/`, `docs/`, `refactor/`
- Realizar commits estructurados
- Generar y enviar Pull Requests
- Etiquetar issues y PRs
- Comentar en issues y PRs cuando sea necesario

**Buenas prácticas:**
- Siempre referenciar el número del issue asociado (ej. `Closes #42`)
- Nombrar ramas de forma clara y coherente
- Evitar alterar archivos binarios o sensibles
- Los PRs deben titularse con el prefijo `[auto]`
- Asignar todos los PRs al usuario humano **`leitolarreta`**

**Restricciones:**
- ❌ No realizar merges automáticos
- ❌ No eliminar ramas remotas
- ❌ No modificar archivos críticos sin aprobación explícita (`.env`, `settings.gradle`, etc.)
- ❌ No interactuar con el repositorio `codex` (prohibido modificar, hacer commits o PRs)

---

## 🌱 Nomenclatura de ramas

| Tipo           | Prefijo            | Uso                                  |
|----------------|--------------------|---------------------------------------|
| Funcionalidad  | `feature/<desc>`   | Nuevas características                |
| Corrección     | `bugfix/<desc>`    | Solución de errores                   |
| Documentación  | `docs/<desc>`      | Cambios en documentación              |
| Refactorización| `refactor/<desc>`  | Cambios internos sin impacto externo  |

---

## 📦 Pull Requests generados por `leitocodexbot`

- Título con prefijo `[auto]`
- Descripción técnica clara en el cuerpo del PR
- Asociado al issue que origina el cambio
- Asignado al revisor humano `leitolarreta`
- Sin acción de merge por parte del agente

---

## ✅ Consideraciones Finales

El agente `leitocodexbot` no reemplaza la revisión humana.  
Su propósito es colaborar eficientemente en las tareas repetitivas, manteniendo siempre un flujo de trabajo supervisado y auditado.
