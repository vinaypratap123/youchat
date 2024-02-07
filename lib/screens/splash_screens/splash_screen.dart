import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushNamed(context, RoutesName.loginScreen);
        // if (Apis.auth.currentUser != null) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
        // } else {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              AppString.madeByVinay,
              style: AppStyle.largeTextStyle,
            )),
          ],
        ),
      ),
    );
  }
}
