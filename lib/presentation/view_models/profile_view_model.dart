import 'dart:developer';
import 'dart:io';

import 'package:book_exchange/domain/use_cases/change_information/change_avatar_path_use_case.dart';
import 'package:book_exchange/domain/use_cases/profile/get_user_use_case.dart';
import 'package:book_exchange/domain/use_cases/profile/upload_avatar_use_case.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/profile_component.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/colors/colors.dart';
import '../../core/extension/function_extension.dart';
import '../../domain/use_cases/change_information/change_address_use_case.dart';

class ProfileSetting {
  File image;
  String avatarPath;

  ProfileSetting({
    required this.image,
    required this.avatarPath,
  });

  ProfileSetting copy({
    File? image,
    String? avatarPath,
  }) =>
      ProfileSetting(
        image: image ?? this.image,
        avatarPath: avatarPath ?? this.avatarPath,
      );
}

class ProfileNotifier extends StateNotifier<ProfileSetting> {
  ProfileNotifier(
    this.ref,
    this._uploadAvatarUseCase,
    this._changeAvatarPathUseCase,
    this.getUserUseCase,
    this._changeAdressUseCase,
  ) : super(ProfileSetting(
            image: File(''),
            avatarPath:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTTePuOPXGxeejH4JuEO25wUWo-2jSefa3JUOCkwZKcfzi5rw7Z0XgR6-3OON8yrCOIlg&usqp=CAU"));
  final Ref ref;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final ChangeAvatarPathUseCase _changeAvatarPathUseCase;
  final GetUserUseCase getUserUseCase;
  final ChangeAdressUseCase _changeAdressUseCase;

  setAvatarPath(String path) {
    final newState = state.copy(avatarPath: path);
    state = newState;
  }

  void updateImage(File file) {
    final newState = state.copy(image: file);
    state = newState;
  }

  void showImageSourceActionSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera, context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery, context);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera, context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery, context);
            },
          ),
        ]),
      );
    }
  }

  void selectImageSource(ImageSource imageSource, BuildContext context) async {
    // final _picker = ImagePicker();
    // final pickedImage = await _picker.pickImage(source: imageSource);
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) {
      return;
    }
    final userId = ref.watch(mainAppNotifierProvider).user.id;

    _uploadAvatarUseCase
        .uploadAvatarToCloud("$userId/avatar", File(pickedImage.path))
        .then(
      (value) {
        if (value != null) {
          changeAvatarPath(value, context);
        } else {
          if (ref.watch(mainAppNotifierProvider).context != null) {
            showTopSnackBar(
              context,
              const CustomSnackBar.error(
                message: "Something wrong",
              ),
              displayDuration: const Duration(seconds: 1),
            );
          }
        }
      },
    ).catchError((onError) {
      if (ref.watch(mainAppNotifierProvider).context != null) {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "Error: $onError",
          ),
          displayDuration: const Duration(seconds: 1),
        );
      }
    });
  }

  void handleAddress(BuildContext context) {
    if (ref.watch(mainAppNotifierProvider).user.address.isEmpty) {
      Dialogs.materialDialog(
        msg: 'Do you want to update your address?',
        msgAlign: TextAlign.center,
        title: "Address",
        color: Colors.white,
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancel',
            color: S.colors.grey,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () async {
              final address = await getLocation();
              Navigator.pop(context);
              if (address != null) {
                _changeAdressUseCase
                    .changeAdress(
                  address,
                  BookAppModel.jwtToken,
                  ref.watch(mainAppNotifierProvider).user.id,
                )
                    .then(
                  (value) {
                    showTopSnackBar(
                      ref.watch(mainAppNotifierProvider).context!,
                      CustomSnackBar.success(
                        message: value.message,
                      ),
                      displayDuration: const Duration(seconds: 1),
                    );
                    refreshUser();
                  },
                ).catchError((onError) {
                  if (ref.watch(mainAppNotifierProvider).context != null) {
                    catchOnError(
                        ref.watch(mainAppNotifierProvider).context, onError);
                  }
                });
              } else {
                showTopSnackBar(
                  ref.watch(mainAppNotifierProvider).context!,
                  const CustomSnackBar.success(
                    message: "Cannot get your location!",
                  ),
                  displayDuration: const Duration(seconds: 1),
                );
              }
            },
            text: 'Ok',
            color: S.colors.orange,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    } else {
      Dialogs.materialDialog(
        msg: 'Do you want to update or delete your address?',
        msgAlign: TextAlign.center,
        title: "Address",
        color: Colors.white,
        context: context,
        actions: [
          IconsButton(
            onPressed: () async {
              final address = await getLocation();
              Navigator.pop(context);
              if (address != null) {
                _changeAdressUseCase
                    .changeAdress(
                  address,
                  BookAppModel.jwtToken,
                  ref.watch(mainAppNotifierProvider).user.id,
                )
                    .then(
                  (value) {
                    showTopSnackBar(
                      ref.watch(mainAppNotifierProvider).context!,
                      CustomSnackBar.success(
                        message: value.message,
                      ),
                      displayDuration: const Duration(seconds: 1),
                    );
                    refreshUser();
                  },
                ).catchError((onError) {
                  if (ref.watch(mainAppNotifierProvider).context != null) {
                    catchOnError(
                        ref.watch(mainAppNotifierProvider).context, onError);
                  }
                });
              } else {
                showTopSnackBar(
                  ref.watch(mainAppNotifierProvider).context!,
                  const CustomSnackBar.success(
                    message: "Cannot get your location!",
                  ),
                  displayDuration: const Duration(seconds: 1),
                );
              }
            },
            text: 'Update',
            color: S.colors.grey,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () async {
              Navigator.pop(context);
              _changeAdressUseCase
                  .changeAdress(
                "",
                BookAppModel.jwtToken,
                ref.watch(mainAppNotifierProvider).user.id,
              )
                  .then(
                (value) {
                  showTopSnackBar(
                    ref.watch(mainAppNotifierProvider).context!,
                    CustomSnackBar.success(
                      message: value.message,
                    ),
                    displayDuration: const Duration(seconds: 1),
                  );
                  refreshUser();
                },
              ).catchError((onError) {
                if (ref.watch(mainAppNotifierProvider).context != null) {
                  catchOnError(
                      ref.watch(mainAppNotifierProvider).context, onError);
                }
              });
            },
            text: 'Delete',
            color: S.colors.orange,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    }
  }

  Future<String?> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    final lat = _locationData.latitude.toString();
    final long = _locationData.longitude.toString();
    return "$lat|$long";
  }

  void changeAvatarPath(String image, BuildContext context) {
    _changeAvatarPathUseCase
        .changeAvatarPath(
      image,
      BookAppModel.jwtToken,
      ref.watch(mainAppNotifierProvider).user.id,
    )
        .then(
      (value) {
        log("changeAvatarPath");
        if (ref.watch(mainAppNotifierProvider).context != null) {
          showTopSnackBar(
            ref.watch(mainAppNotifierProvider).context!,
            CustomSnackBar.success(
              message: value.message,
            ),
            displayDuration: const Duration(seconds: 1),
          );
        }
        refreshUser();
      },
    ).catchError((onError) {
      if (ref.watch(mainAppNotifierProvider).context != null) {
        catchOnError(ref.watch(mainAppNotifierProvider).context, onError);
      }
    });
  }

  void refreshUser() {
    getUserUseCase
        .getUser(
            ref.watch(mainAppNotifierProvider).user.id, BookAppModel.jwtToken)
        .then(
      (value) {
        log("getUser");
        ref.watch(mainAppNotifierProvider.notifier).setUser(value.data);
      },
    ).catchError((onError) {
      if (ref.watch(mainAppNotifierProvider).context != null) {
        catchOnError(ref.watch(mainAppNotifierProvider).context, onError);
      }
    });
  }
}
