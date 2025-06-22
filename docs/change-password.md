# Cambio de Contraseña

Este documento explica el flujo para modificar la contraseña de un usuario dentro del sistema.

## Pasos generales

1. El usuario autenticado envía la solicitud de cambio mediante el endpoint `/change-password`.
2. El sistema valida las credenciales actuales y la nueva contraseña.
3. Si la validación es exitosa, se actualiza la contraseña y se notifica el resultado.

## Consideraciones

- Esta funcionalidad forma parte del issue principal #3.
- La implementación se realizará en la clase `ChangePassword` dentro de `/workspace/users/src/main/kotlin/ar/com/intrale/ChangePassword.kt`.
- Las pruebas asociadas se ubicarán en `/workspace/users/src/test/kotlin/ar/com/intrale/ChangePasswordTest.kt`.

Relacionado con #69.
