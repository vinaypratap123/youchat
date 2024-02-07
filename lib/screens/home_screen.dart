import 'package:flutter/material.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> userList = [];
  final List<ChatUserModel> searchedUserList = [];
  bool isSearching = false;
  ChatUserModel? mostRecentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBg,
      appBar: AppBar(
        title: const Text(AppString.youChat),
        leading: Icon(
          Icons.home_outlined,
          color: AppColor.whiteSecondary,
          size: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: AppColor.whiteSecondary,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: AppColor.whiteSecondary,
              size: 30,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
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
              // if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              userList =
                  data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??
                      [];
              // }

              if (userList.isNotEmpty) {
                return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                      user: userList[index],
                      // user: isSearching
                      //     ? searchedUserList[index]
                      //     : UserList[index],
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    AppString.noConnectionFound,
                    style: AppStyle.largeTextStyle,
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
