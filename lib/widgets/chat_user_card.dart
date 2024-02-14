import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/app/utils/date_utils.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/models/message_model.dart';
import 'package:youchat/widgets/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUserModel user;
  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  MessageModel? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.bgLight2,
      elevation: 0,
      child: StreamBuilder(
        stream: Apis.getLastMessages(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          final _list = data
                  ?.map((error) => MessageModel.fromJson(error.data()))
                  .toList() ??
              [];
          if (_list.isNotEmpty) {
            _message = _list[0];
          }
          return ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutesName.chatScreen,
                arguments: widget.user,
              );
            },
            leading: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ProfileDialog(user: widget.user),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
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
            ),
            title: Text(
              widget.user.name,
              style: TextStyle(
                color: AppColor.whiteSecondary,
              ),
            ),
            subtitle: Text(
              _message != null
                  ? _message!.type == Type.image
                      ? "Photo"
                      : _message!.msg
                  : widget.user.about,
              style: TextStyle(
                color: AppColor.whitePrimary,
              ),
            ),
            trailing: _message == null
                ? null
                : _message!.read.isEmpty && _message!.fromId != Apis.user.uid
                    ? Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColor.greenColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    : Text(
                        MyDateUtils.getLastMessageTime(
                          context: context,
                          time: _message!.sent,
                        ),
                        style: AppStyle.smallTextStyle,
                      ),
          );
        },
      ),
    );
  }
}
