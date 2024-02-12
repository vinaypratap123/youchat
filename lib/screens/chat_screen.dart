import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/models/chat_user_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: AppColor.scaffoldBg,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Apis.firestore.collection("users").snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.whitePrimary,
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final userList = [];
                      // if (snapshot.hasData) {
                      //   final data = snapshot.data?.docs;
                      //   userList = data
                      //           ?.map((e) => ChatUserModel.fromJson(e.data()))
                      //           .toList() ??
                      //       [];
                      // }

                      if (userList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            return Text("data");
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            AppString.sayHi,
                            style: AppStyle.largeTextStyle,
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.whiteSecondary,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageUrl: widget.user.image.toString(),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: AppColor.bgLight2,
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: AppColor.whiteSecondary,
                ),
              ),
            ),
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: AppStyle.smallBodyStyle,
              ),
              Text(
                widget.user.lastActive,
                style: AppStyle.smallTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: AppColor.bgLight1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: AppColor.whitePrimary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: AppColor.whitePrimary),
                      cursorColor: AppColor.whitePrimary,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        fillColor: AppColor.bgLight1,
                        filled: true,
                        border: InputBorder.none,
                        hintText: AppString.typeMessage,
                        hintStyle: TextStyle(
                          color: AppColor.whitePrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: AppColor.whitePrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: AppColor.whitePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            color: AppColor.bgLight2,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            onPressed: () {},
            child: Icon(
              Icons.send,
              color: AppColor.whitePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
