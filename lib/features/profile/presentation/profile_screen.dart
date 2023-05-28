import 'dart:developer';

import 'package:book_story/core/extension/function_extension.dart';
import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/core/widget/snack_bar.dart';
import 'package:book_story/features/profile/di/profile_module.dart';
import 'package:book_story/features/profile/presentation/state/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/core.dart';
import '../../../core/presentation/state.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late String imageUrl;
  late String displayName;
  late bool isShowLoading;
  @override
  void initState() {
    super.initState();
    isShowLoading = false;
    imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/book-story-d79dd.appspot.com/o/local_profile_avatar.png?alt=media&token=e0224436-ab20-4c73-afa5-06784e090fae";
    displayName = '';
    Future.delayed(Duration.zero, () {
      ref.watch(profileStateNotifierProvider.notifier).getProfilePhoto();
      ref.watch(profileStateNotifierProvider.notifier).getProfileName();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UIErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
      } else if (next is UIGetProfilePhotoUrlSuccessState) {
        setState(() {
          imageUrl = next.message;
        });
      } else if (next is UIGetProfileNameSuccessState) {
        setState(() {
          displayName = next.name;
        });
      }
    });

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isShowLoading,
        child: Scaffold(
          backgroundColor: S.colors.white,
          appBar: CustomAppBar(
            leading: IconButton(
              tooltip: "Update read file book",
              icon: Icon(
                Icons.logout,
                color: S.colors.primary_3,
              ),
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutePaths.logIn, (route) => false);
                FirebaseAuth.instance.signOut();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.editProfile, arguments: displayName);
                },
                icon: Icon(
                  Icons.mode_edit,
                  color: S.colors.primary_3,
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                const SizedBox(width: double.infinity),
                InkWell(
                  onTap: () {},
                  child: CachedNetworkImage(
                    height: 164.w,
                    width: 164.w,
                    fit: BoxFit.fill,
                    imageUrl: imageUrl,
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
                    placeholder: (context, url) => SizedBox(
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
                          image: AssetImage(
                              "assets/images/local_profile_avatar.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: S.colors.primary_3,
                  ),
                ).isShow(displayName.isNotEmpty),
              ],
            ),
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
