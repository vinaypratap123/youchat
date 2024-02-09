import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';

class MobileDrawer extends StatefulWidget {
 
  const MobileDrawer({super.key});

  @override
  State<MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<MobileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.scaffoldBg,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                bottom: 20,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
            titleTextStyle: AppStyle.smallBodyStyle,
            onTap: () {},
            // leading: Icon(Constants.navbarIcon[i]),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
