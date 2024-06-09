import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Recuperar Contraseña",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Buscar por nombre de usuario o correo",
              obscureText: false,
              controller: searchController,
              icon: Icons.search,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Buscar",
              onPressed: () async {
                String searchQuery = searchController.text.trim();

                if (searchQuery.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Por favor, ingrese un nombre de usuario o correo")),
                  );
                  return;
                }

                // Implement search functionality
                // Update emailController with the found email if necessary
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Correo electrónico",
              obscureText: false,
              controller: emailController,
              icon: Icons.email,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Enviar",
              onPressed: () async {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Por favor, ingrese su correo electrónico")),
                  );
                  return;
                }

                var auth = Provider.of<AuthService>(context, listen: false);
                await auth.sendPasswordResetEmail(email);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Se ha enviado un enlace para restablecer la contraseña")),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
