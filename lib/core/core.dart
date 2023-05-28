import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';

void showImageSourceActionSheet(BuildContext context, VoidCallback onCameraTap,
    VoidCallback onGalleryTap) {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () async {
              Navigator.pop(context);
              onCameraTap();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          )
        ],
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              onCameraTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          ),
        ],
      ),
    );
  }
}

Future<String?> selectImageSource(ImageSource imageSource) async {
  final pickedImage = await ImagePicker().pickImage(source: imageSource);
  if (pickedImage == null) {
    return null;
  }
  return pickedImage.path;
}
