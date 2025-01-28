import 'package:app_netdrinks/adapters/cocktail_adapter.dart';
import 'package:app_netdrinks/bindings/app_bindings.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/screens/home_screen.dart';
import 'package:app_netdrinks/screens/language_selection_screen.dart';
import 'package:app_netdrinks/screens/login_screen.dart';
import 'package:app_netdrinks/screens/verify_email_screen.dart';
import 'package:app_netdrinks/widgets/cocktail_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Inicializar Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CocktailAdapter());
  await Hive.openBox<Cocktail>('cocktailBox');

  final prefs = await SharedPreferences.getInstance();
  final String? savedLanguage = prefs.getString('language');

  if (savedLanguage != null) {
    Get.updateLocale(Locale(savedLanguage));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      title: 'NetDrinks',
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/lang',
            fallbackFile: 'en',
            useCountryCode: false,
          ),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglês
        Locale('pt', ''), // Português
        Locale('es', ''), // Espanhol
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.firstWhere(
          (supportedLocale) =>
              supportedLocale.languageCode == locale?.languageCode,
          orElse: () => supportedLocales.first,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return LoginScreen();
          }
          return user.emailVerified
              ? const LanguageSelectionScreen()
              : VerifyEmailScreen(user: user);
        },
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/home': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return LoginScreen();
          }
          return HomeScreen(user: user);
        },
        '/verify-email': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return LoginScreen();
          }
          return VerifyEmailScreen(user: user);
        },
        '/login': (context) => LoginScreen(),
        '/cocktail': (context) => CocktailCard(
              user: FirebaseAuth.instance.currentUser?.uid ?? '',
              cocktail: Cocktail(
                idDrink: '1',
                strDrink: 'Example Drink',
                strInstructions: 'Mix ingredients',
                ingredients: ['Ingredient1', 'Ingredient2'],
                measures: ['1 oz', '2 oz'],
                name: 'Example Name',
              ),
            ),
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000), // Preto
          foregroundColor: Color(0xFFE50914), // Vermelho Netflix
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF121212), // Preto mais claro
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFFFFFFF)), // Branco
          bodyMedium: TextStyle(color: Color(0xFFFFFFFF)), // Branco
          titleLarge: TextStyle(color: Color(0xFFE50914)), // Vermelho Netflix
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
