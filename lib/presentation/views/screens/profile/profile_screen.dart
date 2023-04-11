import 'dart:developer';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/profile_component.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/colors/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: S.colors.white,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.topCenter,
              fit: StackFit.loose,
              children: [
                Container(
                  color: S.colors.white,
                  child: ClipPath(
                    clipper: CustomShape(),
                    child: Container(
                      height: 150,
                      color: S.colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -S.size.length_20,
                  right: S.size.length_20,
                  left: S.size.length_20,
                  child: ProfileWidget(
                    imagePath: ref.watch(mainAppNotifierProvider).user.image,
                    onPressed: () {
                      ref
                          .watch(profileNotifierProvider.notifier)
                          .showImageSourceActionSheet(context);
                    },
                    username: ref.watch(mainAppNotifierProvider).user.username,
                    email: ref.watch(mainAppNotifierProvider).user.email,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: S.size.length_40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: S.size.length_20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(S.size.length_10),
                  ),
                ),
                child: Column(
                  children: [
                    ProfileCard(
                      icon: FontAwesomeIcons.user,
                      name: "Information",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.changeInformation,
                        );
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: S.colors.grey,
                    ),
                    ProfileCard(
                      icon: FontAwesomeIcons.passport,
                      name: "Change password",
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.changePassword);
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: S.colors.grey,
                    ),
                    ProfileCard(
                      icon: FontAwesomeIcons.locationDot,
                      name: "Location",
                      onTap: () {
                        ref
                            .watch(profileNotifierProvider.notifier)
                            .handleAddress(context);
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: S.colors.grey,
                    ),
                    ProfileCard(
                      icon: FontAwesomeIcons.blog,
                      name: "My post",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.myPost,
                        );
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: S.colors.grey,
                    ),
                    ProfileCard(
                      icon: FontAwesomeIcons.accessibleIcon,
                      name: "Log out",
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutePaths.logIn,
                          (route) => false,
                        );
                        ref.refresh(mainAppNotifierProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(S.size.length_10),
        height: S.size.length_64,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
            ),
            SizedBox(
              width: S.size.length_20,
            ),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    required this.username,
    required this.email,
  }) : super(key: key);
  final String imagePath;
  final VoidCallback onPressed;
  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    final image = imagePath.isNotEmpty
        ? NetworkImage(imagePath)
        : const NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSegCgK5aWTTuv_K5TPd10DcJxphcBTBct6R170EamgcCOcYs7LGKVy7ybRc-MCwOcHljg&usqp=CAU");

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(S.size.length_10),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(S.size.length_10),
        child: Row(
          children: [
            SizedBox(
              width: S.size.length_10,
            ),
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: image,
                  width: S.size.length_64,
                  height: S.size.length_64,
                  child: GestureDetector(
                    onTap: onPressed,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: S.size.length_20,
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_10,
                  ),
                  Text(
                    email,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: S.colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height + 50;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
