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

---
## 🔁 Ejecución de Tareas Automáticas

1. **Antes de cualquier otra acción**, el agente debe intentar mover el issue a la columna **"In Progress"**.
2. Si no puede moverlo por cualquier motivo (permisos insuficientes, error interno, inconsistencias), debe:
    - Mover el issue a la columna **"Blocked"** inmediatamente.
    - Comentar en el issue indicando:
        - Motivo técnico detallado del fallo.
        - Stacktrace o mensaje de error recibido, si aplica.
3. Solo si logra mover el issue a **"In Progress"**:
    - Durante toda la ejecución de la tarea, el agente debe limitar sus operaciones exclusivamente al repositorio indicado en el issue. No debe realizar cambios, generar documentación, ni ejecutar acciones en otros repositorios, salvo que se trate de documentación global explícitamente definida (ver sección de documentación).
    - Si necesita operar con otro repositorio, debe:
        - Comentar en el issue que no puede realizar la acción solo en el repositorio actual por lo que procedera a crear un nuevo issue que contemple la parte que este issue no va a realizar por tratarse de otro repositorio.
        - Dejar el nuevo issue en estado **"Todo"**.
        - Avanzar con la ejecución de la tarea en el repositorio actual para la parte que sí puede realizar.
    - Analizar el título y la descripción.
    - Crear una rama con el nombre relacionado al issue, siguiendo la nomenclatura de ramas definida en la sección **🌱 Nomenclatura de Ramas**.
    - Si la rama ya existe:
        - Comentar en el issue que la rama ya fue creada previamente.
        - Actualizar el repositorio local con los últimos cambios de esa rama.
        - Verificar si ya hay un Pull Request abierto con esa rama como `head`.
            - Si existe, comentar en el issue que el PR ya está generado y evitar crear uno nuevo.
    - Determinar si puede resolver la tarea automáticamente.
4. Si puede resolverla:
    - Asignar el issue a `leitocodexbot`.
    - Ejecutar los cambios requeridos (código, pruebas o documentación).
    - Comentar en el issue lo realizado.
    - Generar **obligatoriamente** un Pull Request con los cambios y asignarlo a `leitolarreta`.
    - Si no se puede generar el PR, aplicar el protocolo de reintento.
    - Mover el issue a **"Ready"** solo si el Pull Request fue creado correctamente.
5. Si no puede resolverla:
    - Mover el issue a **"Blocked"**.
    - Comentar el motivo y adjuntar el **stacktrace** si aplica.
6. Validar que no haya dependencias activas no resueltas (por ejemplo, campo `Blocked by #n` en la descripción o etiquetas).

> 📌 Si no se genera un Pull Request, la tarea se considerará incompleta, incluso si los cambios fueron aplicados localmente.

---

## 🔄 Generación de Pull Requests al ejecutar tareas
Tener en cuenta que los Pull Requests deben generarse con 
curl -X POST -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
-d '{"title":"<titulo>","head":"<rama>","base":"main","body":"Closes #<issue_number>"}' \
https://api.github.com/repos/intrale/<repo>/pulls

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

## 🔄 Flujo de refinamiento de tareas

Cuando se indique que el agente debe **"refinar"**, debe seguir estrictamente este flujo:

1. Revisar el issue que se intenta refinar.
2. **Antes de cualquier otra acción**, el agente debe intentar mover el issue a la columna **"In Progress"**.
3. Si no puede moverlo por cualquier motivo (permisos insuficientes, error interno, inconsistencias), debe:
    - Mover el issue a la columna **"Blocked"** inmediatamente.
    - Comentar en el issue indicando:
        - Motivo técnico detallado del fallo.
        - Stacktrace o mensaje de error recibido, si aplica.
4. Solo si logra mover el issue a **"In Progress"**:
    - Evaluar el título y la descripción para determinar viabilidad.
    - Analizar el issue a detalle y seguir la "Estructura de Issues Generadas Automáticamente":
        - Indicar de forma clara y **técnica** el **nombre exacto** de los componentes, clases, funciónes o endpoints involucrados.
        - Incluir las **rutas completas** dentro del workspace para ubicar los componentes (por ejemplo: `/workspace/users/src/domain/usecase/RegisterUserUseCase.kt`).
        - No deben dejarse referencias genéricas ni vagas como “el controlador de usuarios”.
        - Redactar la descripción utilizando la estructura estándar definida en la sección **📝 Estructura de Issues Generadas Automáticamente**.
    - Agregar detalle para pruebas, documentación y configuración si corresponde.
    - Mover el issue a **"Todo"**.

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
    - Toda la documentación debe crearse o modificarse dentro del directorio `docs` del repositorio donde se realizaron los cambios funcionales asociados a la tarea.
    - No debe generarse documentación en `/workspace/codex/docs/` si los cambios corresponden a otro repositorio.
    - La única excepción son los casos donde la documentación sea explícitamente global para toda la plataforma, en cuyo caso debe ubicarse en `/workspace/codex/docs/`.

2. **Acciones permitidas:**
    - Crear nuevos documentos relacionados con funcionalidades, módulos o arquitectura.
    - Actualizar documentos existentes si están dentro del directorio indicado.

3. **Restricciones:**
    - ❌ **No debe modificar** el archivo `agents.md` bajo ninguna circunstancia.
    - ❌ No debe ejecutar pruebas unitarias si la tarea es exclusivamente de documentación.

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
- Considerar que si desde un issue se intenta crear una rama esta debe tener relacion al nombre del issue y al prefijo correspondiente.
- Si el issue es una sub-tarea, la rama sobre la que trabajar debe ser la misma rama que la que utilizo el padre. Por lo tanto la nomenclatura de la rama debe provenir del padre para que todos los hijos puedan reutilizar la misma rama.
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
**Antes de ejecutar cualquier acción, debe validarse la capacidad de generar PRs, asignarlos correctamente, confirmar la autenticación activa y verificar el acceso al tablero de proyecto.**
**Las ejecuciones del agente deben ser únicas y no simultáneas.**
**El agente debe detectar y bloquear tareas estancadas que sigan en "In Progress" por más de 12 horas.**
---

## 🛠️ Instrucciones Operativas para Invocar Acciones

Para garantizar que el agente `leitocodexbot` interprete correctamente las acciones definidas en este documento, se recomienda utilizar las siguientes instrucciones explícitas al momento de interactuar con Codex:

### 🔹 Refinamiento de tareas
Para que el agente ejecute el refinamiento de todas las tareas pendientes en el tablero, se debe utilizar la instrucción: "refinar todas las tareas pendientes en el tablero de intrale"
Esto indicará al agente que debe buscar todos los issues en estado "Todo" y aplicar el flujo de refinamiento definido en este documento.

### 🔹 Ejecución de tareas
Para que el agente procese todas las tareas pendientes, se debe utilizar la instrucción: "trabajar todas las tareas pendientes en el tablero de intrale"
Esto indicará al agente que debe buscar todos los issues en estado "Todo" y ejecutar las acciones correspondientes, según lo definido en este documento.

### 🔹 Recomendaciones adicionales
- No deben utilizarse comandos ambiguos como solo `"refinar"` o `"trabajar"` sin contexto, ya que el agente puede solicitar información adicional.
- Si se desea refinar o trabajar un issue puntual, se debe indicar el número del issue de forma explícita.