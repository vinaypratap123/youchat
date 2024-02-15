import 'package:flutter/material.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/ui_helper.dart';
import 'package:youchat/screens/home_screen.dart';
import 'package:youchat/widgets/buttons/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ***************************** handleGoogleLogin() function ****************************
  dynamic _handleGoogleLogin() {
    UiHelper.showProgressBar(context);
    Apis.signInWithGoogle(context).then(
      (user) async {
        Navigator.pop(context);
        if (user != null) {
          if (await Apis.isUserExists()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else {
            Apis.createUser().then(
              (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

 // ***************************** build() function ****************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SocialButton(
                buttonName: AppString.loginWithGoogle,
                onTap: () {
                  _handleGoogleLogin();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
