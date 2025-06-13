# agents.md

## Descripción General

Este archivo documenta la configuración y el comportamiento esperado de los agentes automatizados en este entorno de desarrollo. 
Se utiliza un agente personalizado que actúa bajo una identidad específica para mantener trazabilidad y control sobre sus acciones.

---
## Consideraciones Iniciales
- Todos los comentarios y descripciones utilizadas por codex o derivados tienen que estar realizadas en idioma Español Latinoamericano
- El entorno tiene configurada la variable "GITHUB_TOKEN" con los permisos necesarios para acceder a toda la organizacion en github
- El nombre de la organizacion en github es "intrale"
- El nombre del tablero en github es "intrale"
- Siempre que se comience a procesar / trabajar con un issue asignarlo al agente automatico identificado en github como “leitocodexbot”
- Cuando se indique que busque nuevas tareas a realizar, debe buscar en el tablero los issues que se encuentran en la columna de "Todo" o en "Blocked"
- Cuando se finalice con la ejecucion de un issue moverlo a la columna "Ready"
- Si la ejecucion de un issue finaliza con error, muevalo a la columna "Blocked" y añada un comentario con el detalle del error.
- El entorno actual contiene en el directorio “workspace” en carpetas independientes todos los repositorios clonados que están involucrados.
- Si considera que una tarea es demasiado grande como para poder ejecutarla y llevarla adelante, en lugar de ejecutar la tarea, cree tantos sub-issues como considere conveniente asociados al inicial para subdividir el issue en porciones que puedan ser manipulables y muevalos a "AutoBacklog". Y luego mueva la tarea principal a "Blocked" con un comentario que haga referencia a que se subdividio el alcance de la misma.

## Agentes Definidos

### 🤖 `leitocodexbot` (usuario personalizado)

**Rol:**  
Agente automatizado principal que interactúa con el repositorio para resolver issues, generar código, crear ramas y pull requests. Opera bajo una cuenta de usuario propia para diferenciar claramente las acciones humanas de las automatizadas.

**Permisos:**
- Lectura y escritura en el repositorio
- Creación y edición de issues
- Creación de ramas (`feature/*`, `bugfix/*`, `docs/*`, `refactor/*`)
- Realización de commits con mensajes claros y estructurados
- Creación de Pull Requests
- Asignación de etiquetas a issues y PRs
- Comentarios automáticos en issues o PRs

**Buenas prácticas:**
- Referenciar el número de issue relacionado en los commits (`Closes #<número>`)
- Usar nombres de ramas consistentes
- Evitar modificaciones innecesarias en archivos binarios
- Asignar PRs al responsable humano designado con nombre de usuario "leitolarreta"
- Agregar el prefijo `[auto]` en los títulos de los PRs generados

**Restricciones:**
- No realizar merges sin revisión
- No eliminar ramas remotas automáticamente
- No modificar archivos sensibles (por ejemplo: `.env`, `settings.gradle`, etc.) sin autorización
- No realizar modificaciones, commits ni PRs al repositorio "codex"

---

## Nomenclatura de ramas generadas

- `feature/<descripcion>` – Nuevas funcionalidades
- `bugfix/<descripcion>` – Corrección de errores
- `docs/<descripcion>` – Cambios en documentación
- `refactor/<descripcion>` – Refactorizaciones técnicas

---

## Reglas para Pull Requests generados por el agente

- El título debe comenzar con `[auto]`
- El cuerpo del PR debe contener una descripción técnica del cambio
- Se debe vincular el PR con su issue correspondiente
- El PR debe estar asignado a un humano para su revisión designado con nombre de usuario "leitolarreta"
- El agente no debe realizar merges

---

## Consideraciones Finales

Este agente está diseñado para colaborar, no reemplazar, al equipo humano. Su uso busca maximizar la eficiencia del flujo de trabajo y reducir la carga operativa sobre tareas repetitivas, manteniendo siempre la supervisión humana.

