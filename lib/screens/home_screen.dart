import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatUserModel> userList = [];
  final List<ChatUserModel> searchedUserList = [];
  bool isSearching = false;
  ChatUserModel? mostRecentUser;

  @override
  void initState() {
    super.initState();
    Apis.getCurrentUserInfo();
    Apis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains("resume"))
          Apis.updateActiveStatus(true);
        if (message.toString().contains("pause"))
          Apis.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  // ***************************** build() function ****************************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.scaffoldBg,
          appBar: AppBar(
            centerTitle: false,
            title: isSearching
                ? TextFormField(
                    cursorColor: AppColor.whiteSecondary,
                    style: TextStyle(color: AppColor.whitePrimary),
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "search",
                      hintStyle: TextStyle(
                        color: AppColor.whiteSecondary,
                      ),
                    ),
                    onChanged: (value) {
                      searchedUserList.clear();
                      for (var user in userList) {
                        if (user.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            user.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          searchedUserList.add(user);
                        }
                        setState(() {
                          searchedUserList;
                        });
                      }
                    },
                  )
                : Text(
                    AppString.youChat,
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: AppColor.whiteSecondary,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.editUserProfileScreen,
                    arguments: Apis.currentUser,
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  color: AppColor.whiteSecondary,
                  size: 30,
                ),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: Apis.getAllUser(),
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
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs;
                    userList = data
                            ?.map((e) => ChatUserModel.fromJson(e.data()))
                            .toList() ??
                        [];
                  }

                  if (userList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: isSearching
                          ? searchedUserList.length
                          : userList.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: isSearching
                              ? searchedUserList[index]
                              : userList[index],
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
        ),
      ),
    );
  }
}
