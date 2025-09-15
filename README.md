# 📱 FormUsers - Aplicación Flutter de Gestión de Usuarios

Una aplicación Flutter moderna y robusta para la gestión de usuarios con direcciones, desarrollada siguiendo principios SOLID y mejores prácticas de arquitectura.

## 🚀 Características Principales

### ✨ Funcionalidades
- **Gestión de Usuarios**: Crear, editar y visualizar información de usuarios
- **Direcciones Completas**: Sistema de direcciones con país, departamento y municipio
- **Validaciones Robustas**: Validaciones en tiempo real y manejo de errores
- **Estados de Carga**: UI reactiva con indicadores de carga y manejo de errores
- **Navegación Intuitiva**: Flujo de 3 pantallas optimizado para UX


## 📋 Requisitos del Sistema

- Flutter SDK >= 3.1.5
- Dart >= 3.0.0
- Android Studio / VS Code
- Git

## 🛠️ Instalación y Configuración

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/formusers.git
cd formusers
```

### 2. Instalar Dependencias
```bash
flutter pub get
```

### 3. Ejecutar Tests
```bash
flutter test
```

### 4. Ejecutar la Aplicación
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web
flutter run -d web
```

## 📱 Pantallas de la Aplicación

### 1. **HomeScreen** - Lista de Usuarios
- Visualización de todos los usuarios registrados
- Información de edad y cantidad de direcciones
- Botón para crear nuevo usuario
- Manejo de estados de carga y errores

### 2. **UserFormScreen** - Formulario de Usuario
- Campos: Nombre, Apellido, Fecha de Nacimiento
- Validaciones en tiempo real
- Selector de fecha integrado
- Navegación automática al formulario de direcciones

### 3. **AddressFormScreen** - Formulario de Direcciones
- Campos: Calle, Ciudad, Departamento, Municipio, País
- Validaciones completas para todos los campos
- Lista de direcciones ya registradas
- Agregar múltiples direcciones por usuario

### 4. **UserSummaryScreen** - Resumen del Usuario
- Información completa del usuario
- Lista de todas las direcciones
- Edición inline de datos
- Gestión completa de direcciones (agregar, editar, eliminar)

## 🏛️ Arquitectura del Proyecto

```
lib/
├── data/
│   ├── models/              # Entidades de dominio
│   │   └── user.dart        # User y Address models
│   └── repositories/        # Capa de datos
│       └── user_repository.dart
├── features/user/
│   ├── provider/           # Gestión de estado
│   │   └── user_provider.dart
│   ├── services/           # Lógica de negocio
│   │   └── user_service.dart
│   └── view/              # Pantallas de UI
│       ├── home_screen.dart
│       ├── user_form_screen.dart
│       ├── address_form_screen.dart
│       └── user_summary_screen.dart
└── main.dart              # Configuración y DI
```

## 🧪 Testing

El proyecto incluye una suite completa de tests:

### Tests Unitarios
- **Modelos**: Validación de User y Address
- **Servicios**: Lógica de negocio con mocks
- **Providers**: Gestión de estado y errores

### Tests de Integración
- **Widgets**: Pruebas de UI y navegación
- **Flujos completos**: End-to-end testing

### Ejecutar Tests
```bash
# Todos los tests
flutter test
```

Las pruebas cubren la lógica de los modelos y el provider, asegurando la correcta creación, edición y eliminación de usuarios y direcciones.

## Uso

- Desde la pantalla principal puedes crear nuevos usuarios.
- Selecciona un usuario para ver y editar su información.
- Agrega, edita o elimina direcciones asociadas a cada usuario.

## 👨‍💻 Autor

**Yoider Yancy**
- GitHub: [@Yoider98](https://github.com/Yoider98)
- LinkedIn: [Yoider Yancy](https://www.linkedin.com/in/yoider-j-yancy-acu%C3%B1a/)

## Licencia

MIT

---

⭐ **¡Si te gusta este proyecto, no olvides darle una estrella!** ⭐
