import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/ui_helper.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/widgets/buttons/rectangle_button.dart';
import 'package:youchat/widgets/text_fields/custom_text_field.dart';

class EditUserProfileScreen extends StatefulWidget {
  final ChatUserModel user;
  const EditUserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColor.scaffoldBg,
      appBar: AppBar(
        title: Text(AppString.editProfile),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(10),
              Stack(
                children: [
                  _image != null
                      ? Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.file(
                              height: 150,
                              width: 150,
                              File(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: CachedNetworkImage(
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image.toString(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: AppColor.whiteSecondary,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 100,
                    child: MaterialButton(
                      onPressed: () {
                        _showBottomSheet();
                      },
                      child: Icon(
                        Icons.edit,
                        color: AppColor.whiteSecondary,
                      ),
                      color: AppColor.bgLight2,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(
                widget.user.email,
                style: AppStyle.smallBodyStyle,
              ),
              const Gap(20),
              CustomTextField(
                validator: (newName) => newName != null && newName.isNotEmpty
                    ? null
                    : AppString.nameCanNotBeEmpty,
                onSaved: (newName) => Apis.currentUser!.name = newName ?? "",
                initialValue: widget.user.name,
                hintText: AppString.name,
                icon: Icon(
                  Icons.person,
                  color: AppColor.whiteSecondary,
                ),
              ),
              const Gap(10),
              CustomTextField(
                validator: (newAbout) => newAbout != null && newAbout.isNotEmpty
                    ? null
                    : AppString.aboutCanNotBeEmpty,
                onSaved: (newAbout) => Apis.currentUser!.about = newAbout ?? "",
                initialValue: widget.user.about,
                hintText: AppString.about,
                icon: Icon(
                  Icons.info,
                  color: AppColor.whiteSecondary,
                ),
              ),
              const Gap(20),
              RectangleButton(
                buttonName: AppString.update,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Apis.updateUserInfo().then(
                      (value) {
                        UiHelper.showSnakBar(
                          context,
                          AppString.profileUpdateSuccessfully,
                          AppColor.greenColor,
                        );
                      },
                    );
                  } else {}
                },
                height: 60,
                width: 360,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColor.bgLight2,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: 20),
          shrinkWrap: true,
          children: [
            Text(
              AppString.selectProfilePhoto,
              textAlign: TextAlign.center,
              style: AppStyle.mediumBodyStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(
                          () {
                            _image = image.path;
                          },
                        );

                        Apis.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: AppColor.whiteSecondary,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 70);
                      if (image != null) {
                        setState(
                          () {
                            _image = image.path;
                          },
                        );

                        Apis.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(
                      Icons.photo_album_outlined,
                      size: 40,
                      color: AppColor.whiteSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
