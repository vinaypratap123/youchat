import 'package:flutter/material.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/screens/auth/login_screen.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      // ************ SIGN IN SCREEN ROUTE *******************
      case RoutesName.loginScreen:
        {
          return routeBuilder(const LoginScreen());
        }

      // ************ DEFAULT ROUTE *******************
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text(AppString.noSuchRoueDefined),
            ),
          );
        });
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
