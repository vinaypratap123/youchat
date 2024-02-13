import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youchat/app/app_colors.dart';
import 'package:youchat/app/ui_helper.dart';
import 'package:youchat/models/chat_user_model.dart';
import 'package:youchat/models/message_model.dart';

class Apis {
  // ************************************ FirebaseAuth instance *************************************
  static FirebaseAuth auth = FirebaseAuth.instance;

  // ************************************  FirebaseFirestore instance ********************************
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ************************************  FirebaseStorage instance ***********************************
  static FirebaseStorage storage = FirebaseStorage.instance;

  // ************************************  FirebaseMessaging instance ***********************************
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // ************************************  current login user ******************************************
  static ChatUserModel? currentUser;

  // ************************************  current login user ******************************************
  static User get user => auth.currentUser!;

  // ************************************  isUserExists() function ******************************************
  static Future<bool> isUserExists() async {
    bool isUserExists =
        (await firestore.collection("users").doc(user.uid).get()).exists;
    return isUserExists;
  }

  // ************************************  createUser() function ******************************************
  static Future<void> createUser() async {
    final time = DateTime.now().second.toString();
    final chatUser = ChatUserModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey there, I'm using YouChat!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // ************************************  getAllUser() function ******************************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  // ***************************** signInWithGoogle() function ****************************
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup("google.com");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await Apis.auth.signInWithCredential(credential);
    } catch (error) {
      UiHelper.showSnakBar(context, error.toString(), AppColor.redColor);
      return null;
    }
  }

  // ************************************  getCurrentUserInfo() function ******************************************
  static Future<void> getCurrentUserInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        currentUser = ChatUserModel.fromJson(user.data()!);
        // await getFirebaseMessagingToken();
      } else {
        await createUser().then((value) => getCurrentUserInfo());
      }
    });
  }
  // ************************************  sendPushNotification() function *******************************
  // static Future<void> sendPushNotification(
  //     ChatUser chatUser, String msg) async {
  //   try {
  //     final body = {
  //       "to": chatUser.pushToken,
  //       "notification": {
  //         "title": currentUser!.name,
  //         "body": msg,
  //         "android_channel_id": "Chats",
  //       },
  //       "data": {
  //         "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       },
  //     };

  //     await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  //         headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //           HttpHeaders.authorizationHeader:
  //               "key=AAAAK1-i0Bs:APA91bGOQ1nWHU33Hz4viQz9PSO_v7tz1N3ipbFSBF8BvzgnH07PoywpWhqOIj0QP1LXUyR3RIjo7GbYvI2o3ShgAhbLR0JtRye6C396Pwoz0CICsA_GYwvmzrbPBjmT9Vt-LIAc5fWg",
  //         },
  //         body: jsonEncode(body));
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // ************************************  getFirebaseMessagingToken() function *****************************
  // static Future<void> getFirebaseMessagingToken() async {
  //   await fMessaging.requestPermission();
  //   await fMessaging.getToken().then((token) {
  //     if (token != null) {
  //       currentUser?.pushToken = token;
  //     }
  //   });
  // }

  // ************************************  createUserWithEmailAndPassword() function ***************************
  // static Future<void> createUserWithEmailAndPassword(
  //   String name,
  //   String email,
  // ) async {
  //   final time = DateTime.now().second.toString();

  //   final chatUser = ChatUser(
  //     id: user.uid,
  //     name: name,
  //     email: email,
  //     about: "Hey there, I'm using U Chat!",
  //     image: user.photoURL.toString(),

  //     createdAt: time,
  //     isOnline: false,
  //     lastActive: time,
  //     pushToken: "",
  //   );

  //   await firestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(chatUser.toJson())
  //       .then((value) {});
  // }

  // ************************************  getConversationId() arrow function ******************************************
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : "${id}_${user.uid}";

  // ************************************ getAllMessages() function ******************************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel user) {
    return firestore
        .collection("chats/${getConversationId(user.id)}/message/")
        .orderBy("sent", descending: true)
        .snapshots();
  }

  // ************************************ getLastMessages() function ******************************************
  static Future<bool> hasLastMessage(ChatUserModel user) async {
    final querySnapshot = await firestore
        .collection("chats/${getConversationId(user.id)}/message/")
        .orderBy("sent", descending: true)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // ************************************ getLastMessages() function ******************************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUserModel user) {
    return firestore
        .collection("chats/${getConversationId(user.id)}/message/")
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  // ************************************ getUserInfo() function ******************************************
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
  //     ChatUser chatUser) {
  //   return firestore
  //       .collection("users")
  //       .where("id", isEqualTo: chatUser.id)

  //       .snapshots();
  // }

  // ************************************ updateActiveStatus() function ******************************************
  // static Future<void> updateActiveStatus(bool isOnline) async {
  //   firestore.collection("users").doc(user.uid).update({
  //     "is_online": isOnline,
  //     "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
  //     "push_token": currentUser?.pushToken,
  //   });
  // }

  // ************************************ updateUserInfo() function ******************************************
  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update(
      {"name": currentUser!.name, "about": currentUser!.about},
    );
  }

  // ************************************ sendMessage() function ******************************************
  static Future<void> sendMessage(
      ChatUserModel chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessageModel message = MessageModel(
        msg: msg,
        read: "",
        told: chatUser.id,
        type: type,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection("chats/${getConversationId(chatUser.id)}/message/");
    await ref.doc(time).set(message.toJson());
    // await ref.doc(time).set(message.toJson()).then((value) =>
    //     sendPushNotification(chatUser, type == Type.text ? msg : "image"),);
  }

  // ************************************ updateProfilePicture() function ******************************************
  static Future<void> updateProfilePicture(file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child("profile_picture/${user.uid}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: "image/$ext"));
    currentUser!.image = await ref.getDownloadURL();
    await firestore.collection("users").doc(user.uid).update({
      "image": currentUser!.image,
    });
  }

  // ************************************ updateMessageReadTime() function ******************************************
  static Future<void> updateMessageReadTime(MessageModel message) async {
    firestore
        .collection("chats/${getConversationId(message.fromId)}/message/")
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // ************************************ sendChatImage() function ******************************************
  // static Future<void> sendChatImage(ChatUser chatUser, file) async {
  //   final ext = file.path.split(".").last;
  //   final ref = storage.ref().child(
  //       "image/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
  //   await ref.putFile(file, SettableMetadata(contentType: "image/$ext"));
  //   final imageUrl = await ref.getDownloadURL();
  //   await Apis.sendMessage(chatUser, imageUrl, Type.image);
  // }

  // ************************************ deleteMessage() function ******************************************
  // static Future<void> deleteMessage(Message message) async {
  //   firestore
  //       .collection("chats/${getConversationId(message.told)}/message/")
  //       .doc(message.sent)
  //       .delete();
  //   if (message.type == Type.image) storage.refFromURL(message.msg).delete();
  // }

  // ************************************ updateMessage() function ******************************************

  // static Future<void> updateMessage(
  //     Message message, String updatedMessage) async {
  //   firestore
  //       .collection("chats/${getConversationId(message.told)}/message/")
  //       .doc(message.sent)
  //       .update({"msg": updatedMessage});
  // }
  // ************************************ updatereadcount() function ******************************************

  // static Future<void> updateReadCount(int unReadCount) async {
  //   firestore.collection("users").doc(user.uid).update({
  //     "unreadMessagesCount": unReadCount,
  //   });
  // }
// ************************************ blockUser() function ******************************************

  // static Future<bool> blockUser(String blockedUserId) async {
  //   try {
  //     final currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser == null) {
  //       return false;
  //     }
  //     final currentUserId = currentUser.uid;

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .update({
  //       'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
  //     });
  //     // test
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(blockedUserId)
  //         .update({
  //       'blockedUsers': FieldValue.arrayUnion([currentUserId]),
  //     });
  //     print(
  //         '++++++++++User with ID $blockedUserId has been blocked by User with ID $currentUserId');
  //     return true;
  //   } catch (error) {
  //     print('Error blocking user: $error');
  //     return false;
  //   }
  // }

// ************************************ unblockUser() function ******************************************
  // static Future<void> unblockUser(String unblockedUserId) async {
  //   try {
  //     final currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser == null) {
  //       return;
  //     }
  //     final currentUserId = currentUser.uid;

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .update({
  //       'blockedUsers': FieldValue.arrayRemove([unblockedUserId]),
  //     });
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(unblockedUserId)
  //         .update({
  //       'blockedUsers': FieldValue.arrayRemove([currentUserId]),
  //     });

  //     print(
  //         '+++++++++++++User with ID $unblockedUserId has been unblocked by User with ID $currentUserId');
  //   } catch (error) {
  //     print('Error unblocking user: $error');
  //   }
  // }

// ************************************ toggleMessageStarStatus() function ******************************************
  // static Future<void> toggleMessageStarStatus(Message message) async {
  //   message.starred = !message.starred;
  //   try {
  //     firestore
  //         .collection("chats/${getConversationId(message.fromId)}/message/")
  //         .doc(message.sent)
  //         .update({"starred": message.starred});

  //     print('Message star statuss updated successfully!');
  //   } catch (error) {
  //     print('Error updating message star status: $error');
  //   }
  // }

  // ***************************** handleGoogleLogin() function ****************************
  // static dynamic handleGoogleLogin(BuildContext context) {
  //   Dialogs.showProgressBar(context);
  //   Apis.signInWithGoogle(context).then((user) async {
  //     Navigator.pop(context);
  //     if (user != null) {
  //       if (await Apis.isUserExists()) {
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => const HomeScreen()));
  //       } else {
  //         Apis.createUser().then((value) {
  //           Navigator.pushReplacement(context,
  //               MaterialPageRoute(builder: (context) => const HomeScreen()));
  //         });
  //       }
  //     }
  //   });
  // }
}
