import 'dart:io';

import 'package:book_exchange/domain/use_cases/post/update_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/upload_image_use_case.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
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
import '../../../domain/entities/post.dart';
import '../../../domain/use_cases/book/get_list_book_by_id_use_case.dart';
import '../../../domain/use_cases/post/get_my_post_use_case.dart';
import '../../models/book_app_model.dart';

class EditPostState {
  TextEditingController content;
  File image;
  bool isLoadingEditPost;
  String selectedBookId;
  String imagePath;
  Post post;
  final bool isEnableButton;

  EditPostState({
    required this.content,
    required this.image,
    required this.isLoadingEditPost,
    required this.selectedBookId,
    required this.imagePath,
    required this.post,
    this.isEnableButton = false,
  });

  EditPostState copy({
    TextEditingController? content,
    File? image,
    bool? isLoadingEditPost,
    String? selectedBookId,
    String? imagePath,
    Post? post,
    bool? isEnableButton,
  }) =>
      EditPostState(
        content: content ?? this.content,
        image: image ?? this.image,
        isLoadingEditPost: isLoadingEditPost ?? this.isLoadingEditPost,
        selectedBookId: selectedBookId ?? this.selectedBookId,
        imagePath: imagePath ?? this.imagePath,
        post: post ?? this.post,
        isEnableButton: isEnableButton ?? this.isEnableButton,
      );
}

class EditPostStateNotifier extends StateNotifier<EditPostState> {
  EditPostStateNotifier(
    this.ref,
    this._updatePostUseCase,
    this._uploadImageToCloudinaryUseCase,
    this._getListBookUseCase,
    this._getMyPostUseCase,
  ) : super(
          EditPostState(
            content: TextEditingController(),
            image: File(""),
            isLoadingEditPost: false,
            selectedBookId: "",
            imagePath: "",
            post: Post(
              id: "",
              content: "",
              createDate: "",
              nLikes: 0,
              nComments: 0,
              userId: "",
              imageUrl: "",
              bookId: "",
              isDeleted: false,
            ),
          ),
        );

  Ref ref;
  final UpdatePostUseCase _updatePostUseCase;
  final UploadImageToCloudinaryUseCase _uploadImageToCloudinaryUseCase;
  final GetListBookUseCase _getListBookUseCase;
  final GetMyPostUseCase _getMyPostUseCase;

  void updateState(
      String text, String selectedBookId, String imagePath, Post post) {
    final newState = state.copy(
      content: TextEditingController(text: text),
      selectedBookId: selectedBookId,
      imagePath: imagePath,
      post: post,
    );
    state = newState;
  }

  void updateImage(File file) {
    final newState = state.copy(image: file, imagePath: "");
    state = newState;
    isEnableUpdateButton();
  }

  void updateSelectedBookId(String selectedBookId) {
    final newState = state.copy(selectedBookId: selectedBookId);
    state = newState;
    isEnableUpdateButton();
  }

  void updateImagePath(String file) {
    final newState = state.copy(imagePath: "");
    state = newState;
  }

  void updateLoading() {
    final newState = state.copy(isLoadingEditPost: !state.isLoadingEditPost);
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
    updateLoading();
    _getListBookUseCase.getListBook(BookAppModel.jwtToken).then((value) {
      if (value.data.isNotEmpty) {
        _getMyPostUseCase.getMyPost(BookAppModel.jwtToken).then((post) {
          updateLoading();
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
          updateLoading();
          catchOnError(context, onError);
        });
      } else {
        updateLoading();
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
      updateLoading();
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
            updateSelectedBookId(selectedList.first.value ?? "");
          }
          // showSnackBar(list.toString());
        },
      ),
    ).showModal(context);
  }

  bool checkInput(context) {
    if (state.content.text.isEmpty || state.selectedBookId.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void receiveEventEditPost(context) {
    updateLoading();
    if (checkInput(context)) {
      checkImage(context);
    } else {
      updateLoading();
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Fill up the blank space",
        ),
        displayDuration: const Duration(seconds: 1),
      );
    }
  }

  void checkImage(context) {
    if (state.imagePath.isEmpty) {
      updateImageToCloud(context);
    } else {
      editPost(context);
    }
  }

  void editPost(context) {
    final post = Post(
      id: state.post.id,
      content: state.content.text,
      createDate: state.post.createDate,
      nLikes: state.post.nLikes,
      nComments: state.post.nComments,
      userId: state.post.userId,
      imageUrl: state.post.imageUrl,
      bookId: state.selectedBookId,
      isDeleted: state.post.isDeleted,
    );
    _updatePostUseCase.updatePost(post, BookAppModel.jwtToken).then(
      (value) {
        updateLoading();
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: "Edit post successfully",
          ),
          displayDuration: const Duration(seconds: 1),
        );
        Navigator.pop(context);
        ref.refresh(getMyPostFutureProvider(ref.watch(getMyPostUseCase)));
      },
    ).catchError(
      (onError) {
        updateLoading();
        catchOnError(context, onError);
      },
    );
  }

  void editPostIncludeImage(context, uploadedUrl) {
    final post = Post(
      id: state.post.id,
      content: state.content.text,
      createDate: state.post.createDate,
      nLikes: state.post.nLikes,
      nComments: state.post.nComments,
      userId: state.post.userId,
      imageUrl: uploadedUrl,
      bookId: state.selectedBookId,
      isDeleted: state.post.isDeleted,
    );

    _updatePostUseCase.updatePost(post, BookAppModel.jwtToken).then(
      (value) {
        updateLoading();
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: "Edit post successfully",
          ),
          displayDuration: const Duration(seconds: 1),
        );
        Navigator.pop(context);
        ref.refresh(getMyPostFutureProvider(ref.watch(getMyPostUseCase)));
      },
    ).catchError(
      (onError) {
        updateLoading();
        catchOnError(context, onError);
      },
    );
  }

  void updateImageToCloud(context) {
    updateLoading();
    _uploadImageToCloudinaryUseCase
        .uploadImageToSpaces(BookAppModel.user.id + "/post", state.image)
        .then((value) {
      if (value != null) {
        editPostIncludeImage(context, value);
      }
    }).catchError(
      (onError) {
        updateLoading();
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "Error: $onError",
          ),
          displayDuration: const Duration(seconds: 2),
        );
      },
    );
  }

  void isEnableUpdateButton() {
    if (state.content.text != state.post.content ||
        state.image.path.isNotEmpty ||
        state.selectedBookId != state.post.bookId) {
      final newState = state.copy(isEnableButton: true);
      state = newState;
    } else {
      final newState = state.copy(isEnableButton: false);
      state = newState;
    }
  }
}
