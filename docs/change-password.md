# Cambio de Contraseña

Este documento describe cómo utilizar la funcionalidad `ChangePassword` dentro del módulo `users`. La clase principal se encuentra en `/workspace/users/src/main/kotlin/ar/com/intrale/ChangePassword.kt`.

## Uso básico
Se requiere enviar en el cuerpo de la solicitud los campos `previousPassword` y `proposedPassword`. El token de autorización debe incluirse en el header `Authorization`.

Relacionado con [intrale/users#67](https://github.com/intrale/users/issues/67) y #69.
