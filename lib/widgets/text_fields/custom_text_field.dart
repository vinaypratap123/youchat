import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final Icon icon;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.initialValue,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
        style: TextStyle(color: AppColor.whitePrimary),
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: AppStyle.smallBodyStyle,
          labelStyle: TextStyle(color: AppColor.whitePrimary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColor.whitePrimary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColor.whiteSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
