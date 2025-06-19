# agents.md

## 📘 Descripción General

Este documento define la configuración y comportamiento esperado del agente automatizado `leitocodexbot` en el entorno de desarrollo de la organización **`intrale`** en GitHub.

`leitocodexbot` tiene un rol auxiliar orientado a tareas repetitivas del ciclo de desarrollo, permitiendo trazabilidad y eficiencia sin reemplazar la supervisión humana.

---

## 🔧 Consideraciones Iniciales

- Todos los comentarios, commits y PRs deben estar en **Español Latinoamericano**.
- El entorno cuenta con `GITHUB_TOKEN` con permisos sobre toda la organización.
- Organización y tablero objetivo en GitHub: **`intrale`**
- Toda tarea debe estar relacionada con un **issue** existente en el tablero.
- Toda tarea se considera **"Ready"** cuando:
    - Se ha creado un Pull Request (PR) asociado.
    - El PR está asignado al usuario `leitolarreta`.
    - El issue está vinculado al PR mediante `Closes #<número de issue>`.
- Si no se genera un Pull Request, la tarea se considera **incompleta**, incluso si los cambios fueron aplicados localmente.
- Toda tarea que finalice con éxito debe:
    - Mover el issue a la columna **"Ready"**.
    - Comentar en el issue con un resumen de lo realizado y un enlace al PR generado.
- Toda tarea que no pueda completarse debe:
    - Mover el issue a la columna **"Blocked"**.
    - Comentar el motivo del bloqueo y adjuntar el **stacktrace** si aplica.
- No puede haber issues asignados a `leitocodexbot` en la columna **"In Progress"** al finalizar una ejecución de tareas.

---

## 🧪 Validación previa a la ejecución

Antes de ejecutar cualquier acción de tipo **"trabajar"** o **"refinar"**, el agente `leitocodexbot` debe realizar una **verificación obligatoria de entorno** para asegurarse de que puede generar entregables correctamente.

### 🔍 Validaciones requeridas:

1. **Prueba de generación de Pull Requests**
    - El agente debe verificar que puede crear un Pull Request en el repositorio de trabajo actual.

2. **Verificación de asignación de PR**
    - El agente debe confirmar que puede asignar correctamente un Pull Request al usuario `leitolarreta`.

### ❌ Si alguna validación falla:
- El agente debe **crear automáticamente una issue** con el título:  
  `⚠️ Problema de entorno detectado: imposibilidad de generar PRs`
- En la descripción debe incluir:
    - Qué validación falló (creación de PR o asignación).
    - Detalles técnicos del error recibido (mensaje o stacktrace).
    - Hora y contexto de la ejecución.
- Debe mover esta issue a la columna **"Todo"**.
- Debe asignarla directamente al usuario `leitolarreta`.

> ⚠️ Si esta validación falla, el agente **no debe continuar con ninguna otra ejecución**, ni intentar procesar tareas del tablero.

---

## 🔁 Ejecución de Tareas Automáticas

⚠️ Antes de ejecutar esta acción, debe completarse satisfactoriamente la validación de entorno descrita en la sección **🧪 Validación previa a la ejecución**.

Cuando se indique que el agente debe **"trabajar"**, debe:

1. Buscar todos los issues en la columna **"Todo"** del tablero.
2. Para cada issue:
    - Intentar mover a **"In Progress"**.
    - Si no puede moverlo por cualquier motivo (permisos, estructura, inconsistencia del issue, error interno), debe:
        - Mover la tarea a **"Blocked"** inmediatamente.
        - Comentar el motivo completo del fallo, incluyendo cualquier error técnico o condición encontrada.
        - Esto garantiza que cualquier observador del tablero pueda ver en tiempo real el intento y su resultado.
    - Si logra moverlo:
        - Analizar el título y la descripción.
        - Determinar si puede resolver la tarea automáticamente.
        - Si puede:
            - Asignarlo a `leitocodexbot`.
            - Crear una rama con el nombre relacionado al issue.
            - Ejecutar los cambios requeridos (ya sean de código, pruebas o documentación).
            - Realizar comentarios parciales de progreso en el issue.
            - Comentar en el issue lo realizado.
            - Generar **obligatoriamente** un Pull Request con los cambios realizados y asignarlo a `leitolarreta`.
            - Si no se puede generar el PR, aplicar el protocolo de reintento (ver sección siguiente).
            - Mover a **"Ready"** solo si el Pull Request fue creado correctamente.
        - Si no puede resolverla:
            - Mover a **"Blocked"**.
            - Comentar el motivo y adjuntar el **stacktrace** si aplica.

3. Validaciones al finalizar:
    - No debe haber issues asignados a `leitocodexbot` en **"In Progress"**.
    - No debe haber issues en la columna **"Todo"**.
    - Si quedan sin ejecutar, debe comentarse el motivo.

> 📌 Si no se genera un Pull Request, la tarea se considerará incompleta, incluso si los cambios fueron aplicados localmente.

---

## 🔄 Generación de Pull Requests al ejecutar tareas

Siempre que la ejecución de una tarea involucre cambios en el código fuente o documentación, el agente debe:

1. Crear una nueva rama usando el prefijo adecuado (`feature/`, `bugfix/`, `refactor/`, `docs/`) y un nombre descriptivo.
2. Realizar los commits correspondientes en esa rama.
3. Intentar generar automáticamente un Pull Request con las siguientes características:
    - Título: `[auto] <descripción breve del cambio realizado>`
    - Descripción técnica clara y directa.
    - Referencia al issue mediante `Closes #<número de issue>`.
    - Asignado al usuario `leitolarreta`.

4. En caso de que la creación del Pull Request falle:
    - El agente debe **reintentar hasta 3 veces** la creación del PR.
    - Si tras 3 intentos sigue fallando, debe:
        - Mover el issue a la columna **"Blocked"**.
        - Comentar en el issue detallando el motivo técnico del fallo y que se intentó varias veces.
        - Incluir el **stacktrace o mensaje de error** recibido, si aplica.

5. Si el PR se crea correctamente:
    - Comentar en el issue ejecutado indicando:
        - Qué se hizo.
        - Enlace directo al PR creado.
    - Mover el issue a **"Ready"**.

6. ❌ **No debe hacer merge del PR automáticamente.**

---

## 🔹 Creación de Subtareas

⚠️ Antes de comenzar, debe completarse satisfactoriamente la validación de entorno descrita en la sección **🧪 Validación previa a la ejecución**.

Cuando se indique que el agente debe **"refinar"**, debe:

1. Revisar todos los issues en **"Todo"**.
2. Mover el issue a **"In Progress"**.
    - Si no se puede mover por cualquier motivo, se debe pasar a **"Blocked"** e indicar claramente el error técnico o motivo específico del rechazo.
3. Evaluar título y descripción para determinar viabilidad.
4. Para funcionalidades complejas:
    - Generar subtareas con prefijo `[subtask]`.
    - Aplicar el principio de responsabilidad única (una tarea por objetivo).
    - En cada subtarea:
        - Indicar de forma clara y **técnica** el **nombre exacto** del componente, clase, función o endpoint involucrado.
        - Incluir la **ruta completa** dentro del workspace para ubicar el componente (por ejemplo: `/workspace/users/src/domain/usecase/RegisterUserUseCase.kt`).
        - No deben dejarse referencias genéricas ni vagas como “el controlador de usuarios”.
        - Redactar la descripción utilizando la estructura estándar definida en la sección **📝 Estructura de Issues Generadas Automáticamente**.
5. Crear tareas separadas para pruebas, documentación y configuración si corresponde.
6. Mover las subtareas a **"Backlog"**.
7. Agregar a la descripción del issue original los enlaces a cada subtarea creada.
8. Mover el issue original a **"Backlog"**.
9. **Priorizar las subtareas creadas**, ubicándolas en la parte superior de la columna **"Backlog"** para garantizar visibilidad.

---

## 📝 Estructura de Issues Generadas Automáticamente

Toda issue o sub-issue que sea creada automáticamente por el agente `leitocodexbot` debe seguir una estructura estandarizada en **Español Latinoamericano**, respetando el siguiente formato:

#### ✅ Estructura:

- ## 🎯 Objetivo
  Breve descripción del propósito de la tarea o funcionalidad.

- ## 🧠 Contexto
  Antecedentes relevantes o descripción del comportamiento actual.

- ## 🔧 Cambios requeridos
  Lista de acciones, componentes y archivos involucrados que deben modificarse.

- ## ✅ Criterios de aceptación
  Requisitos funcionales claros que deben cumplirse para considerar la tarea finalizada.

- ## 📘 Notas técnicas
  Guía para la implementación, consideraciones de estilo o decisiones de diseño/código específicas.

> 📌 Esta estructura debe aplicarse **en todas las tareas** generadas automáticamente, incluyendo subtareas de refinamiento.
> El contenido debe ser claro, técnico y sin ambigüedades, para facilitar su comprensión por cualquier desarrollador.

---

## 📚 Generación y Actualización de Documentación

Cuando el agente genera o actualiza documentación, debe:

1. **Ubicación obligatoria:**  
   Toda la documentación debe crearse o modificarse dentro del directorio:  
   `/workspace/codex/docs/`

2. **Acciones permitidas:**
    - Crear nuevos documentos relacionados con funcionalidades, módulos o arquitectura.
    - Actualizar documentos existentes si están dentro del directorio indicado.

3. **Restricciones:**
    - ❌ **No debe modificar** el archivo `agents.md` bajo ninguna circunstancia.
    - ❌ No debe generar archivos fuera de `/workspace/codex/docs/`.

4. **Buenas prácticas al documentar:**
    - Incluir referencias claras al módulo o componente involucrado.
    - Usar títulos, secciones y ejemplos para facilitar la comprensión.
    - Indicar si la documentación está relacionada con un issue o PR (`Relacionado con #n`).

5. **Gestión del Pull Request:**
    - Crear un **Pull Request automático** con el título `[auto][docs] Actualización de documentación`.
    - Relacionar el PR con el issue correspondiente mediante `Closes #n`.
    - Asignar el PR al usuario humano `leitolarreta`.
    - Comentar en el issue correspondiente con un resumen de los cambios y un enlace al PR generado.
    - ❌ **No hacer merge del PR automáticamente**.

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
- Cuando se generen pruebas unitarias, revisar el resultado de cobertura de código y en caso de que se alcance un valor superior a la cobertura mínima requerida, ajustar la configuración del proyecto para que utilice el nuevo valor y generar un comentario en el issue indicando el porcentaje alcanzado.

### Restricciones
- ❌ No hacer merges automáticos.
- ❌ No eliminar ramas remotas.
- ❌ No modificar archivos críticos sin aprobación (`.env`, `settings.gradle`, etc.)
- ❌ No se puede modificar la configuración de cobertura de código por un valor inferior al actual para ningún módulo.

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
**Toda ejecución que implique cambios debe generar obligatoriamente un Pull Request.**  
**Toda tarea que no pueda moverse a "In Progress" debe bloquearse de inmediato con su motivo técnico.**  
**Antes de ejecutar cualquier acción, debe validarse la capacidad de generar PRs y asignarlos correctamente.**
