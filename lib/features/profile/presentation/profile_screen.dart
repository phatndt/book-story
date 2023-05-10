import 'dart:developer';

import 'package:book_story/core/navigation/route_paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: S.colors.white,
        appBar: AppBar(
          backgroundColor: S.colors.white,
          elevation: 0.2,
          actions: [
            IconButton(
              tooltip: "Update read file book",
              icon: Icon(
                Icons.edit_note,
                color: S.colors.primary_3,
              ),
              onPressed: () async {
                // Navigator.pushNamedAndRemoveUntil(
                //     context, RoutePaths.logIn, (route) => false);
                // FirebaseAuth.instance.signOut();
                FirebaseAuth.instance.currentUser?.updatePhotoURL(
                    "https://scontent-sin6-4.xx.fbcdn.net/v/t39.30808-6/326785493_710556047338421_6151358611972506992_n.jpg?stp=cp6_dst-jpg&_nc_cat=101&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=uunbDH4W-F8AX9KCq6y&_nc_ht=scontent-sin6-4.xx&oh=00_AfBXNVE9VGEimE0kIMpA783JibGes2QR7OV1hNR57JCgzQ&oe=645ED569");
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              CachedNetworkImage(
                height: 164.w,
                width: 164.w,
                fit: BoxFit.fill,
                imageUrl: setImageAvatar(),
                imageBuilder: (context, imageProvider) => Container(
                  height: 164.w,
                  width: 164.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 164.w,
                  width: 164.w,
                  child: const SkeletonAvatar(
                    style: SkeletonAvatarStyle(shape: BoxShape.circle),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 164.w,
                  width: 164.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/local_profile_avatar.png"),
                    ),
                  ),
                ),
              ),
              if (FirebaseAuth.instance.currentUser?.displayName != null)
                Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: S.colors.primary_3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String setImageAvatar() {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser?.photoURL != null) {
      return FirebaseAuth.instance.currentUser!.photoURL!;
    } else {
      return "";
    }
  }
}
