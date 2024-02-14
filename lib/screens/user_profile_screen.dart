import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/models/chat_user_model.dart';

class UserProfileScreen extends StatefulWidget {
  final ChatUserModel user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.bgLight1,
          title: Text(widget.user.name.toUpperCase()),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
          ],
        ),
        backgroundColor: AppColor.scaffoldBg,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image != null
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Image.file(
                            height: 90,
                            width: 90,
                            File(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 90,
                            width: 90,
                            imageUrl: widget.user.image.toString(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: Icon(
                                Icons.person,
                                color: AppColor.whiteSecondary,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 8,
                ),
// ================================  User email===================================
                Text(
                  widget.user.email,
                  style: AppStyle.smallBodyStyle,
                ),
                SizedBox(
                  height: 18,
                ),
// ================================  User about ===================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.about,
                      style: AppStyle.smallBodyStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ":",
                      style: AppStyle.smallBodyStyle,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      widget.user.about,
                      style: AppStyle.smallBodyStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
