import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class BookDetailSetting {
  final TextEditingController bookName;
  final TextEditingController bookAuthor;
  final TextEditingController bookDescription;
  double bookRating;
  XFile bookImage;
  final String bookId;

  bool isLoadingBookDetail = false;

  BookDetailSetting({
    required this.bookId,
    required this.bookName,
    required this.bookAuthor,
    required this.bookDescription,
    required this.bookRating,
    required this.bookImage,
    required this.isLoadingBookDetail,
  });

  BookDetailSetting copy({
    TextEditingController? bookName,
    TextEditingController? bookAuthor,
    TextEditingController? bookDescription,
    double? bookRating,
    XFile? bookImage,
    bool? isLoadingBookDetail,
    String? bookId,
  }) =>
      BookDetailSetting(
        bookId: bookId ?? this.bookId,
        bookAuthor: bookAuthor ?? this.bookAuthor,
        bookImage: bookImage ?? this.bookImage,
        bookName: bookName ?? this.bookName,
        bookDescription: bookDescription ?? this.bookDescription,
        bookRating: bookRating ?? this.bookRating,
        isLoadingBookDetail: isLoadingBookDetail ?? this.isLoadingBookDetail,
      );

  //BookDetailSetting copyWith({}) {return BookDetailSetting(emailClear: emailClear, isVisible: isVisible, emailController: emailController, passwordController: passwordController)}
}

class BookDetailSettingNotifier extends StateNotifier<BookDetailSetting> {
  BookDetailSettingNotifier(this.ref)
      : super(
          BookDetailSetting(
            bookId: '',
            bookAuthor: TextEditingController(),
            bookDescription: TextEditingController(),
            bookImage: XFile(''),
            bookName: TextEditingController(),
            bookRating: 0.0,
            isLoadingBookDetail: false,
          ),
        );

  final Ref ref;
  // final BookDetailUseCase _bookDetailUseCase;
  // final DeleteBookUseCase _deleteBookUseCase;

  void setLoadingBookDetail() {
    final newState =
        state.copy(isLoadingBookDetail: !state.isLoadingBookDetail);
    state = newState;
  }

  void clearImage() {
    final newState = state.copy(bookImage: XFile(''));
    state = newState;
  }

  void clearInput() {
    state.bookName.text = "";
    state.bookAuthor.text = "";
    state.bookDescription.text = "";
    state.bookRating = 0.0;
    clearImage();
  }

  // void showImageSourceActionSheet(BuildContext context) {
  //   if (Platform.isIOS) {
  //     showCupertinoModalPopup(
  //       context: context,
  //       builder: (context) => CupertinoActionSheet(
  //         actions: [
  //           CupertinoActionSheetAction(
  //             child: const Text('Camera'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               selectImageSource(ImageSource.camera);
  //             },
  //           ),
  //           CupertinoActionSheetAction(
  //             child: const Text('Gallery'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               selectImageSource(ImageSource.gallery);
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   } else {
  //     showModalBottomSheet(
  //       context: context,
  //       builder: (context) => Wrap(children: [
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Camera'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             selectImageSource(ImageSource.camera);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.photo_album),
  //           title: const Text('Gallery'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             selectImageSource(ImageSource.gallery);
  //           },
  //         ),
  //       ]),
  //     );
  //   }
  // }

  // bool checkBookDetailInput(context) {
  //   if (state.bookName.text.isEmpty ||
  //       state.bookAuthor.text.isEmpty ||
  //       state.bookDescription.text.isEmpty ||
  //       state.bookImage.path.isEmpty) {
  //     showTopSnackBar(
  //       context,
  //       const CustomSnackBar.error(
  //         message: "Fill up the blank space",
  //       ),
  //       displayDuration: const Duration(seconds: 2),
  //     );
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  void updateImagePath(XFile a) {
    final newState = state.copy(bookImage: a);
    state = newState;
  }

  // void selectImageSource(ImageSource imageSource) async {
  //   // final _picker = ImagePicker();
  //   // final pickedImage = await _picker.pickImage(source: imageSource);
  //   final pickedImage = await ImagePicker().pickImage(source: imageSource);

  //   if (pickedImage == null) {
  //     return;
  //   }
  //   updateImagePath(pickedImage);
  // }

}
