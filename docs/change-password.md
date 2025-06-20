# Cambio de Contraseña

Este documento explica el funcionamiento del endpoint **ChangePassword** dentro del módulo `users`.

## Descripción

El endpoint permite que un usuario actualice su contraseña enviando las credenciales actuales y la nueva contraseña deseada.

## Uso del endpoint

1. Enviar una solicitud `POST` a `/users/change-password`.
2. Proveer en el cuerpo del mensaje los campos `username`, `password` y `newPassword`.
3. Si las credenciales son válidas, la contraseña se actualiza y se devuelve una respuesta exitosa.

Para más detalles consultar la clase `ChangePassword` en `/workspace/users/src/main/kotlin/ar/com/intrale/ChangePassword.kt`.

Relacionado con #69.
