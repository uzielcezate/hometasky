// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class RegisterClientScreen extends StatefulWidget {
  @override
  _RegisterClientScreenState createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController secondLastNameController =
      TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final List<String> categories = [
    'Construcción',
    'Salud y Belleza',
    'Decoración',
    'Limpieza',
    'Comida',
    'Mascotas',
    'Niños',
    'Reparaciones y Mantenimiento del Hogar',
    'Transporte y Logística',
    'Educación y Formación',
    'Eventos y Entretenimiento',
    'Consultoría y Asesoría',
    'Fitness y Bienestar',
    'Servicios Especializados'
  ];

  String? selectedCategory;
  List<String> selectedSubCategories = [];
  List<String> subCategories = [];

  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool isEmailTaken = false;
  bool isUsernameTaken = false;
  DateTime? selectedBirthdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Registro de Cliente",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Nombres",
              obscureText: false,
              controller: firstNameController,
              icon: Icons.person,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Apellido Paterno",
              obscureText: false,
              controller: lastNameController,
              icon: Icons.person,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Apellido Materno",
              obscureText: false,
              controller: secondLastNameController,
              icon: Icons.person,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedBirthdate = pickedDate;
                    birthdateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: "Fecha de nacimiento",
                  obscureText: false,
                  controller: birthdateController,
                  icon: Icons.calendar_today,
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Correo electrónico",
              obscureText: false,
              controller: emailController,
              icon: Icons.email,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Número celular",
              obscureText: false,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              icon: Icons.phone,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Nombre de usuario",
              obscureText: false,
              controller: usernameController,
              icon: Icons.person,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Contraseña",
              obscureText: _obscureText,
              controller: passwordController,
              icon: Icons.lock,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Repetir contraseña",
              obscureText: _obscureConfirmText,
              controller: confirmPasswordController,
              icon: Icons.lock,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmText = !_obscureConfirmText;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Dirección del domicilio",
              obscureText: false,
              controller: addressController,
              icon: Icons.home,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  selectedSubCategories.clear();
                  subCategories = getSubCategories(value!);
                });
              },
              decoration: InputDecoration(
                labelText: "Categoría que suele contratar más",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: subCategories.map((subCategory) {
                return FilterChip(
                  label: Text(subCategory),
                  selected: selectedSubCategories.contains(subCategory),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedSubCategories.add(subCategory);
                      } else {
                        selectedSubCategories
                            .removeWhere((element) => element == subCategory);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Registrarse",
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();
                String firstName = firstNameController.text.trim();
                String lastName = lastNameController.text.trim();
                String secondLastName = secondLastNameController.text.trim();
                // ignore: unused_local_variable
                String birthdate = birthdateController.text.trim();
                String phone = phoneController.text.trim();
                String username = usernameController.text.trim();
                String address = addressController.text.trim();
                String? category = selectedCategory;
                List<String> subCategories = selectedSubCategories;

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Las contraseñas no coinciden")),
                  );
                  return;
                }

                if (selectedBirthdate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Seleccione una fecha de nacimiento")),
                  );
                  return;
                }

                if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                    .hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Por favor, ingrese un correo válido")),
                  );
                  return;
                }

                if (category == null || subCategories.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Seleccione una categoría y al menos una subcategoría")),
                  );
                  return;
                }

                if (selectedBirthdate != null &&
                    selectedBirthdate!.isAfter(
                        DateTime.now().subtract(Duration(days: 365 * 18)))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Debe ser mayor de 18 años para registrarse")),
                  );
                  return;
                }

                AuthService authService =
                    Provider.of<AuthService>(context, listen: false);

                bool emailExists = await authService.checkEmailExists(email);
                if (emailExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("El correo electrónico ya está en uso")),
                  );
                  return;
                }

                bool usernameExists =
                    await authService.checkUsernameExists(username);
                if (usernameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("El nombre de usuario ya está en uso")),
                  );
                  return;
                }

                User? errorMessage = await authService.registerClient(
                  email: email,
                  password: password,
                  firstName: firstName,
                  lastName: lastName,
                  secondLastName: secondLastName,
                  birthdate: selectedBirthdate!,
                  phone: phone,
                  username: username,
                  address: address,
                  category: category,
                  subCategories: subCategories,
                  experience: null, // Experiencia
                  payment: null, // Pago
                  availability: null, // Disponibilidad
                  generalRating: null, // Calificación general
                  jobsCompleted: null, // Pago
                  latitude: null, // Disponibilidad
                  longitude: null, // Calificación general
                );

                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage as String)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Registro exitoso"),
                        backgroundColor: Colors.green),
                  );
                  // Navegar a la pantalla de inicio o la pantalla principal
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSubCategories(String category) {
    switch (category) {
      case 'Construcción':
        return [
          'Albañiles',
          'Plomeros',
          'Electricistas',
          'Herreros',
          'Pintores',
          'Yeseros'
        ];
      case 'Salud y Belleza':
        return [
          'Masajes relajantes',
          'Masajes terapéuticos',
          'Consultas médicas generales',
          'Especialistas',
          'Servicios de enfermería a domicilio',
          'Tratamientos faciales',
          'Manicura y pedicura',
          'Depilación'
        ];
      case 'Decoración':
        return [
          'Carpinteros',
          'Diseñadores de Interiores',
          'Decoración de espacios',
          'Asesoría en selección de muebles',
          'Jardineros',
          'Instalación de sistemas de riego',
        ];
      case 'Limpieza':
        return [
          'Fumigadores',
          'Personal de Aseo',
          'Lavanderos',
          'Planchado',
          'Tintorería',
          'Limpiadores de Baño',
        ];
      case 'Comida':
        return [
          'Chef de comidas diarias',
          'Chef para eventos',
          'Menús personalizados',
          'Pasteles y postres a medida',
          'Repostería para eventos',
          'Clases de repostería',
        ];
      case 'Mascotas':
        return [
          'Veterinarios Personales',
          'Entrenadores de Mascotas',
          'Paseadores de Mascotas',
          'Cuidado de mascotas',
        ];
      case 'Niños':
        return [
          'Niñeros',
          'Cuidado de emergencia',
          'Educadores o Profesores Privados',
          'Animadores Infantiles',
          'Animación de fiestas',
          'Talleres creativos'
        ];
      case 'Reparaciones y Mantenimiento del Hogar':
        return [
          'Técnicos de Electrodomésticos',
          'Cerrajeros',
          'Techadores',
          'Técnicos Informáticos',
          'Instaladores de Redes',
          'Técnicos de Teléfonos Móviles'
        ];
      case 'Transporte y Logística':
        return [
          'Transporte personal',
          'Traslados al aeropuerto',
          'Transporte para eventos',
          'Mudanzas',
          'Entrega de documentos',
          'Servicios de mensajería exprés',
          'Entrega de paquetes'
        ];
      case 'Educación y Formación':
        return [
          'Tutores Académicos de Primaria',
          'Tutores Académicos de Secundaria',
          'Tutores Académicos de Preparatoria',
          'Tutores Académicos de Universidad',
          'Instructores de Música',
          'Clases de inglés',
          'Clases de español',
          'Clases de francés',
          'Clases de italiano',
          'Clases de otros idiomas'
        ];
      case 'Eventos y Entretenimiento':
        return [
          'Fotografía de eventos',
          'Sesiones de retrato',
          'Fotografía de productos',
          'Organización de bodas',
          'Organización de fiestas',
          'Coordinación de eventos corporativos',
          'Coordinación de eventos deportivos',
          'DJ para fiestas',
          'Músicos en vivo',
          'Servicios de karaoke'
        ];
      case 'Consultoría y Asesoría':
        return [
          'Consultores Financieros',
          'Asesores Legales',
          'Consultoría en derecho familiar',
          'Representación legal',
          'Asesores de Imagen',
          'Estilismo personal',
          'Asesoría de vestuario',
          'Consultoría en imagen profesional'
        ];
      case 'Fitness y Bienestar':
        return [
          'Instructores de Yoga',
          'Clases de meditación',
          'Yoga terapéutico',
          'Nutricionistas',
          'Masajes deportivos',
          'Entrenamiento en casa',
          'Asesoría nutricional',
          'Entrenamiento para competencias',
          'Asesoría en alimentación saludable',
          'Clases de karate',
          'Clases de judo',
          'Clases de boxeo',
          'Clases de futbol',
          'Clases de baile'
        ];
      case 'Servicios Especializados':
        return [
          'Traducción de documentos',
          'Interpretación simultánea',
          'Localización de contenido',
          'Investigación privada',
          'Búsqueda de personas',
          'Investigación de fraudes',
          'Evaluación de seguridad en el hogar',
          'Instalación de sistemas de seguridad',
          'Entrenamiento en seguridad personal'
        ];

      default:
        return [];
    }
  }
}
