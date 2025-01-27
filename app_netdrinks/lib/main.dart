import 'package:app_netdrinks/adapters/cocktail_adapter.dart';
import 'package:app_netdrinks/firebase_options.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/models/cocktail_api.dart';
import 'package:app_netdrinks/repository/cocktail_repository.dart';
import 'package:app_netdrinks/screens/cocktail_detail_screen.dart';
import 'package:app_netdrinks/screens/home_screen.dart';
import 'package:app_netdrinks/screens/login_screen.dart';
import 'package:app_netdrinks/screens/verify_email_screen.dart';
import 'package:app_netdrinks/widgets/terms_of_service_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CocktailAdapter());
  final cocktailBox = await Hive.openBox<Cocktail>('cocktailBox');

  // Inicialização do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Injeção de dependências
  final api = CocktailApi();
  Get.put(CocktailRepository(api, cocktailBox));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drinks',
      routes: {
        '/': (context) => const RoteadorTelas(),
        '/detail': (context) =>
            Cocktail_detail_screen.dart
            Screen(user: FirebaseAuth.instance.currentUser!),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914), // Vermelho Netflix
          brightness: Brightness.dark,
          primary: const Color(0xFFE50914), // Vermelho Netflix
          secondary: const Color(0xFFFFFFFF), // Branco
          surface: const Color(0xFF000000), // Preto
          onPrimary: const Color(0xFFFFFFFF), // Branco
          onSecondary: const Color(0xFF000000), // Preto
          onSurface: const Color(0xFFFFFFFF), // Branco
        ),
        scaffoldBackgroundColor: const Color(0xFF000000), // Preto
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF000000), // Preto
          foregroundColor: const Color(0xFFE50914), // Vermelho Netflix
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF121212), // Preto mais claro
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: const Color(0xFFFFFFFF)), // Branco
          bodyMedium: TextStyle(color: const Color(0xFFFFFFFF)), // Branco
          titleLarge:
              TextStyle(color: const Color(0xFFE50914)), // Vermelho Netflix
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
