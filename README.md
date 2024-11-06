# TARERIO - Frontend de la Aplicación de Gestión de Tareas y Agenda para Estudiantes PTVAL

## Descripción del Proyecto

El frontend de TARERIO es una aplicación móvil desarrollada en Dart/Flutter que permite a los estudiantes, profesores y administradores del Centro San Rafael acceder a sus aulas virtuales, tareas y funcionalidades de comunicación. Este repositorio contiene la primera iteración de la aplicación, que incluye las pantallas principales, widgets personalizados, y la conexión con el backend mediante APIs específicas para el registro, inicio de sesión y gestión de tareas.

## Estructura del Proyecto

Este es el árbol de directorios actual de la primera iteración del proyecto:

```bash
.
├── API
│   ├── inicioSesionAPI.dart
│   ├── registrarAlumnoAPI.dart
│   ├── registrarProfesorAPI.dart
│   └── TareaJuegoAPI.dart
├── main.dart
├── Models
│   └── menuAccesible.dart
├── Pages
│   ├── crearTareaJuego.dart
│   ├── home.dart
│   ├── inicioAdministradorProfesor.dart
│   ├── inicioAlumno.dart
│   ├── patronAlumno.dart
│   ├── principalAdministrador.dart
│   ├── principalAlumno.dart
│   ├── registrarAlumno.dart
│   └── registrarProfesor.dart
└── Widgets
    ├── AppBarDefault.dart
    ├── Avatar.dart
    ├── DefaultButton.dart
    ├── DefaultSwitch.dart
    ├── ErrorModal.dart
    ├── Header.dart
    ├── InformationModal.dart
    ├── Navbar.dart
    ├── SuccessModal.dart
    └── TextFieldDefault.dart
```

## Funcionalidades Clave

1. **Inicio de Sesión y Registro**:
    - Registro de alumnos y profesores mediante llamadas a la API.
    - Inicio de sesión seguro para administradores, profesores y alumnos.

2. **Gestión de Tareas**:
    - Creación de tareas de tipo "Juego" por parte de los profesores.
    - Visualización y actualización de estado de las tareas asignadas.

3. **Navegación Dinámica**:
    - Interfaz adaptada para diferentes roles de usuario (alumno, profesor, administrador).
    - Navegación entre pantallas mediante un flujo estructurado y modales informativos.

## UI/UX

Para el desarrollo de la interfaz se han diseñado mockups y wireframes que se incluirán en esta sección para mantener una referencia visual de cada iteración:

### Pantalla Principal


![Mockup de Pantalla Principal](mockups/pantalla0.png)

## Diagrama de navegación de la aplicación


![Diagrama de Navegación](mockups/diagrama.png)


## Configuración e instalación

Para instalar y ejecutar la aplicación en un entorno local, se deben seguir los siguientes pasos:

1. Clonar el repositorio en la máquina local.

```bash
git clone https://github.com/tuusuario/tarerio-frontend.git
cd tarerio-frontend
```

2. Instalar las dependencias del proyecto.

```bash
flutter pub get
```

3. Ejecutar la aplicación en un emulador o dispositivo físico.

```bash
flutter run
```

## Mockups TARERIO

### Pantalla de Selección de Tipo de Usuario
Selecciona entre "Alumno" o "Administrador/Profesor".
![Pantalla de selección de tipo de usuario](https://github.com/user-attachments/assets/5b360f0b-e779-402b-be1f-c8845a4333fe)

### Formulario de Acceso de Administrador/Profesor
Formulario de inicio de sesión para el acceso de administradores o profesores.
![Formulario de acceso de administrador/profesor](https://github.com/user-attachments/assets/d46a5c89-3687-4c22-932f-96a6323b43b2)

### Panel de Gestión del Administrador - Panel de Aulas
Vista del panel de gestión de aulas para el administrador.
![Panel de gestión del administrador - Panel de Aulas](https://github.com/user-attachments/assets/afb74d58-4cf6-41b8-bd1f-4b305d620637)

### Pantalla de Creación de Aulas
Formulario para crear una nueva aula.
![Pantalla de creación de aulas](https://github.com/user-attachments/assets/162f8cab-669c-42b8-9aea-aaf6683c76b2)

### Pantalla de Edición de Aulas
Interfaz para editar la información de un aula existente.
![Pantalla de edición de aulas](https://github.com/user-attachments/assets/f5f024d9-966f-4ee1-9068-9b42b7926d80)

### Diálogo para Asignar Profesor a un Aula
Diálogo de selección para asignar un profesor a un aula específica.
![Diálogo para asignar profesor a un aula](https://github.com/user-attachments/assets/e426394a-07bc-40b0-939a-e3c8b6996f1a)

### Panel de Gestión del Administrador - Panel de Educadores
Vista del panel de gestión de educadores para el administrador.
![Panel de gestión del administrador - Panel de Educadores](https://github.com/user-attachments/assets/19024397-92b2-4fe2-afc0-da5e20f2acb1)

### Pantalla de Creación de Educadores
Formulario para registrar un nuevo educador.
![Pantalla de creación de educadores](https://github.com/user-attachments/assets/28578dcb-b493-4ef1-b97d-a10c87c276c2)

### Pantalla de Edición de Profesores
Interfaz para modificar los datos de un profesor registrado.
![Pantalla de edición de profesores](https://github.com/user-attachments/assets/7f28a5b3-90c8-4ddc-856a-f78c6e557d3c)

### Panel de Gestión del Administrador - Panel de Alumnos
Vista del panel de gestión de alumnos para el administrador
![Panel de Gestión del Administrador - Panel de Alumnos ](https://github.com/user-attachments/assets/3b7665cc-134b-430e-ba9c-b2b70094e128)

### Pantalla de Creación de Alumnos
Formulario para registrar un nuevo alumno.
![Pantalla de Creación de Alumnos](https://github.com/user-attachments/assets/9dd6cb81-e04a-43f2-abb4-5335943107b8)

### Pantalla de Selección del Perfil del Alumno
Vista para que el alumno seleccione su perfil.
![Pantalla de selección del perfil del alumno](https://github.com/user-attachments/assets/274a2424-adf8-47b0-8d78-eab1f8b35fb6)

### Pantalla de Selección del Patrón del Alumno
Interfaz para que el alumno seleccione su patrón para iniciar sesión.
![Pantalla de selección del patrón del alumno](https://github.com/user-attachments/assets/4ddca717-c05e-487a-9403-217a71a87837)

<br>

¡Gracias por tu interés en TARERIO!
