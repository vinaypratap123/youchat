import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/models/chat_user_model.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUserModel user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.bgLight1,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: 240,
        width: 200,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  user.name,
                  style: AppStyle.smallBodyStyle,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      RoutesName.userProfileScreen,
                      arguments: user,
                    );
                  },
                  child: Icon(
                    Icons.info_outline,
                    color: AppColor.whiteSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  height: 190,
                  width: 190,
                  fit: BoxFit.cover,
                  imageUrl: user.image.toString(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: AppColor.whiteSecondary,
                    child: Icon(
                      Icons.person,
                      size: 120,
                      color: AppColor.whiteSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
