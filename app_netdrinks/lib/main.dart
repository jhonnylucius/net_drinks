import 'package:app_netdrinks/firebase_options.dart';
import 'package:app_netdrinks/screens/dashboard_screen.dart';
import 'package:app_netdrinks/screens/home_screen.dart';
import 'package:app_netdrinks/screens/login_screen.dart';
import 'package:app_netdrinks/screens/verify_email_screen.dart';
import 'package:app_netdrinks/widgets/terms_of_service_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NetDrinks',
      routes: {
        '/': (context) => const RoteadorTelas(),
        '/dashboard': (context) =>
            DashBoardScreen(user: FirebaseAuth.instance.currentUser!),
        '/home': (context) => HomeScreen(
            user: FirebaseAuth
                .instance.currentUser!), // Ajustar para passar o usuário atual
        '/verify-email': (context) => VerifyEmailScreen(
            user: FirebaseAuth.instance
                .currentUser!), // Adicionar rota para verificação de email
        '/login': (context) =>
            LoginScreen(), // Adicionar rota para verificação de email
      },
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkTermsAccepted(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Erro ao carregar dados.'),
            ),
          );
        } else if (snapshot.data == false) {
          return TermsOfServiceScreen();
        } else {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Scaffold(
                    body: Center(
                  child: Text('Erro ao carregar dados.'),
                ));
              } else if (snapshot.hasData) {
                return HomeScreen(
                  user: snapshot.data!,
                );
              } else {
                return LoginScreen();
              }
            },
          );
        }
      },
    );
  }

  Future<bool> _checkTermsAccepted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('terms_accepted') ?? false;
  }
}

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TermsOfServiceDialog(
          onAccepted: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('terms_accepted', true);
            Navigator.of(context).pushReplacementNamed('/');
          },
          onDeclined: () {
            // Fechar o aplicativo ou redirecionar para outra tela
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
    );
  }
}
