import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';

class SocialButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;
  const SocialButton(
      {super.key, required this.buttonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: width * 0.8,
        decoration: BoxDecoration(
          color: AppColor.bgLight2,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonName,
              style: AppStyle.buttonTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
