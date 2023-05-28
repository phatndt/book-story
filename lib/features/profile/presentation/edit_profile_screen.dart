import 'dart:io';

import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/features/profile/presentation/state/edit_profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/core.dart';
import '../../../core/navigation/route_paths.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_elevated_button.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';
import '../di/profile_module.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController nameController;
  late bool isShowClearIconNameController;
  late String imageUrl;
  late String? pickedImageUrl;
  late String displayName;
  late GlobalKey<FormState> formState;
  late bool isShowLoading;
  late bool flagDisplayName;

  @override
  void initState() {
    super.initState();
    isShowLoading = false;
    flagDisplayName = false;
    nameController = TextEditingController();
    isShowClearIconNameController = false;
    formState = GlobalKey<FormState>();
    imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/book-story-d79dd.appspot.com/o/local_profile_avatar.png?alt=media&token=e0224436-ab20-4c73-afa5-06784e090fae";
    pickedImageUrl = null;
    Future.delayed(Duration.zero, () {
      nameController = TextEditingController(
          text: ModalRoute.of(context)?.settings.arguments as String);
      displayName = ModalRoute.of(context)?.settings.arguments as String;
      ref.watch(editProfileStateNotifierProvider.notifier).getProfilePhoto();
      // ref.watch(editProfileStateNotifierProvider.notifier).getProfileName();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editProfileStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.data.toString()));
        ref.watch(profileStateNotifierProvider.notifier).getProfileName();
        ref.watch(profileStateNotifierProvider.notifier).getProfilePhoto();
      } else if (next is UIErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
      } else if (next is UIUpdateProfilePhotoUrlSuccessState) {
        setState(() {
          imageUrl = next.message;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.message));
        ref.watch(profileStateNotifierProvider.notifier).getProfilePhoto();
      } else if (next is UIUpdateProfileNameSuccessState) {
        setState(() {
          displayName = nameController.text;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.message));
        ref.watch(profileStateNotifierProvider.notifier).getProfileName();
      } else if (next is UIGetProfilePhotoUrlSuccessState) {
        setState(() {
          imageUrl = next.message;
        });
      } else if (next is UIGetProfileNameSuccessState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.name));
        setState(() {
          displayName = next.name;
          nameController.text = next.name;
        });
      }
    });
    return SafeArea(
      child: Form(
        key: formState,
        child: ModalProgressHUD(
          inAsyncCall: isShowLoading,
          child: Scaffold(
            backgroundColor: S.colors.white,
            appBar: CustomAppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: S.colors.primary_3,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  const SizedBox(width: double.infinity),
                  InkWell(
                    onTap: () {
                      showImageSourceActionSheet(
                        context,
                        () async {
                          final path =
                              await selectImageSource(ImageSource.camera);
                          if (path != null) {
                            setState(() {
                              pickedImageUrl = path;
                            });
                          }
                        },
                        () async {
                          final path =
                              await selectImageSource(ImageSource.gallery);
                          if (path != null) {
                            setState(() {
                              pickedImageUrl = path;
                            });
                          }
                        },
                      );
                    },
                    child: _imageBuilder(),
                  ),
                  SizedBox(height: 24.h),
                  CustomTextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          isShowClearIconNameController = true;
                        });
                      } else {
                        setState(() {
                          isShowClearIconNameController = false;
                        });
                      }
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'your_name_not_empty'.tr();
                        }
                      }
                      return null;
                    },
                    hintText: 'your_name'.tr(),
                    obscureText: false,
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    inputType: TextInputType.name,
                    suffixIconData: isShowClearIconNameController
                        ? IconButton(
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              nameController.clear();
                              setState(() {
                                isShowClearIconNameController = false;
                              });
                            },
                          )
                        : null,
                  ),
                  SizedBox(height: 24.h),
                  CustomElevatedButton(
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        ref
                            .watch(editProfileStateNotifierProvider.notifier)
                            .updateProfile(
                              pickedImageUrl,
                              displayName,
                              nameController.text.trim(),
                            );
                      }
                    },
                    child: Text('create_new_book_shelf'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageBuilder() {
    if (pickedImageUrl == null) {
      return CachedNetworkImage(
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
              image: AssetImage("assets/images/local_profile_avatar.png"),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(82.w),
        child: Image.file(
          File(pickedImageUrl!),
          height: 164.w,
          width: 164.w,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}
