import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void pickedFile(BuildContext context, String bookId) async {
  var status = await Permission.storage.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission"),
            content: const Text(
                "Permission is denied! Please allow permission to access storage"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  } else if (status.isGranted) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Add file"),
              content: const Text("You want to link this file to the book"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // ref
                      // .watch(getBookDetailStateNotifierProvider.notifier)
                      // .addReadFileOfBook(bookId, file);
                    },
                    child: const Text("Ok"))
              ],
            );
          });
    }
  }
}
