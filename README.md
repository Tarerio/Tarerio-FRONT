# TARERIO - Frontend de la Aplicación de Gestión de Tareas y Agenda para Estudiantes PTVAL

## Descripción del Proyecto

El frontend de TARERIO es una aplicación móvil desarrollada en Dart/Flutter que permite a los estudiantes, profesores y administradores del Centro San Rafael acceder a sus aulas virtuales, tareas y funcionalidades de comunicación. Este repositorio contiene la primera iteración de la aplicación, que incluye las pantallas principales, widgets personalizados, y la conexión con el backend mediante APIs específicas para el registro, inicio de sesión y gestión de tareas.

## Estructura del Proyecto

Este es el árbol de directorios actual de la primera iteración del proyecto:

```bash
├── lib
│   ├── API
│   │   ├── alumnosAPI.dart
│   │   ├── aulasAPI.dart
│   │   ├── inicioSesionAPI.dart
│   │   ├── profesoresAPI.dart
│   │   ├── tareaJuegoAPI.dart
│   │   ├── tareaPeticionAPI.dart
│   │   └── tareaPorPasosAPI.dart
│   ├── consts.dart
│   ├── main.dart
│   ├── Models
│   │   └── menuAccesible.dart
│   ├── Pages
│   │   ├── Administrador
│   │   │   └── principalAdministrador.dart
│   │   ├── Alumnos
│   │   │   ├── accesibilidad.dart
│   │   │   ├── alumnos.dart
│   │   │   ├── editarAlumno.dart
│   │   │   ├── inicioAlumno.dart
│   │   │   ├── patronAlumno.dart
│   │   │   ├── principalAlumno.dart
│   │   │   ├── registrarAlumno.dart
│   │   │   ├── tarea.dart
│   │   │   └── tareasdelalumno.dart
│   │   ├── Aulas
│   │   │   ├── alumnosDeAula.dart
│   │   │   ├── aulas.dart
│   │   │   ├── crearAula.dart
│   │   │   └── modificarAula.dart
│   │   ├── home.dart
│   │   ├── inicioAdministradorProfesor.dart
│   │   ├── Menus
│   │   │   └── menus.dart
│   │   ├── Profesores
│   │   │   ├── aularioProfesor.dart
│   │   │   ├── editarContraseniaProfesor.dart
│   │   │   ├── pedidosMaterial.dart
│   │   │   ├── profesores.dart
│   │   │   └── registrarProfesor.dart
│   │   └── Tareas
│   │       ├── asignacionTareaAlumno.dart
│   │       ├── crearTareaJuego.dart
│   │       ├── crearTareaPeticion.dart
│   │       ├── crearTareaPorPasos.dart
│   │       ├── editarTareas.dart
│   │       └── tareas.dart
│   └── Widgets
│       ├── AppBarDefault.dart
│       ├── Avatar.dart
│       ├── Cards
│       │   ├── AlumnoCard.dart
│       │   ├── AlumnoDeAulaCard.dart
│       │   ├── AulaCard.dart
│       │   ├── ProfesorCard.dart
│       │   └── TareaCard.dart
│       ├── ConfirmationModal.dart
│       ├── DefaultButton.dart
│       ├── DefaultSwitch.dart
│       ├── ErrorModal.dart
│       ├── Header.dart
│       ├── InformationModal.dart
│       ├── Navbar.dart
│       ├── NavBarProfesor.dart
│       ├── SuccessModal.dart
│       └── TextFieldDefault.dart

```

## **Resumen del Proyecto: Sistema de Gestión Educativa**

El proyecto tiene como objetivo desarrollar una **plataforma integral de gestión educativa**, orientada a facilitar la administración, seguimiento y comunicación entre administradores, profesores y alumnos. A continuación, se detalla cómo los requisitos funcionales, no funcionales y de información se integran para cumplir con este propósito:

---

### **Módulos Principales**

#### **1. Administrador**
El módulo del administrador ofrece herramientas completas para la gestión del sistema:
- **Gestión de Usuarios:**  
  Permite registrar, modificar, dar de baja y asignar alumnos y profesores a aulas. Además, incluye funcionalidades avanzadas como la visualización de listas con filtros y la gestión segura de contraseñas (cumpliendo con RNF-6).
- **Gestión de Tareas:**  
  Facilita la creación, edición y eliminación de distintos tipos de tareas (petición, juego, por pasos), asignándolas a alumnos y gestionando los materiales asociados. También permite consultar el historial de tareas completadas (RI-9, RI-13).
- **Gestión de Aulas:**  
  El administrador puede crear, modificar y eliminar aulas, asegurando que estas se configuren según los comandos específicos asignados (RI-15, RI-16).
- **Comunicación y Accesibilidad:**  
  Incorpora un chat para interactuar con alumnos y la capacidad de gestionar menús del sistema (RI-4, RI-19), con soporte de accesibilidad conforme al Real Decreto 1112/2018 (RNF-5).

#### **2. Alumno**
El módulo del alumno prioriza la experiencia del usuario y la accesibilidad:
- **Gestión de Tareas:**  
  Los alumnos pueden consultar tareas asignadas, marcarlas como completadas y enviar evidencias. Además, tienen acceso a notificaciones y un calendario semanal integrado (RI-9, RI-18).
- **Opciones de Accesibilidad:**  
  Se incluyen funcionalidades para personalizar paletas de colores y tamaños de fuente, mejorando la usabilidad para alumnos con discapacidades visuales (RI-8, RNF-10).
- **Comunicación y Perfil:**  
  Los alumnos pueden gestionar su sesión, acceder a su perfil y comunicarse directamente con educadores mediante un chat (RI-4).

#### **3. Profesor**
El módulo del profesor se centra en la supervisión y el apoyo a los alumnos:
- **Historial y Estadísticas:**  
  Los profesores tienen acceso a estadísticas detalladas del desempeño de sus alumnos en tareas (RI-9).
- **Gestión de Materiales:**  
  Pueden solicitar materiales necesarios para las tareas, verificando la disponibilidad en tiempo real (RI-6, RI-7).
- **Comunicación:**  
  Incluye herramientas de mensajería para comunicarse con alumnos y colaborar con otros usuarios del sistema (RI-4).

---

### **Requisitos No Funcionales Clave**
El sistema ha sido diseñado para ser intuitivo y eficiente, cumpliendo con los siguientes estándares:
1. **Tiempo de Respuesta:**  
   Las operaciones críticas como la creación de tareas o la carga de listas de usuarios cumplen con tiempos máximos de 3 y 5 segundos respectivamente (RNF-7, RNF-8).
2. **Accesibilidad y Responsividad:**  
   Cumple con los estándares del Real Decreto 1112/2018, ofreciendo soporte para usuarios con discapacidades y adaptándose a dispositivos móviles y computadoras (RNF-5, RNF-11).
3. **Interfaz Intuitiva:**  
   Garantiza que todas las funciones principales sean accesibles en 3 clics o menos, alineándose con la simplicidad esperada (RNF-9).

---

### **Requisitos de Información**
El sistema asegura un manejo estructurado y seguro de datos, integrando:
- **Gestión de Usuarios:**  
  Registra y organiza información detallada de alumnos, profesores y administradores (RI-1, RI-2, RI-3).
- **Gestión de Contenidos:**  
  Almacena tareas, subtareas, enunciados, respuestas y material asociado, proporcionando trazabilidad y seguimiento (RI-9, RI-10, RI-17, RI-18).
- **Gestión de Comunicación:**  
  Conserva historiales de chats y mensajes, fomentando una interacción fluida entre los distintos roles (RI-4, RI-5).

---

### **Beneficios del Sistema**
1. **Automatización y Control:**  
   Reduce la carga operativa mediante una gestión centralizada de usuarios, aulas y tareas.
2. **Adaptabilidad:**  
   Diseñado para ser accesible, inclusivo y adecuado para diferentes dispositivos.
3. **Mejora de la Comunicación:**  
   Facilita la interacción en tiempo real entre administradores, profesores y alumnos.
4. **Eficiencia y Escalabilidad:**  
   Optimizado para tiempos de respuesta rápidos y operaciones intuitivas, con la posibilidad de expandirse según las necesidades del cliente.

Este proyecto, fundamentado en los requisitos mencionados, busca ofrecer una solución robusta, eficiente y adaptada al entorno educativo moderno.

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

## UI/UX

Para el desarrollo de la interfaz se han diseñado mockups y wireframes que se incluirán en esta sección para mantener una referencia visual de cada iteración:

## Funcionalidades diseñadas e implementadas en la primera iteración

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

## Funcionalidades implementadas en la segunda iteración

### Pantalla Asignar Alumno a Aula
Interfaz que permite asignar a un alumno a una aula específica, facilitando la organización y gestión de las aulas en el sistema.  
![Asignar Alumno a Aula]( )

### Pantalla Asignar Alumno a Tarea
Pantalla diseñada para asignar tareas específicas a alumnos, personalizando su plan de actividades.  
![Asignar Alumno a Tarea]( )

### Pantalla Asignar Profesor a Aula
Interfaz para asignar a un profesor a una aula específica, organizando las aulas de acuerdo con el personal docente disponible.  
![Asignar Profesor a Aula]( )

### Pantalla Aulario Profesor
Vista que muestra el aula asignada al profesor, junto con los alumnos bajo su supervisión.  
![Aulario Profesor]( )

### Pantalla Crear Pedido de Material
Permite a los profesores realizar pedidos de materiales necesarios para llevar a cabo actividades y tareas asignadas.  
![Crear Pedido de Material]( )

### Pantalla Diagrama
Visualización esquemática o estructural de los procesos y flujos dentro del sistema.  
![Diagrama]( )

### Pantalla Editar Alumno
Interfaz para modificar los datos de un alumno, incluyendo información personal y académica.  
![Editar Alumno]( )

### Pantalla Editar Subtarea
Permite realizar modificaciones a subtareas ya creadas dentro de una tarea mayor.  
![Editar Subtarea]( )

### Pantalla Editar Tarea
Interfaz para ajustar o actualizar información de tareas previamente asignadas.  
![Editar Tarea]( )

### Pantalla Filtrar Alumnos
Herramienta para buscar y filtrar alumnos en la base de datos según diferentes criterios.  
![Filtrar Alumnos]( )

### Pantalla Filtrar Profesores
Permite realizar búsquedas avanzadas y filtrar la lista de profesores por criterios específicos.  
![Filtrar Profesores]( )

### Pantalla Listar Aulas
Muestra un listado de todas las aulas registradas, con opciones de filtro y visualización detallada.  
![Listar Aulas]( )

### Pantalla Listar Alumnos
Despliega una lista de alumnos disponibles, con opciones para buscar y filtrar según diferentes parámetros.  
![Listar Alumnos]( )

### Pantalla Listar Profesores
Pantalla que muestra una lista de profesores registrados en el sistema, con opciones de búsqueda y filtrado.  
![Listar Profesores]( )

### Pantalla Listar Tareas
Interfaz que presenta un listado general de todas las tareas registradas en el sistema.  
![Listar Tareas]( )

### Pantalla Listar Tareas Asignadas
Muestra las tareas que han sido asignadas a alumnos, con detalles de estado y fechas.  
![Listar Tareas Asignadas]( )

### Pantalla Menú Accesible
Menú diseñado para cumplir con los estándares de accesibilidad, facilitando su uso para personas con discapacidades visuales.  
![Menú Accesible]( )

### Pantalla Menú Alumno Accesible
Interfaz accesible específicamente diseñada para los alumnos, con opciones adaptadas a sus necesidades.  
![Menú Alumno Accesible]( )

### Pantalla Modificar Aula
Permite editar la información de un aula registrada, incluyendo asignaciones de alumnos y profesores.  
![Modificar Aula]( )

### Pantalla Principal
Pantalla inicial del sistema que ofrece acceso rápido a las funcionalidades principales según el rol del usuario.  
![Pantalla Principal]( )

### Pantalla Pedidos de Material
Muestra los pedidos de materiales realizados, con detalles sobre estado y disponibilidad.  
![Pedidos de Material]( )

### Pantalla Visualizar Tarea
Interfaz que permite ver los detalles completos de una tarea asignada a un alumno.  
![Visualizar Tarea]( )

¡Gracias por tu interés en TARERIO!
