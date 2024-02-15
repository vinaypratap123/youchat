import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youchat/apis/apis.dart';
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
   // ***************************** init() function ****************************
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (Apis.auth.currentUser != null) {
          Navigator.pushNamed(context, RoutesName.homeScreen);
        } else {
          Navigator.pushNamed(context, RoutesName.loginScreen);
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
          children: [
            Center(
              child: Text(
                AppString.madeByVinay,
                style: AppStyle.largeTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
