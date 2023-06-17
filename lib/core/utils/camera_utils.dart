import 'dart:developer';
import 'dart:io';

import 'package:book_story/core/extension/function_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraUtils {
  static void showImageSourceBottomSheet({
    required BuildContext context,
    required VoidCallback onCameraPicker,
    required VoidCallback onGalleryPicker,
    required VoidCallback onEdgeDetector,
    bool isShowEdgeDetector = false,
  }) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: onCameraPicker,
              child: Text('camera'.tr()),
            ),
            CupertinoActionSheetAction(
              onPressed: onGalleryPicker,
              child: Text('gallery'.tr()),
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
            title: Text('camera_edge_detector'.tr()),
            onTap: onEdgeDetector,
          ).isShow(isShowEdgeDetector),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('camera'.tr()),
            onTap: onCameraPicker,
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: Text('gallery'.tr()),
            onTap: onGalleryPicker,
          ),
        ]),
      );
    }
  }

  static Future<String?> selectImageFromCamera(BuildContext context, ImageSource? imageSource) async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('permission'.tr()),
              content: Text('permission_camera_denies'.tr()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel'.tr())),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                    child: Text('ok'.tr()))
              ],
            );
          });
    } else if (status.isGranted) {
      if (imageSource != null) {
        final pickedImage = await ImagePicker().pickImage(source: imageSource);
        if (pickedImage == null) {
          return null;
        }
      } else {
        String imagePath = join((await getApplicationSupportDirectory()).path,
            "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
        try {
          bool success = await EdgeDetection.detectEdge(
            imagePath,
            canUseGallery: true,
            androidScanTitle: 'scanning'.tr(),
            androidCropTitle: 'crop'.tr(),
            androidCropReset: 'reset'.tr(),
          );
          if (success) {
            return imagePath;
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
    return null;
  }
}
