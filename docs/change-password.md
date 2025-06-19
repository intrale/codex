# Cambio de Contraseña

Este documento detalla el funcionamiento del endpoint `ChangePassword` dentro del módulo `users`.

## Descripción
El endpoint permite que un usuario actualice su contraseña mediante una solicitud autenticada.

## Uso Básico
1. El cliente envía una petición `POST` a `/change-password` con los campos `currentPassword` y `newPassword`.
2. El sistema valida la contraseña actual y actualiza el registro del usuario.
3. Se devuelve una respuesta confirmando el cambio.

## Consideraciones
- Se debe enviar el token de autenticación en la cabecera `Authorization`.
- La nueva contraseña debe cumplir con las reglas de seguridad definidas.
- Si la validación falla se retornará un código de error descriptivo.

Relacionado con #69.
