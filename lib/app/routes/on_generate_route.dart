import 'package:flutter/material.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/screens/auth/login_screen.dart';
import 'package:youchat/screens/home_screen.dart';
import 'package:youchat/screens/user_profile_screen.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      // ************ LOG IN SCREEN ROUTE *******************
      case RoutesName.loginScreen:
        {
          return routeBuilder(const LoginScreen());
        }
      // ************ HOME SCREEN ROUTE *******************
      case RoutesName.homeScreen:
        {
          return routeBuilder(const HomeScreen());
        }
      // ************ USER PROFILE SCREEN ROUTE *******************
      case RoutesName.userProfileScreen:
        {
          return routeBuilder(const UserProfileScreen());
        }

      // ************ DEFAULT ROUTE *******************
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text(AppString.noSuchRoueDefined,style: AppStyle.largeTextStyle,),
            ),
          );
        });
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
