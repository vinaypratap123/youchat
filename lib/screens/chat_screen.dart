import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/models/message_model.dart';
import 'package:youchat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatMessageController = TextEditingController();
  List<MessageModel> _messageList = [];
  bool _showEmoji = false;
  @override
  void dispose() {
    super.dispose();
    _chatMessageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
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
                  stream: Apis.getAllMessages(widget.user),
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
                          _messageList = data
                                  ?.map((e) => MessageModel.fromJson(e.data()))
                                  .toList() ??
                              [];
                        }

                        if (_messageList.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _messageList.length,
                            itemBuilder: (context, index) {
                              return MessageCard(message: _messageList[index]);
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
              if (_showEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: _chatMessageController,
                    config: Config(
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: AppColor.bgLight1,
                      indicatorColor: AppColor.blueColor,
                      iconColor: AppColor.whiteSecondary,
                      iconColorSelected: AppColor.blueColor,
                      backspaceColor: AppColor.blueColor,
                      skinToneDialogBgColor: AppColor.whitePrimary,
                      skinToneIndicatorColor: AppColor.whiteSecondary,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      noRecents: const Text(
                        AppString.noRecentEmoji,
                        style: AppStyle.mediumBodyStyle,
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                ),
            ],
          ),
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
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: AppColor.whitePrimary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        setState(
                          () {
                            if (_showEmoji) _showEmoji = !_showEmoji;
                          },
                        );
                      },
                      controller: _chatMessageController,
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
            onPressed: () {
              if (_chatMessageController.text.isNotEmpty) {
                Apis.sendMessage(
                  widget.user,
                  _chatMessageController.text,
                  Type.text,
                );
                widget.user.unreadMessagesCount++;
                _chatMessageController.text = "";
              } else {}
            },
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
