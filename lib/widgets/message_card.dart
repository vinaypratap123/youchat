import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:youchat/apis/apis.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/app_styles.dart';
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
    return Apis.user.uid == widget.message.fromId
        ? _myMessage()
        : _anotherMessage();
  }

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
}
