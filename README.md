# FormUsers

Aplicación Flutter para la gestión de usuarios y sus direcciones.

## Características

- Crear usuarios con nombre, apellido y fecha de nacimiento.
- Agregar, editar y eliminar direcciones para cada usuario.
- Seleccionar usuarios y editar su información.
- Navegación sencilla entre pantallas, siempre regresando al inicio con el botón "Atrás".

## Estructura del proyecto

- **lib/data/models/user.dart**  
  Modelos de datos para `User` y `Address`.
- **lib/features/user/provider/user_provider.dart**  
  Provider para la gestión de usuarios y direcciones.
- **lib/features/user/view/**  
  Pantallas para formularios y visualización de usuarios/direcciones.
- **test/**  
  Pruebas unitarias para los modelos y el provider.

## Instalación

1. Clona el repositorio:
   ```sh
   git clone https://github.com/tu-usuario/formusers.git
   ```
2. Instala las dependencias:
   ```sh
   flutter pub get
   ```
3. Ejecuta la aplicación:
   ```sh
   flutter run
   ```

## Pruebas

Para ejecutar los tests unitarios:

```sh
flutter test
```

Las pruebas cubren la lógica de los modelos y el provider, asegurando la correcta creación, edición y eliminación de usuarios y direcciones.

## Uso

- Desde la pantalla principal puedes crear nuevos usuarios.
- Selecciona un usuario para ver y editar su información.
- Agrega, edita o elimina direcciones asociadas a cada usuario.

## Requisitos

- Flutter 3.x o superior
- Dart 3.x o superior

## Licencia

MIT

---