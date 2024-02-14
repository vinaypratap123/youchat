import 'package:flutter/material.dart';

class MyDateUtils {
  // ================================ getMessageTime() function=================================
  static String getMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    return now.year == sent.year
        ? "$formattedTime - ${sent.day} ${_getMonth(sent)}"
        : "$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}";
  }

  // ================================ getFormattedTime() function=================================
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // ================================ getLastMessageTime() function=================================
  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return "${sent.day} ${_getMonth(sent)}";
  }

  // ================================ getLastActiveTime() function=================================
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;
    if (i == -1) return "last seen not available";
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return "last seen today at $formattedTime";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "last seen yesterday at $formattedTime";
    }
    String month = _getMonth(time);
    return "last seen ${time.day} $month on ${formattedTime}";
  }

  // ================================ _getMonth() function=================================
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "N/A";
    }
  }

  static void openKeyboard(BuildContext context, FocusNode _focusNode) {
    FocusScope.of(context).requestFocus(_focusNode);
  }
}
