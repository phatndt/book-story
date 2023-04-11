import 'dart:developer';

import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/repos/chatting_repo_impl.dart';

class ChattingSetting {
  final TextEditingController messageController;
  final String chatDocumentId;
  ChattingSetting({
    required this.messageController,
    required this.chatDocumentId,
  });

  ChattingSetting copy({
    TextEditingController? messageController,
    String? chatDocumentId,
  }) =>
      ChattingSetting(
        messageController: messageController ?? this.messageController,
        chatDocumentId: chatDocumentId ?? this.chatDocumentId,
      );
}

class ChattingSettingNotifier extends StateNotifier<ChattingSetting> {
  ChattingSettingNotifier(this.ref)
      : super(ChattingSetting(
            messageController: TextEditingController(), chatDocumentId: "")) {
    _chattingRepo = ref.watch(chattingRepoProvider);
  }
  final Ref ref;
  late ChattingRepo _chattingRepo;

  setChatDocumentId(String id) {
    final newState = state.copy(chatDocumentId: id);
    state = newState;
  }

  createChatting(String user1, String user2) async {
    final _result1 = await _chattingRepo.checkExistChatting(user1, user2);
    final _result2 = await _chattingRepo.checkExistSecondChatting(user1, user2);

    log(_result1.toString() + _result2.toString());

    if (_result1 == null && _result2 == null) {
      final result = await _chattingRepo.createChatting(user1, user2);

      setChatDocumentId(result!);
    } else {
      if (_result1 != null) {
        setChatDocumentId(_result1);
      } else {
        setChatDocumentId(_result2!);
      }
    }
    log(state.chatDocumentId);
  }

  addChattingMessage(String message) {
    _chattingRepo.addChattingMessage(ref.watch(mainAppNotifierProvider).user.id,
        state.chatDocumentId, message);
  }
}

final chattingSettingNotifier =
    StateNotifierProvider<ChattingSettingNotifier, ChattingSetting>(
        (ref) => ChattingSettingNotifier(ref));

final getChattingProvider = StreamProvider.autoDispose(
  (ref) => FirebaseFirestore.instance.collection('chatting').snapshots(),
);

final getChattingMessageProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
  (ref, docId) {
    log("getChattingMessageProvider");
    return FirebaseFirestore.instance
        .collection('chatting')
        .doc(docId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots();
  },
);
