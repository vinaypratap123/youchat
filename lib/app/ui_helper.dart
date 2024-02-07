import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';

class UiHelper {
  // ============================ showSnakBar()==============================
  static void showSnakBar(BuildContext context, String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================ showProgressBar()==============================
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: AppColor.whitePrimary,
        ),
      ),
    );
  }
}
