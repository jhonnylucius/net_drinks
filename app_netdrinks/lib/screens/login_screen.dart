import 'package:app_netdrinks/modal/reset_password_modal.dart';
import 'package:app_netdrinks/screens/home_screen.dart';
import 'package:app_netdrinks/screens/register_screen.dart';
import 'package:app_netdrinks/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Icon-192.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    style:
                        TextStyle(color: Colors.black), // Cor do texto digitado
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "login.email"),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    controller: _senhaController,
                    decoration: InputDecoration(
                      hintText:
                          FlutterI18n.translate(context, "login.password"),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final senha = _senhaController.text;

                      if (email.isEmpty || senha.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Por favor, preencha todos os campos')),
                        );
                        return;
                      }

                      try {
                        await _authService.entrarUsuario(email, senha);
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(user: user)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Erro ao fazer login: Usuário não encontrado')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao fazer login: $e')),
                        );
                      }
                    },
                    child: Text(FlutterI18n.translate(context, "Entrar")),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ResetPasswordModal(),
                      );
                    },
                    child: Text(FlutterI18n.translate(
                        context, "login.forgot_password")),
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      try {
                        await _authService.signInWithGoogle();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(user: user)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Erro ao fazer login com Google: Usuário não encontrado')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Erro ao fazer login com Google: $e')),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(FlutterI18n.translate(context, "Criar Conta")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
