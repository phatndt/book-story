import 'dart:io';

import 'package:book_story/core/extension/function_extension.dart';
import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/presentation/state/book_detail_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletons/skeletons.dart';
import 'package:path/path.dart' as p;
import '../../../core/colors/colors.dart';
import '../../../core/widget/snack_bar.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  const BookDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  late bool isShowAddFileButtonLoading;
  late bool isShowLoading;
  late Book? book;
  late double percentage;
  late bool isShowDialogProgress;

  @override
  void initState() {
    super.initState();
    book = null;
    isShowLoading = false;
    isShowAddFileButtonLoading = false;
    percentage = 0.0;
    isShowDialogProgress = false;
    Future.delayed(Duration.zero, () {
      ref.watch(getBookDetailStateNotifierProvider.notifier).getBookDetail(
            book.isNull()
                ? ModalRoute.of(context)!.settings.arguments as String
                : book!.id,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getBookDetailStateNotifierProvider, (previous, next) {
      if (next is UISuccessState) {
        setState(() {
          book = next.data;
        });
      } else if (next is UIErrorState) {
        final snackBar = ErrorSnackBar(
          message: next.error.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (next is UpdateReadFileOfBookLoading) {
        setState(() {
          isShowLoading = true;
          percentage = next.percentage;
        });
      } else if (next is UpdateReadFileOfBookSuccess) {
        setState(() {
          isShowLoading = false;
        });
        final snackBar = SuccessSnackBar(
          message: 'upload_read_file_success'.tr(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        ref.watch(getBookDetailStateNotifierProvider.notifier).getBookDetail(
              book.isNull()
                  ? ModalRoute.of(context)!.settings.arguments as String
                  : book!.id,
            );
      }
    });
    return ModalProgressHUD(
      inAsyncCall: isShowLoading,
      progressIndicator: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'uploading'.tr(),
              style: TextStyle(
                color: S.colors.primary_3,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: S.colors.neutral_3,
              valueColor: AlwaysStoppedAnimation<Color>(S.colors.primary_3),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              "${(percentage.toInt().toString())}%",
              style: S.textStyles.paragraph,
            )
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: S.colors.white,
            elevation: 0.2,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: S.colors.primary_3,
            ),
            actions: [
              IconButton(
                tooltip: 'update_read_file_book'.tr(),
                icon: Icon(
                  Icons.edit_note,
                  color: S.colors.primary_3,
                ),
                onPressed: () async {
                  final path = await pickedFile(book!.id);
                  if (path != null) {
                    uploadFile(path, book!.id);
                  }
                },
              )
            ],
          ),
          backgroundColor: S.colors.white,
          body: _bodyUI(),
        ),
      ),
    );
  }

  Future<String?> pickedFile(String bookId) async {
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('permission'.tr()),
              content: Text('permission_storage_denies'.tr()),
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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      } else {
        return null;
      }
    }
    return null;
  }

  void uploadFile(String path, String bookId) {
    if (p.extension(path) != ".pdf") {
      final snackBar = ErrorSnackBar(
        message: 'Exception: ${'book_feature.book.file_format_not_support'.tr()}',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    File file = File(path);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('add_file'.tr()),
            content: Text('you_want_to_link_this_file_to_the_book'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .watch(getBookDetailStateNotifierProvider.notifier)
                      .addReadFileOfBook(bookId, file);
                },
                child: Text('ok'.tr()),
              )
            ],
          );
        });
  }

  Widget _bodyUI() {
    if (book.isNull()) {
      return SkeletonListView();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: CachedNetworkImage(
              width: 140.w,
              height: 200.h,
              fit: BoxFit.fill,
              imageUrl: book!.image,
              placeholder: (context, url) => const SkeletonAvatar(),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 36.w,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            book!.name,
            style: S.textStyles.heading2.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: null,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            book!.author,
            style: S.textStyles.heading3.copyWith(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
          SizedBox(
            height: 16.h,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: BookDetailAttributeWidget(
                    title: 'category'.tr(),
                    value: book!.category,
                  ),
                ),
                const BookDetailDivider(),
                Expanded(
                  child: BookDetailAttributeWidget(
                    title: 'language'.tr(),
                    value: book!.language,
                  ),
                ),
                const BookDetailDivider(),
                Expanded(
                  child: BookDetailAttributeWidget(
                    title: 'release'.tr(),
                    value: book!.releaseDate,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          if (book!.description.isNotEmpty)
            Column(
              children: [
                Text(
                  'description'.tr(),
                  style: S.textStyles.heading3
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(book!.description),
                ),
              ],
            ),
          SizedBox(
            height: 32.h,
          ),
          CustomElevatedButton(
            onPressed: book!.readFile.isNotEmpty
                ? () {
                    Navigator.pushNamed(context, RoutePaths.readBookFile,
                        arguments: book!.id);
                  }
                : () async {
                    final path = await pickedFile(book!.id);
                    if (path != null) {
                      uploadFile(path, book!.id);
                    }
                  },
            child:
                Text(book!.readFile.isNotEmpty ? 'read'.tr() : 'add_file'.tr()),
          )
        ],
      ),
    );
  }
}

class BookDetailAttributeWidget extends StatelessWidget {
  const BookDetailAttributeWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: S.textStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
            color: S.colors.primary_3,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 8.h,
          ),
        ),
        Text(
          value,
          style: S.textStyles.paragraph.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}

class BookDetailDivider extends StatelessWidget {
  const BookDetailDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: VerticalDivider(
        color: Colors.grey,
        width: 12.w,
        thickness: 2,
      ),
    );
  }
}
