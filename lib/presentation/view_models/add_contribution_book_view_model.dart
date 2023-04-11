import 'dart:developer';

import 'package:book_exchange/domain/entities/book_contribution.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/upload_contribution_book_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/extension/function_extension.dart';
import '../../core/route_paths.dart';
import '../models/book_app_model.dart';

class AddContributionBookSetting {
  final ContributionBook contributionBook;
  bool isLoadingContributionBook = false;
  final TextEditingController normalBarcode;
  final TextEditingController isbnBarcode;
  AddContributionBookSetting({
    required this.contributionBook,
    required this.isLoadingContributionBook,
    required this.isbnBarcode,
    required this.normalBarcode,
  });

  AddContributionBookSetting copy({
    ContributionBook? contributionBook,
    bool? isLoadingContributionBook,
    TextEditingController? normalBarcode,
    TextEditingController? isbnBarcode,
  }) =>
      AddContributionBookSetting(
        isbnBarcode: isbnBarcode ?? this.isbnBarcode,
        normalBarcode: normalBarcode ?? this.normalBarcode,
        contributionBook: contributionBook ?? this.contributionBook,
        isLoadingContributionBook:
            isLoadingContributionBook ?? this.isLoadingContributionBook,
      );
}

class AddContributionBookSettingNotifier
    extends StateNotifier<AddContributionBookSetting> {
  AddContributionBookSettingNotifier(
      this.ref, this._uploadContributionBookUseCase)
      : super(
          AddContributionBookSetting(
            isbnBarcode: TextEditingController(),
            normalBarcode: TextEditingController(),
            isLoadingContributionBook: false,
            contributionBook: ContributionBook(
              id: '',
              name: '',
              author: '',
              description: '',
              imageUrl: '',
              delete: false,
              verified: false,
              normalBarcode: '',
              isbnBarcode: '',
            ),
          ),
        );

  final Ref ref;
  final UploadContributionBookUseCase _uploadContributionBookUseCase;

  void setLoadingContributiontBook() {
    final newState =
        state.copy(isLoadingContributionBook: !state.isLoadingContributionBook);
    state = newState;
  }

  void updateNormalBarcode(String code) {
    final newState =
        state.copy(normalBarcode: TextEditingController(text: code));
    state = newState;
  }

  void updateIsbnBarcode(String code) {
    final newState = state.copy(isbnBarcode: TextEditingController(text: code));
    state = newState;
  }

  void clearInput() {
    state.isbnBarcode.text = '';
    state.normalBarcode.text = '';
  }

  void scanIsbnBarcode(BuildContext context) async {
    setLoadingContributiontBook();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes.startsWith("978") ||
          barcodeScanRes.startsWith("979")) {
        updateIsbnBarcode(barcodeScanRes);
      } else {
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "Please scan correct format",
          ),
          displayDuration: const Duration(seconds: 2),
        );
        setLoadingContributiontBook();
      }
    } on PlatformException {
      log("Failed to get platform version.");
      setLoadingContributiontBook();
      // return barcodeScanRes = 'Failed to get platform version.';
    }
  }

  void scanNormalBarcode(BuildContext context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    setLoadingContributiontBook();
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes.startsWith("893")) {
        updateNormalBarcode(barcodeScanRes);
      } else {
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "Please scan correct format",
          ),
          displayDuration: const Duration(seconds: 2),
        );
        setLoadingContributiontBook();
      }
    } on PlatformException {
      log("Failed to get platform version.");
      setLoadingContributiontBook();
      // return barcodeScanRes = 'Failed to get platform version.';
    }
  }

  bool checkInput(context) {
    if (state.isbnBarcode.text.isEmpty || state.normalBarcode.text.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Fill out all the Barcodes",
        ),
        displayDuration: const Duration(seconds: 2),
      );
      return false;
    } else {
      return true;
    }
  }

  void contributeBook(context, ContributionBook contributionBook) async {
    setLoadingContributiontBook();
    await _uploadContributionBookUseCase
        .uploadContributionBook(contributionBook, BookAppModel.jwtToken)
        .then(
      (value) {
        Navigator.pushNamed(
          context,
          RoutePaths.main,
        );
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: value.message,
          ),
          displayDuration: const Duration(seconds: 2),
        );
        clearInput();
        setLoadingContributiontBook();
      },
    ).catchError((onError) {
      catchOnError(context, onError);
      setLoadingContributiontBook();
    });
  }
}
