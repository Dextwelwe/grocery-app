import 'package:epicerie/services/items_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'login/login_page.dart';
import 'login/sign_up.dart';
import 'services/grocery_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GroceriesService>(
              create: (_) => GroceriesService()),
          ChangeNotifierProvider<ItemService>(create: (_) => ItemService())
        ],
        child: MaterialApp(
            theme: ThemeData(
                fontFamily: 'Roboto',
                textTheme: TextTheme(bodyLarge: GoogleFonts.cabin()),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontFamily: GoogleFonts.cabin().fontFamily),
                ))),
            home: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color.fromARGB(255, 153, 213, 213),
                      Color.fromARGB(255, 76, 182, 182),
                      Color.fromARGB(255, 0, 151, 151),
                    ])),
                child: SafeArea(
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Home();
                      } else {
                        return const AuthState();
                      }
                    },
                  ),
                ),
              ),
            ),
            ),
            );
  }
}

class AuthState extends StatefulWidget {
  const AuthState({Key? key}) : super(key: key);
  @override
  State<AuthState> createState() => _AuthState();
}

class _AuthState extends State<AuthState> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(clickSignUp: toggleLogin)
      : SignUp(clickSignIn: toggleLogin);

  void toggleLogin() => setState(() {
        isLogin = !isLogin;
      });
}
