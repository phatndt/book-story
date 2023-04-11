import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../../../core/colors/colors.dart';
import '../../../view_models/map/chat_view_model.dart';
import '../../widgets/chat/chat_left_item.dart';
import '../../widgets/chat/chat_right_item.dart';

class ChattingMessageScreen extends ConsumerWidget {
  const ChattingMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: S.size.length_10Vertical),
          child: Column(
            children: [
              SizedBox(
                height: S.size.length_10Vertical,
              ),
              Expanded(
                child: ref
                    .watch(getChattingMessageProvider(
                        ref.watch(chattingSettingNotifier).chatDocumentId))
                    .when(
                      data: (data) {
                        if (data.docs.isEmpty) {
                          return Container();
                        } else {
                          return ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (itemBuilder, index) {
                              if (data.docs[index]['sentBy'] ==
                                  ref.watch(mainAppNotifierProvider).user.id) {
                                return ChattingRightItem(
                                  message: data.docs[index]['messageText'],
                                  time: DateFormat('hh:mm').format(
                                    DateTime.parse(data.docs[index]['sentAt']),
                                  ),
                                );
                              } else {
                                return ChattingLeftItem(
                                  message: data.docs[index]['messageText'],
                                  time: DateFormat('hh:mm').format(
                                    DateTime.parse(data.docs[index]['sentAt']),
                                  ),
                                );
                                // return ref
                                //     .watch(getRequestingUserProvider(
                                //         data.docs[index]['sentBy']))
                                //     .when(
                                //       data: (value) {
                                //         return ChattingLeftItem(
                                //           message: data.docs[index]
                                //               ['messageText'],
                                //           time: DateFormat('hh:mm').format(
                                //             DateTime.parse(
                                //                 data.docs[index]['sentAt']),
                                //           ),
                                //           image: value['imageUrl'],
                                //           name: '',
                                //         );
                                //       },
                                //       error: (error, stack) => Center(
                                //         child: Lottie.network(
                                //             'https://assets9.lottiefiles.com/packages/lf20_hXHdlx.json'),
                                //       ),
                                //       loading: () => const Center(
                                //         child: CircularProgressIndicator(),
                                //       ),
                                //     );
                              }
                            },
                          );
                        }
                      },
                      error: (error, stack) => Center(
                        child: Lottie.network(
                            'https://assets9.lottiefiles.com/packages/lf20_hXHdlx.json'),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: S.size.length_10Vertical),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: S.size.length_10),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.face),
                              SizedBox(
                                width: S.size.length_10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: ref
                                      .watch(chattingSettingNotifier)
                                      .messageController,
                                  decoration: const InputDecoration(
                                      hintText: "Type Something...",
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: S.colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onTap: () {
                          ref
                              .watch(chattingSettingNotifier.notifier)
                              .addChattingMessage(ref
                                  .watch(chattingSettingNotifier)
                                  .messageController
                                  .text);
                          ref
                              .watch(chattingSettingNotifier)
                              .messageController
                              .clear();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
