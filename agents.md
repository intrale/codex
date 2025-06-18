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
- Cuando se inicie el procesamiento de un issue:
  - Debe **asignarse automáticamente al usuario `leitocodexbot`**.
  - Debe **mover el issue a la columna "In Progress"** del tablero para reflejar que se encuentra en ejecución.
- Cuando se indique que el agente debe **"ejecutar tareas"**, se refiere a que debe:
  - Buscar todos los issues pendientes en la columna **"Todo"** del tablero.
  - Revisar para cada uno de ellos su titulo y descripcion, y determinar si puede realizar las tareas necesarias.
  - Ejecutar cada una de las tareas detalladas en el paso anterior.
  - Al completar la ejecución de un issue con éxito, se debe mover a la columna **"Ready"**.
  - Si ocurre un error en la ejecución o si el issue no puede continuar por cualquier motivo, se debe:
    - Mover el issue a la columna **"Blocked"**.
    - Agregar un comentario explicando el motivo de la detención o el error.
    - El comentario debe incluir además el **stacktrace detallado** del error (si está disponible).
    - El equipo humano deberá revisar manualmente la causa del bloqueo.
- Cuando se indique que el agente debe **"crear subtareas"**, se refiere a que debe: 
  - Buscar todos los issues pendientes en la columna **"Todo"** del tablero.
  - Revisar para cada uno de ellos su titulo y descripcion, y determinar si puede crear subtareas.
  - Teniendo en cuenta la documentacion proporcionada en la carpeta docs crear todos los sub-issues asociados a este issue principal para construir los componentes que sean necesarios para resolver la funcionalidad detallada
  - El detalle que se incluya en cada subissue debe ser lo suficientemente claro para que un desarrollador pueda entender qué se espera de él.
  - Las referencias a componentes, clases o funciones deben ser claras y concisas, evitando ambigüedades e indicando la ruta exacta donde encontrarlos.
  - Mover las nuevas tareas a la columna **"Backlog"** del tablero.
  - Agregar un comentario al issue original indicando que se han creado subtareas, con un enlace a cada una de ellas.
  - Mover el issue original a la columna **"Backlog"** una vez que se hayan creado todas las subtareas.
- Buscar todos los issues pendientes en la columna **"Todo"** del tablero.
  - Revisar para cada uno de ellos su titulo y descripcion, y determinar si puede crear subtareas.
  - Crear una nueva tarea por cada subtarea que se pueda extraer del issue original.
  - Asignar las nuevas tareas al usuario `leitocodexbot`.
  - Mover las nuevas tareas a la columna **"Todo"** del tablero.
  - Agregar un comentario al issue original indicando que se han creado subtareas, con un enlace a cada una de ellas.
- **Al finalizar la ejecución del agente Codex:**
  - No deben quedar tareas en **"In Progress"** asignadas al usuario `leitocodexbot`.  
    Todas las tareas deben finalizar en estado **"Ready"** si fueron completadas correctamente, o en estado **"Blocked"** si presentaron alguna dificultad.
  - No deben quedar tareas en la columna **"Todo"**.  
    Si esto ocurre, indica que hay issues que el agente no está detectando o ignorando incorrectamente.

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
- Descripción técnica clara en el cuerpo del PR asociado al issue que origina el cambio
- Asignado al revisor humano `leitolarreta`
- Sin acción de merge por parte del agente
- Comentar el issue relacionado en el tablero de proyecto con el link al PR generado

---

## ✅ Consideraciones Finales

El agente `leitocodexbot` no reemplaza la revisión humana.  
Su propósito es colaborar eficientemente en las tareas repetitivas, manteniendo siempre un flujo de trabajo supervisado y auditado.
