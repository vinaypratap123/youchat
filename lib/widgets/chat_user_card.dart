import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/routes/routes_name.dart';
import 'package:youchat/models/chat_user_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.bgLight2,
      elevation: 0,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context,RoutesName.chatScreen,arguments: widget.user);
        },
        leading: ClipRRect(
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
        title: Text(
          widget.user.name,
          style: TextStyle(
            color: AppColor.whiteSecondary,
          ),
        ),
        subtitle: Text(
          widget.user.about,
          style: TextStyle(
            color: AppColor.whitePrimary,
          ),
        ),
        trailing: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColor.greenColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
