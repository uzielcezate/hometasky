import 'dart:ui';
import 'package:flutter/material.dart';
import 'register_client_screen.dart';
import 'register_professional_screen.dart';
// ignore: unused_import
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterSelectionScreen extends StatefulWidget {
  @override
  _RegisterSelectionScreenState createState() =>
      _RegisterSelectionScreenState();
}

class _RegisterSelectionScreenState extends State<RegisterSelectionScreen> {
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Agregamos espacio arriba del título
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Tipo de usuario',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 40), // Espacio para centrar el título
                  ],
                ),
                SizedBox(height: 20), // Agregamos espacio arriba del contenido
                GlassEffectContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seleccione el tipo de usuario:',
                          style: TextStyle(
                            fontSize: 18, // Ajustar el tamaño del texto
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButton<String>(
                          value: selectedUserType,
                          hint: Text(
                            'Tipo de usuario',
                            style: TextStyle(color: Colors.white70),
                          ),
                          dropdownColor: Colors.black87,
                          items: [
                            DropdownMenuItem(
                              value: 'clientes',
                              child: Text('Cliente'),
                            ),
                            DropdownMenuItem(
                              value: 'profesionales',
                              child: Text('Profesional'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedUserType = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          // Centramos el botón "Continuar"
                          child: CustomButton(
                            text: "Continuar",
                            onPressed: () {
                              if (selectedUserType == 'clientes') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterClientScreen(
                                        //userType: 'clientes',
                                        ),
                                  ),
                                );
                              } else if (selectedUserType == 'profesionales') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterProfessionalScreen(
                                      userType: 'profesionales',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Seleccione un tipo de usuario')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassEffectContainer extends StatelessWidget {
  final Widget child;

  const GlassEffectContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}


/*class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
*/