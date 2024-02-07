class MessageModel {
  MessageModel({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
    required this.fromId,
    this.starred = false,
    this.replyToMessageModelId,
  });

  late final String msg;
  late final String read;
  late final String told;
  late final String sent;
  late final String fromId;
  late final Type type;
  late bool starred;
  String? replyToMessageModelId;

  // ************************************ fromJson() function ******************************************
  MessageModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
    starred = json['starred'] == true;
    replyToMessageModelId = json['replyToMessageModelId']?.toString();
  }

  // ************************************ toJson() function ******************************************
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['read'] = read;
    _data['told'] = told;
    _data['type'] = type.name;
    _data['sent'] = sent;
    _data['fromId'] = fromId;
    _data['starred'] = starred;
    _data['replyToMessageModelId'] = replyToMessageModelId;
    return _data;
  }
}

enum Type { text, image }
