import 'dart:io';

import 'package:book_exchange/core/core.dart';
import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/domain/use_cases/book/upload_book_use_case.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/get_contribution_book_by_isbn_barcode_use_case.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/get_contribution_book_by_normal_barcode_use_case.dart';
import 'package:book_exchange/domain/use_cases/upload_image_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../core/colors/colors.dart';
import '../../core/extension/function_extension.dart';
import '../../domain/entities/book.dart';
import '../di/book_component.dart';
import '../models/book_app_model.dart';
import 'collection_viewmodels.dart';

class AddBookSetting {
  final TextEditingController bookName;
  final TextEditingController bookAuthor;
  final TextEditingController bookDescription;

  String bookBarcode;
  double bookRating;
  File bookImage;
  String barcodeImage;
  DecorationImage? decorationImage;
  Icon icon;

  bool isLoadingAddBook = false;

  AddBookSetting({
    required this.bookName,
    required this.bookAuthor,
    required this.bookDescription,
    required this.bookRating,
    required this.bookImage,
    required this.bookBarcode,
    required this.isLoadingAddBook,
    required this.barcodeImage,
    required this.decorationImage,
    required this.icon,
  });

  AddBookSetting copy({
    TextEditingController? bookName,
    TextEditingController? bookAuthor,
    TextEditingController? bookDescription,
    String? bookBarcode,
    double? bookRating,
    File? bookImage,
    bool? isLoadingAddBook,
    String? barcodeImage,
    DecorationImage? decorationImage,
    Icon? icon,
  }) =>
      AddBookSetting(
        bookAuthor: bookAuthor ?? this.bookAuthor,
        bookImage: bookImage ?? this.bookImage,
        bookName: bookName ?? this.bookName,
        bookDescription: bookDescription ?? this.bookDescription,
        bookBarcode: bookBarcode ?? this.bookBarcode,
        bookRating: bookRating ?? this.bookRating,
        isLoadingAddBook: isLoadingAddBook ?? this.isLoadingAddBook,
        barcodeImage: barcodeImage ?? this.barcodeImage,
        decorationImage: decorationImage ?? this.decorationImage,
        icon: icon ?? this.icon,
      );
}

class AddBookSettingNotifier extends StateNotifier<AddBookSetting> {
  AddBookSettingNotifier(
    this.ref,
    this._uploadImageToCloudinaryUseCase,
    this._uploadBookUseCase,
    this._getContributionBookByISBNBarcodeUseCase,
    this._getContributionBookByNormalBarcodeUseCase,
  ) : super(
          AddBookSetting(
            bookAuthor: TextEditingController(),
            bookDescription: TextEditingController(),
            bookBarcode: '',
            bookImage: File(''),
            bookName: TextEditingController(),
            bookRating: 0.0,
            isLoadingAddBook: false,
            barcodeImage: "",
            decorationImage: null,
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 40,
              color: S.colors.grey,
            ),
          ),
        );

  final Ref ref;
  final UploadImageToCloudinaryUseCase _uploadImageToCloudinaryUseCase;
  final UploadBookUseCase _uploadBookUseCase;
  final GetContributionBookByISBNBarcodeUseCase
      _getContributionBookByISBNBarcodeUseCase;
  final GetContributionBookByNormalBarcodeUseCase
      _getContributionBookByNormalBarcodeUseCase;

  void setLoadingAddBook() {
    final newState = state.copy(isLoadingAddBook: !state.isLoadingAddBook);
    state = newState;
  }

  void clearImage() {
    final newState = state.copy(bookImage: File(''));
    state = newState;
  }

  void updateImagePath(File a) {
    final newState = state.copy(
      bookImage: a,
      barcodeImage: "",
    );
    state = newState;
  }

  void updateBarcodeImage(String barcodeImage) {
    final newState = state.copy(
      barcodeImage: barcodeImage,
      bookImage: File(""),
    );
    state = newState;
  }

  void updateDecorationImage(
    DecorationImage? decorationImage,
    String? name,
    String? author,
    String? description,
  ) {
    final newState = state.copy(
      decorationImage: decorationImage,
      bookName: TextEditingController(text: name),
      bookAuthor: TextEditingController(text: author),
      bookDescription: TextEditingController(text: description),
    );
    state = newState;
    if (decorationImage != null) {
      updateIcon(const Icon(
        FontAwesomeIcons.plus,
        color: Colors.transparent,
      ));
    }
  }

  void updateIcon(Icon icon) {
    final newState = state.copy(icon: icon);
    state = newState;
  }

  void clearInput() {
    state.bookName.text = "";
    state.bookAuthor.text = "";
    state.bookDescription.text = "";
    state.bookRating = 0.0;
    state.bookBarcode = "";
    clearImage();
  }

  void scanBarcode(context) async {
    setLoadingAddBook();
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes.startsWith("978") ||
          barcodeScanRes.startsWith("979")) {
        setLoadingAddBook();
        getContributionBookByIsbnBarcode(barcodeScanRes, context);
      } else {
        setLoadingAddBook();
        getContributionBookByNormalBarcode(barcodeScanRes, context);
      }
    } on PlatformException {
      // return barcodeScanRes = 'Failed to get platform version.';
      setLoadingAddBook();
    }
  }

  void getContributionBookByIsbnBarcode(String barcode, BuildContext context) {
    setLoadingAddBook();
    _getContributionBookByISBNBarcodeUseCase
        .getContributionBookByISBNBarcode(barcode, BookAppModel.jwtToken)
        .then((value) {
      updateBarcodeImage(value.data.imageUrl);
      updateDecorationImage(
        DecorationImage(
          image: NetworkImage(value.data.imageUrl),
          fit: BoxFit.fill,
        ),
        value.data.name,
        value.data.author,
        value.data.description,
      );
      setLoadingAddBook();
    }).catchError((onError) {
      catchOnError(context, onError);
      setLoadingAddBook();
    });
  }

  void getContributionBookByNormalBarcode(
      String barcode, BuildContext context) {
    setLoadingAddBook();
    _getContributionBookByNormalBarcodeUseCase
        .getContributionBookByNormalBarcode(barcode, BookAppModel.jwtToken)
        .then((value) {
      updateBarcodeImage(value.data.imageUrl);
      updateDecorationImage(
        DecorationImage(
          image: NetworkImage(value.data.imageUrl),
          fit: BoxFit.fill,
        ),
        value.data.name,
        value.data.author,
        value.data.description,
      );
      setLoadingAddBook();
    }).catchError((onError) {
      catchOnError(context, onError);
      setLoadingAddBook();
    });
  }

  bool checkAddBookInput(context) {
    if (state.bookName.text.isEmpty ||
        state.bookAuthor.text.isEmpty ||
        state.bookDescription.text.isEmpty ||
        state.bookImage.path.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Fill up the blank space",
        ),
        displayDuration: const Duration(seconds: 2),
      );
      return false;
    } else {
      return true;
    }
  }

  void selectImageSource(ImageSource imageSource) async {
    // final _picker = ImagePicker();
    // final pickedImage = await _picker.pickImage(source: imageSource);
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) {
      return;
    }
    updateImagePath(File(pickedImage.path));
    updateDecorationImage(
        DecorationImage(
          image: FileImage(File(pickedImage.path)),
          fit: BoxFit.fill,
        ),
        null,
        null,
        null);
  }

  void uploadBookToDB(context, String imageURL) async {
    await _uploadBookUseCase
        .uploadBook(
            Book(
              id: '',
              name: state.bookName.text,
              author: state.bookAuthor.text,
              description: state.bookDescription.text,
              rate: state.bookRating,
              imageURL: imageURL,
              userId: getUserIdFromToken(BookAppModel.jwtToken),
              delete: false,
            ),
            BookAppModel.jwtToken)
        .then(
      (value) {
        Navigator.pushNamed(
          context,
          RoutePaths.main,
        );
        ref.refresh(getListBookProvider(ref.watch(getListBookUseCaseProvider)));
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
          ),
          displayDuration: const Duration(seconds: 2),
        );
        clearInput();
        setLoadingAddBook();
      },
    ).catchError((onError) {
      setLoadingAddBook();
      catchOnError(context, onError);
    });
  }

  void uploadBook(context) {
    if (state.bookImage.path.isEmpty && state.barcodeImage.isNotEmpty) {
      uploadBookToDB(context, state.barcodeImage);
    }
    if (state.bookImage.path.isNotEmpty && state.barcodeImage.isEmpty) {
      updateImageToCloud(context);
    }
  }

  void updateImageToCloud(context) {
    setLoadingAddBook();
    if (!checkAddBookInput(context)) {
      setLoadingAddBook();
      return;
    }
    _uploadImageToCloudinaryUseCase
        .uploadImageToSpaces(BookAppModel.user.id + "/book", state.bookImage)
        .then((value) {
      if (value != null) {
        uploadBookToDB(context, value);
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
        setLoadingAddBook();
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
}
