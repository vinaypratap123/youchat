import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gap/gap.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_strings.dart';
import 'package:youchat/app/app_styles.dart';
import 'package:youchat/app/ui_helper.dart';
import 'package:youchat/app/utils/date_utils.dart';
import 'package:youchat/models/message_model.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _myMessage() : _anotherMessage(),
    );
  }
 // ***************************** _my message function ****************************
  Widget _myMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: Apis.user.uid == widget.message.fromId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  MyDateUtils.getFormattedTime(
                    context: context,
                    time: widget.message.sent,
                  ),
                  style: AppStyle.smallTextStyle,
                ),
                const Gap(5),
                widget.message.read.isEmpty
                    ? Icon(
                        Icons.done,
                        color: AppColor.whiteSecondary,
                        size: 18,
                      )
                    : Icon(
                        Icons.done_all,
                        color: AppColor.blueColor,
                        size: 18,
                      )
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.message.type == Type.text ? 20 : 1,
                  vertical: widget.message.type == Type.text ? 5 : 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.greenColor,
              ),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: AppStyle.smallBodyStyle,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 1),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
 // ***************************** _another message function ****************************
  Widget _anotherMessage() {
    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadTime(widget.message);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.bgLight2,
              ),
              child: Column(
                children: [
                  widget.message.type == Type.text
                      ? Text(
                          widget.message.msg,
                          style: AppStyle.smallBodyStyle,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                                vertical: 1,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Gap(5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  MyDateUtils.getFormattedTime(
                    context: context,
                    time: widget.message.sent,
                  ),
                  style: AppStyle.smallTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ================================ _showBottomSheet() method ===================================
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      backgroundColor: AppColor.bgLight1,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
// ================================ list view() method ===================================
        return ListView(
          padding: EdgeInsets.only(top: 20),
          shrinkWrap: true,
          children: [
            Container(
              height: 3,
              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 160),
              decoration: BoxDecoration(color: AppColor.whitePrimary),
            ),
            Gap(20),
// ================================ star message  icon ===================================
            if (!isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.star,
                    color: AppColor.whiteSecondary,
                    size: 26,
                  ),
                  name: AppString.starMessage,
                  onTap: () async {
                    Navigator.pop(context);

                    // Apis.toggleMessageStarStatus(widget.message);
                  }),
// ================================ copy message  icon ===================================
            widget.message.type == Type.text
                ? _OptionItem(
                    icon: Icon(
                      Icons.copy,
                      color: AppColor.whiteSecondary,
                      size: 26,
                    ),
                    name: AppString.copyMessage,
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.message.msg),
                      ).then(
                        (value) {
                          Navigator.pop(context);
                          UiHelper.showSnakBar(
                            context,
                            AppString.messageCopied,
                            AppColor.greenColor,
                          );
                        },
                      );
                    })
// ================================ save image icon ===================================
                : _OptionItem(
                    icon: Icon(
                      Icons.download,
                      color: AppColor.whiteSecondary,
                      size: 26,
                    ),
                    name: AppString.imageSaved,
                    onTap: () async {
                      Navigator.pop(context);
                      await GallerySaver.saveImage(
                        widget.message.msg,
                        albumName: AppString.youChat,
                      ).then((success) {
                        try {
                          if (success != null && success) {
                            UiHelper.showSnakBar(
                              context,
                              AppString.imageSaved,
                              AppColor.greenColor,
                            );
                          }
                        } catch (error) {
                          print(error);
                        }
                      });
                    }),
// ================================ edit message icon ===================================
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon: Icon(
                  Icons.edit,
                  color: AppColor.whiteSecondary,
                  size: 26,
                ),
                name: AppString.editMessage,
                onTap: () {
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                },
              ),
// ================================ delete message icon ===================================
            if (isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.delete,
                    color: AppColor.whiteSecondary,
                    size: 26,
                  ),
                  name: AppString.deleteMessage,
                  onTap: () async {
                    Navigator.pop(context);
                    _showDeleteMessageDialog();
                  }),
// ================================ send time message icon ===================================
            _OptionItem(
              icon: Icon(
                Icons.visibility,
                color: AppColor.whiteSecondary,
                size: 26,
              ),
              name:
                  "Sent At : ${MyDateUtils.getMessageTime(context: context, time: widget.message.sent)}",
              onTap: () {},
            ),
// ================================ seen time message icon ===================================
            _OptionItem(
              icon: Icon(
                Icons.visibility_off,
                color: AppColor.whiteSecondary,
                size: 26,
              ),
              name: widget.message.read.isEmpty
                  ? AppString.notSeenYet
                  : "Seen At : ${MyDateUtils.getMessageTime(context: context, time: widget.message.read)}",
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  // ================================ showDeleteConfirmationDialog function ===================================
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.bgLight1,
          title: Text(
            'Confirm Delete',
            style: AppStyle.mediumBodyStyle,
          ),
          content: Text(
            'Are you sure you want to delete?',
            style: AppStyle.mediumBodyStyle,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: AppStyle.smallBodyStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: AppStyle.smallRedTextStyle,
              ),
              onPressed: () async {
                await Apis.deleteMessage(widget.message).then((value) {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  // ================================ _showDeleteMessageDialog() function ===================================
  void _showDeleteMessageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.bgLight1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDeleteConfirmationDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColor.whiteSecondary,
                      size: 26,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppString.deleteForMe,
                      style: AppStyle.mediumBodyStyle,
                    )
                  ],
                ),
              ),
              Gap(20),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  showDeleteConfirmationDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColor.whiteSecondary,
                      size: 26,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppString.deleteForEveryone,
                      style: AppStyle.mediumBodyStyle,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================ _showMessageUpdateDialog() function ===================================
  void _showMessageUpdateDialog() {
    String updateMessage = widget.message.msg;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.bgLight1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.message,
              color: AppColor.whiteSecondary,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppString.updateMessage,
              style: AppStyle.mediumBodyStyle,
            )
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (newMessage) => updateMessage = newMessage,
          initialValue: updateMessage,
          style: AppStyle.smallBodyStyle,
          cursorColor: AppColor.whiteSecondary,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.whiteSecondary),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.whiteSecondary),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.whiteSecondary),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppString.cancel,
              style: AppStyle.smallBodyStyle,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Apis.updateMessage(widget.message, updateMessage);
            },
            child: Text(
              AppString.update,
              style: AppStyle.smallBodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 10, bottom: 20),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Text(
              "$name",
              style: AppStyle.smallBodyStyle,
            ))
          ],
        ),
      ),
    );
  }
}
