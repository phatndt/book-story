import 'dart:developer';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/map_component.dart';
import 'package:book_exchange/presentation/view_models/map/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlng/latlng.dart';
import 'package:latlong2/latlong.dart' as latlng;

import '../../../../../core/colors/colors.dart';

class ShareScreen extends ConsumerWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: ref.watch(getAllUserProvider(ref.watch(getAllUserUseCase))).when(
            data: (data) {
              data.data.removeWhere((element) => element.address.isEmpty);
              log(data.data.length.toString());
              // ref
              //     .watch(mapNotifierProvider.notifier)
              //     .setUserList(data.data);
              return Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: ref
                              .watch(mainAppNotifierProvider)
                              .user
                              .address
                              .isNotEmpty
                          ? latlng.LatLng(
                              double.parse(ref
                                  .watch(mainAppNotifierProvider)
                                  .user
                                  .address
                                  .split("|")
                                  .first),
                              double.parse(
                                ref
                                    .watch(mainAppNotifierProvider)
                                    .user
                                    .address
                                    .split("|")
                                    .last,
                              ),
                            )
                          : null,
                      zoom: 9.2,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/thanhphat219/clckablis001415mu2b4wsjp6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhhbmhwaGF0MjE5IiwiYSI6ImNsY2swNHJsMTA0NzAzbm14N25pNnRnbG0ifQ.bZx2lOjIMGPRhuaG_yMP_w',
                        additionalOptions: {
                          'accessToken': AppConstants.mapBoxAccessToken,
                          'id': AppConstants.mapBoxStyleId,
                        },
                      ),
                      MarkerLayerOptions(
                        markers: [
                          for (int i = 0; i < data.data.length; i++)
                            Marker(
                              height: 40,
                              width: 40,
                              point: latlng.LatLng(
                                  double.parse(
                                      data.data[i].address.split("|").first),
                                  double.parse(
                                    data.data[i].address.split("|").last,
                                  )),
                              builder: (_) {
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .watch(mapNotifierProvider)
                                        .pageController
                                        .animateToPage(
                                          i,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.locationDot,
                                    size: 36,
                                    color: S.colors.orange,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 2,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: PageView.builder(
                      controller: ref.watch(mapNotifierProvider).pageController,
                      onPageChanged: (value) {},
                      itemCount: data.data.length,
                      itemBuilder: (_, index) {
                        final item = data.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: S.colors.white,
                            child: MarkerWidget(
                                imagePath: item.image,
                                username: item.username,
                                appUser:
                                    ref.watch(mainAppNotifierProvider).user.id,
                                guestUser: item.id),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
            error: (error, stack) {
              log(error.toString());
              return const Center(
                  child: Text("Something wrong! Please try other."));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}

class AppConstants {
  static const String mapBoxAccessToken =
      'sk.eyJ1IjoidGhhbmhwaGF0MjE5IiwiYSI6ImNsY2thZ25qcDBzZnEzcXA2OTE4ZjlnNTAifQ.MZsxeMaUHPx05NOQyjlmKg';

  static const String mapBoxStyleId = 'mapbox.mapbox-streets-v8';

  static final myLocation = LatLng(51.5090214, -0.1982948);
}

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

class MarkerWidget extends ConsumerWidget {
  const MarkerWidget({
    Key? key,
    required this.imagePath,
    required this.username,
    required this.appUser,
    required this.guestUser,
  }) : super(key: key);
  final String imagePath;
  final String username;
  final String appUser;
  final String guestUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32.w,
              backgroundImage: imagePath.isNotEmpty
                  ? NetworkImage(imagePath)
                  : const NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSegCgK5aWTTuv_K5TPd10DcJxphcBTBct6R170EamgcCOcYs7LGKVy7ybRc-MCwOcHljg&usqp=CAU"),
            ),
            SizedBox(
              width: S.size.length_10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: S.colors.orange,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: S.size.length_10,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      ref
                          .watch(chattingSettingNotifier.notifier)
                          .createChatting(appUser, guestUser);
                      Navigator.pushNamed(context, RoutePaths.chatMessage);
                    },
                    child: const Text("Chat")))
            // GestureDetector(
            //   child: const Icon(FontAwesomeIcons.ellipsisVertical),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
