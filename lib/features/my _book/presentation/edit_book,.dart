import 'dart:developer';
import 'dart:io';

import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/core/widget/snack_bar.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/presentation/state/edit_book_state.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/colors/colors.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../di/my_book_module.dart';
import 'ocr_scan_screen.dart';

class EditBookScreen extends ConsumerStatefulWidget {
  const EditBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  late TextEditingController nameController;
  late TextEditingController authorController;
  late TextEditingController languageController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController releaseYearController;
  late bool isShowClearIconNameController;
  late bool isShowClearIconAuthorController;
  late bool isShowClearIconLanguageController;
  late bool isShowClearIconCategoryController;
  late bool isShowClearIconDescriptionController;
  late GlobalKey<FormState> _formKey;
  late DecorationImage? decorationImage;
  late String? imagePath;
  late bool isShowLoading;
  List<String> list = <String>[
    'book_languages.en'.tr(),
    'book_languages.vi'.tr(),
    'book_languages.other'.tr(),
  ];
  List<String> categories = <String>[
    'book_categories.adventure'.tr(),
    'book_categories.art'.tr(),
    'book_categories.biography'.tr(),
    'book_categories.business'.tr(),
    'book_categories.comics'.tr(),
    'book_categories.cooking'.tr(),
    'book_categories.crime'.tr(),
    'book_categories.economics'.tr(),
    'book_categories.fantasy'.tr(),
    'book_categories.fiction'.tr(),
    'book_categories.health'.tr(),
    'book_categories.history'.tr(),
    'book_categories.horror'.tr(),
    'book_categories.humor'.tr(),
    'book_categories.kids'.tr(),
    'book_categories.music'.tr(),
    'book_categories.mystery'.tr(),
    'book_categories.nonfiction'.tr(),
    'book_categories.philosophy'.tr(),
    'book_categories.romance'.tr(),
    'book_categories.science'.tr(),
    'book_categories.poetry'.tr(),
    'book_categories.psychology'.tr(),
    'book_categories.self_help'.tr(),
    'book_categories.sports'.tr(),
    'book_categories.thriller'.tr(),
    'book_categories.travel'.tr(),
    'book_categories.religion'.tr(),
    'book_categories.other'.tr(),
  ];
  DateTime selectedDate = DateTime.now();
  late Book? book;
  late List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _init();
    Future.delayed(Duration.zero, () {
      ref
          .watch(editBookStateNotifierProvider.notifier)
          .getBookDetail(ModalRoute.of(context)!.settings.arguments as String);
    });
  }

  _init() async {
    nameController = TextEditingController();
    authorController = TextEditingController();
    languageController = TextEditingController();
    categoryController = TextEditingController();
    descriptionController = TextEditingController();
    releaseYearController = TextEditingController();
    isShowClearIconNameController = false;
    isShowClearIconAuthorController = false;
    isShowClearIconLanguageController = false;
    isShowClearIconCategoryController = false;
    isShowClearIconDescriptionController = false;
    decorationImage = null;
    imagePath = null;
    isShowLoading = false;
    book = null;
    _formKey = GlobalKey<FormState>();
    _cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editBookStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        final book = next.data as Book;
        setState(() {
          decorationImage = DecorationImage(
              image: NetworkImage(book.image), fit: BoxFit.fill);
          imagePath = book.image;
          nameController.text = book.name;
          authorController.text = book.author;
          languageController.text = book.language;
          categoryController.text = book.category;
          descriptionController.text = book.description;
          releaseYearController.text = book.releaseDate;
        });
      } else if (next is UIErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
        Navigator.pop(context);
      } else if (next is UIWarningState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(WarningSnackBar(message: next.message));
      } else if (next is EditBookError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: 'something_wrong'.tr()));
      } else if (next is EditBookSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: 'edit_book_successfully'.tr()));
        Navigator.pop(context);
        ref.watch(myBookStateNotifierProvider.notifier).getBook();
      }
    });
    return Form(
      key: _formKey,
      child: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isShowLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: S.colors.white,
              elevation: 0.5,
              title: Text(
                'edit_book'.tr(),
                style: S.textStyles.heading3,
              ),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: S.colors.primary_3,
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    Center(
                      child: Container(
                        width: ScreenUtil().screenWidth * 0.4,
                        height: ScreenUtil().screenWidth * 0.4,
                        decoration: BoxDecoration(
                          color: S.colors.neutral_1.withAlpha(128),
                          borderRadius: BorderRadius.all(
                            Radius.circular(S.size.length_8),
                          ),
                          image: decorationImage,
                        ),
                        child: TextButton(
                          onPressed: () {
                            showImageSourceActionSheet(context);
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: S.colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconNameController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconNameController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'please_enter_your_book_name'.tr();
                          } else if (value.length < 2) {
                            return 'book_name_at_least_one_character'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'book_name'.tr(),
                      obscureText: false,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.name,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconNameController
                              ? IconButton(
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              nameController.clear();
                              setState(() {
                                isShowClearIconNameController = false;
                              });
                            },
                          )
                              : const SizedBox.shrink(),
                          IconButton(
                            padding: const EdgeInsets.only(),
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              if (_cameras != null) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OcrScanScreen(
                                      cameraDescription: _cameras!,
                                    ),
                                  ),
                                );
                                nameController.text = result;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconAuthorController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconAuthorController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'please_enter_your_book_author'.tr();
                          } else if (value.length < 2) {
                            return 'book_author_at_least_one_character'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'book_author'.tr(),
                      obscureText: false,
                      controller: authorController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      suffixIconData: isShowClearIconAuthorController
                          ? IconButton(
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                authorController.clear();
                                setState(() {
                                  isShowClearIconAuthorController = false;
                                });
                              },
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconDescriptionController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconDescriptionController = false;
                          });
                        }
                      },
                      hintText: 'book_description'.tr(),
                      obscureText: false,
                      maxLength: 1000,
                      maxLines: null,
                      controller: descriptionController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      suffixIconData: isShowClearIconDescriptionController
                          ? IconButton(
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                descriptionController.clear();
                                setState(() {
                                  isShowClearIconDescriptionController = false;
                                });
                              },
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onTap: () {
                        showPickLanguageDialog(context);
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconLanguageController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconLanguageController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'please_enter_book_language'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'book_language'.tr(),
                      obscureText: false,
                      readOnly: true,
                      controller: languageController,
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconLanguageController
                              ? InkWell(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    languageController.clear();
                                    setState(() {
                                      isShowClearIconLanguageController = false;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          IconButton(
                              padding: const EdgeInsets.only(),
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                showPickLanguageDialog(context);
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onTap: () {
                        showPickCategoryDialog(context);
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconCategoryController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconCategoryController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'please_enter_book_category'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'book_category'.tr(),
                      obscureText: false,
                      readOnly: true,
                      controller: categoryController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconCategoryController
                              ? InkWell(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    categoryController.clear();
                                    setState(() {
                                      isShowClearIconCategoryController = false;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          IconButton(
                              padding: const EdgeInsets.only(),
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                showPickCategoryDialog(context);
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onTap: () {
                        showYearPicker(context);
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'please_enter_book_release_year'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'book_release'.tr(),
                      obscureText: false,
                      readOnly: true,
                      controller: releaseYearController,
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      suffixIconData: IconButton(
                          padding: const EdgeInsets.only(),
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            showYearPicker(context);
                          }),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomElevatedButton(
                      child: Center(child: Text('edit_book'.tr())),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .watch(editBookStateNotifierProvider.notifier)
                              .editBook(
                                  nameController.text,
                                  authorController.text,
                                  descriptionController.text,
                                  languageController.text,
                                  releaseYearController.text,
                                  categoryController.text,
                                  imagePath);
                        }
                      },
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showPickLanguageDialog(BuildContext context) {
    final language = Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
              onTap: () {
                languageController.text = list[index];
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => language);
  }

  showPickCategoryDialog(BuildContext context) {
    final category = Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(categories[index]),
              onTap: () {
                categoryController.text = categories[index];
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => category);
  }

  showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('picker_release_year'.tr()),
          content: SizedBox(
            height: 200.h,
            width: 300.w,
            child: YearPicker(
              firstDate: DateTime(1500),
              lastDate: DateTime.now(),
              selectedDate: selectedDate,
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
                releaseYearController.text = value.year.toString();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    ).then((value) {
      if (releaseYearController.text.isEmpty) {
        releaseYearController.text = selectedDate.year.toString();
      }
    });
  }

  void showImageSourceActionSheet(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('camera'.tr()),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(context, ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('gallery'.tr()),
              onPressed: () {
                Navigator.pop(context);
                selectImageSourceFromGallery(context);
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
            title: Text('camera_edge_detector'.tr()),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(context, null);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('camera'.tr()),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: Text('gallery'.tr()),
            onTap: () {
              Navigator.pop(context);
              selectImageSourceFromGallery(context);
            },
          ),
        ]),
      );
    }
  }

  void selectImageSource(BuildContext context, ImageSource? imageSource) async {
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
          return;
        }
        setState(() {
          decorationImage = DecorationImage(
              image: FileImage(File(pickedImage.path)), fit: BoxFit.fill);
          imagePath = pickedImage.path;
        });
      } else {
        String imagePath = path.join((await getApplicationSupportDirectory()).path,
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
            setState(() {
              decorationImage = DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.fill,
              );
              this.imagePath = imagePath;
            });
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }

  void selectImageSourceFromGallery(BuildContext context) async {
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
                    child: Text('oke'.tr()))
              ],
            );
          });
    } else if (status.isGranted) {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return;
      }
      setState(() {
        decorationImage = DecorationImage(
            image: FileImage(File(pickedImage.path)), fit: BoxFit.fill);
        imagePath = pickedImage.path;
      });
    }
  }
}
