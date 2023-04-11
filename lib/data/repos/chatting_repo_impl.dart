import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final chattingRepoProvider = Provider<ChattingRepo>((ref) => ChattingRepo());

class ChattingRepo {
  Future<String?> createChatting(String user1, String user2) async {
    String? _result;
    try {
      await FirebaseFirestore.instance.collection('chatting').add({
        'user1': user1,
        'user2': user2,
      }).then(
        (value) {
          _result = value.id;
        },
      );
    } catch (e) {
      log("createChatting" + e.toString());
    }
    return _result;
  }

  Future<String?> checkExistChatting(String user1, String user2) async {
    String? _result;
    try {
      await FirebaseFirestore.instance
          .collection('chatting')
          .where('user1', isEqualTo: user1)
          .where('user2', isEqualTo: user2)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          _result = value.docs.first.id;
        }
      });
    } catch (e) {
      log("createChatting" + e.toString());
    }
    return _result;
  }

  Future<String?> checkExistSecondChatting(String user1, String user2) async {
    String? _result;
    try {
      await FirebaseFirestore.instance
          .collection('chatting')
          .where('user1', isEqualTo: user2)
          .where('user2', isEqualTo: user1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          _result = value.docs.first.id;
        }
      });
    } catch (e) {
      log("createChatting" + e.toString());
    }
    return _result;
  }

  Future<void> addChattingMessage(
      String userId, String chatDocumentId, String message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatting')
          .doc(chatDocumentId)
          .collection('messages')
          .add({
        'messageText': message,
        'sentAt': DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
        'sentBy': userId,
      });
    } catch (e) {
      log("createChatting" + e.toString());
    }
  }
}
