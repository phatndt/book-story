import 'dart:developer';
import 'dart:io';
import 'package:book_exchange/domain/entities/post.dart';
import 'package:book_exchange/domain/use_cases/book/get_list_book_by_id_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/get_my_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/upload_image_use_case.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/extension/function_extension.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/use_cases/post/add_post_use_case.dart';
import '../../models/book_app_model.dart';

class AddPostState {
  final TextEditingController content;
  final File image;
  final bool isLoadingAddPost;
  final String selectedBookId;

  AddPostState({
    required this.content,
    required this.image,
    required this.isLoadingAddPost,
    required this.selectedBookId,
  });

  AddPostState copy({
    TextEditingController? content,
    File? image,
    bool? isLoadingAddPost,
    String? selectedBookId,
  }) =>
      AddPostState(
        content: content ?? this.content,
        image: image ?? this.image,
        isLoadingAddPost: isLoadingAddPost ?? this.isLoadingAddPost,
        selectedBookId: selectedBookId ?? this.selectedBookId,
      );
}

class AddPostNotifier extends StateNotifier<AddPostState> {
  AddPostNotifier(
    this.ref,
    this._addPostUseCase,
    this._uploadImageToCloudinaryUseCase,
    this._getListBookUseCase,
    this._getMyPostUseCase,
  ) : super(
          AddPostState(
            content: TextEditingController(),
            image: File(""),
            isLoadingAddPost: false,
            selectedBookId: "",
          ),
        );

  final Ref ref;
  final AddPostUseCase _addPostUseCase;
  final UploadImageToCloudinaryUseCase _uploadImageToCloudinaryUseCase;
  final GetListBookUseCase _getListBookUseCase;
  final GetMyPostUseCase _getMyPostUseCase;

  setIsLoadingAddPost() {
    final newState = state.copy(isLoadingAddPost: !state.isLoadingAddPost);
    state = newState;
  }

  void updateImage(File file) {
    final newState = state.copy(image: file);
    state = newState;
  }

  void updateSelectedBookId(String selectedBookId) {
    final newState = state.copy(selectedBookId: selectedBookId);
    state = newState;
  }

  void uploadPost(context) {
    updateImageToCloud(context);
  }

  void updateImageToCloud(context) {
    setIsLoadingAddPost();
    if (!checkAddPostInput(context)) {
      setIsLoadingAddPost();
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Fill up the blank space",
        ),
        displayDuration: const Duration(seconds: 1),
      );
      return;
    }
    _uploadImageToCloudinaryUseCase
        .uploadImageToSpaces(BookAppModel.user.id + "/post", state.image)
        .then((value) {
      if (value != null) {
        createPost(context, value);
      }
    }).catchError(
      (onError) {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "Error: $onError",
          ),
          displayDuration: const Duration(seconds: 2),
        );
        setIsLoadingAddPost();
      },
    );
  }

  bool checkAddPostInput(context) {
    if (state.content.text.isEmpty || state.image.path.isEmpty || state.selectedBookId.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void createPost(context, uploadedUrl) {
    final post = Post(
      id: "",
      content: state.content.text,
      createDate: DateTime.now().millisecondsSinceEpoch.toString(),
      nLikes: 0,
      nComments: 0,
      userId: BookAppModel.user.id,
      imageUrl: uploadedUrl,
      bookId: state.selectedBookId,
      isDeleted: false,
    );

    _addPostUseCase.createPost(post, BookAppModel.jwtToken).then(
      (value) {
        setIsLoadingAddPost();
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: "Create post successfully",
          ),
          displayDuration: const Duration(seconds: 1),
        );
        Navigator.pop(context);
      },
    ).catchError(
      (onError) {
        setIsLoadingAddPost();
        catchOnError(context, onError);
      },
    );
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
                selectImageSource(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
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
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }

  void selectImageSource(ImageSource imageSource) async {
    // final _picker = ImagePicker();
    // final pickedImage = await _picker.pickImage(source: imageSource);
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) {
      return;
    }
    updateImage(File(pickedImage.path));
  }

  void getListBook(context) async {
    setIsLoadingAddPost();
    _getListBookUseCase.getListBook(BookAppModel.jwtToken).then((value) {
      if (value.data.isNotEmpty) {
        _getMyPostUseCase.getMyPost(BookAppModel.jwtToken).then((post) {
          setIsLoadingAddPost();
          final list = value.data;
          list.removeWhere(
              (e) => post.data.any((element) => element.bookId == e.id));
          // final list = value.data
          //     .takeWhile(
          //       (e) => post.data.any((element) => element.bookId == e.id),
          //     )
          //     .toList();
          if (list.isNotEmpty) {
            selectBook(context, list);
          } else {
            showTopSnackBar(
              context,
              const CustomSnackBar.info(
                message: "You have selected all books to live with your posts!",
              ),
              displayDuration: const Duration(seconds: 1),
            );
          }
        }).catchError((onError) {
          setIsLoadingAddPost();
          catchOnError(context, onError);
        });
      } else {
        setIsLoadingAddPost();
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "You don't have any book",
          ),
          displayDuration: const Duration(seconds: 1),
        );
      }
      // ---
    }).catchError((onError) {
      setIsLoadingAddPost();
      catchOnError(context, onError);
    });
  }

  void selectBook(context, List<Book> books) {
    DropDownState(
      DropDown(
        bottomSheetTitle: const Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: books
            .map((e) => SelectedListItem(
                  name: "$e.name",
                  value: e.id,
                ))
            .toList(),
        selectedItems: (List<dynamic> selectedList) {
          if (selectedList.first is SelectedListItem) {
            log(selectedList.first.value);
            updateSelectedBookId(selectedList.first.value ?? "");
          }
          // showSnackBar(list.toString());
        },
      ),
    ).showModal(context);
  }

}
