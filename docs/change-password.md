# ChangePassword

Este módulo permite que un usuario autenticado actualice su contraseña en Cognito utilizando el endpoint `ChangePassword`. La clase principal se encuentra en `src/main/kotlin/ar/com/intrale/ChangePassword.kt` dentro del proyecto `users`.

## Uso básico

Se requiere enviar en el cuerpo de la solicitud los campos `previousPassword` y `proposedPassword`. El token de autorización debe incluirse en el header `Authorization`.

Relacionado con [intrale/users#67](https://github.com/intrale/users/issues/67).
