import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/routes/on_generate_route.dart';
import 'package:youchat/firebase_options.dart';
import 'package:youchat/screens/splash_screens/splash_screen.dart';

void main() {
  _initializedFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppColor.whiteSecondary),
          elevation: 1,
          centerTitle: true,
          color: AppColor.bgLight1,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 22,
            color: AppColor.whiteSecondary,
          ),
        ),
      ),
      onGenerateRoute: OnGenerateRoute.route,
      initialRoute: "/",
      routes: {
        "/": (context) {
          return SplashScreen();
        }
      },
    );
  }
}

_initializedFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
