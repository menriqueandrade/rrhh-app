# Employees App 📱

## 📋 Índice

- [Resumen del Proyecto](#-resumen-del-proyecto)
- [Demo](#-demo)
- [Arquitectura](#️-arquitectura)
- [Dependencias Principales](#️-dependencias-principales)
- [Configuración y Ejecución](#-configuración-y-ejecución)
- [Testing](#-testing)
- [Internacionalización](#-internacionalización)
- [Registro (Logging)](#-registro-logging)

## 📝 Resumen del Proyecto

Employees App es una aplicación Flutter diseñada para gestionar información de empleados de manera eficiente. Ofrece las siguientes funcionalidades:

- 📋 Visualizar una lista de empleados con paginación infinita (10 elementos por página)
- ➕ Agregar nuevos empleados con validación de datos
- ✏️ Editar información de empleados existentes
- 🔍 Filtrar y buscar empleados
- 🗑️ Eliminar registros de empleados

La aplicación utiliza Firebase como backend para el almacenamiento y recuperación de datos en tiempo real.



## 🏗️ Arquitectura

El proyecto implementa Clean Architecture con el patrón BLoC (Business Logic Component), siguiendo los principios SOLID. La estructura está organizada por features y capas:

```
lib/
├── app/
│   ├── app.dart
│   └── colors.dart
├── core/
│   └── di.dart
└── features/
    └── employees/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   ├── usecases/
        │   └── validators/
        └── presentation/
            ├── bloc/
            ├── screens/
            └── widgets/
```

### Capas de la Arquitectura:

- **Presentación**: Contiene las pantallas, widgets y BLoCs.
- **Dominio**: Define entidades, casos de uso y contratos de repositorios.
- **Datos**: Implementa repositorios y maneja fuentes de datos.

## 🛠️  Dependencias Principales

```yaml
dependencies:
 intl: ^0.19.0
  bloc: ^8.1.4
  equatable: ^2.0.5
  flutter_bloc: ^8.1.6
  firebase_core: ^3.6.0
  get_it: ^8.0.0
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.3
  image_picker: ^1.1.2
  uuid: ^4.5.1
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
  fake_cloud_firestore: ^3.0.3
  firebase_storage_mocks: ^0.7.0
  cached_network_image: ^3.4.1
  faker: ^2.2.0
  talker: ^4.4.1
  talker_flutter: ^4.4.1
  talker_bloc_logger: ^4.4.1
```

## 🚀 Configuración y Ejecución

0. **Requisitos Previos**
   - Flutter versión 3.24.3

1. **Clonar el Repositorio**
   ```bash
   git clone https://github.com/Armirene-Jose-Jimenez/rrhh-app
   cd rrhh-app
   ```

2. **Instalar Dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar Archivos de Localización**
   ```bash
   flutter gen-l10n
   ```
   
4. **Ejecutar la Aplicación**
   ```bash
   flutter run
   ```

## 🧪 Testing

La estrategia de testing cubre diferentes componentes de la aplicación:

```
test/
└── features/
    └── employees/
        ├── data/
        │   ├── datasources/
        │   └── repositories/
        ├── domain/
        │   ├── usecases/
        │   └── validators/
        └── presentation/
            └── bloc/
```

### Componentes Probados

- **Validators**: Pruebas para las funciones de validación de datos de empleados.
- **Usecases**: Verificación de la lógica de negocio, como la generación de correos electrónicos de empleados.
- **BLoCs**: Pruebas para la lógica de estado en los BLoCs, tanto para el formulario como para la lista de empleados.
- **Datasources**: Validación de la interacción con las fuentes de datos de Firebase.
- **Repositories**: Aseguran el correcto funcionamiento de los repositorios de empleados y archivos.

### Ejecutar Tests

```bash
flutter test
```

Para ver un informe detallado de la cobertura de pruebas, puedes ejecutar:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Esto generará un informe HTML que puedes ver en tu navegador abriendo el archivo `coverage/html/index.html`.

## 🌐 Internacionalización

La aplicación soporta múltiples idiomas:

- 🇪🇸 Español
- 🇺🇸 Inglés

Los archivos de traducción se encuentran en `lib/l10n/`. Para agregar o modificar traducciones, edita los archivos ARB correspondientes y ejecuta `flutter gen-l10n`.


## 📊 Registro (Logging)

Para el sistema de registro (logging) de la aplicación, se ha implementado el paquete Talker. Este robusto sistema de logging se utiliza para:

1. Registrar las operaciones realizadas en los repositorios.
2. Monitorear las acciones y cambios de estado en los BLoCs.

Además, para facilitar la depuración y el análisis en tiempo real, se ha incorporado una característica especial en la interfaz de usuario:

- 🔍 Un botón dedicado que permite visualizar los registros directamente desde la interfaz de la aplicación.

Esta funcionalidad mejora significativamente la capacidad de diagnóstico y seguimiento del comportamiento de la aplicación durante el desarrollo y en producción.

