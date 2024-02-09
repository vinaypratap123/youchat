import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';

class RectangleButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;
  final double height;
  final double width;
  const RectangleButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColor.bgLight2,
          borderRadius: BorderRadius.circular(15),
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
