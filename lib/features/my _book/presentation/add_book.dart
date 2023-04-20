import 'dart:io';

import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/core/widget/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/colors/colors.dart';
import '../../../presentation/di/book_component.dart';
import '../../../presentation/views/widgets/text_field.dart';
import '../di/my_book_module.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  late TextEditingController nameController;
  late TextEditingController authorController;
  late TextEditingController languageController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late bool isShowClearIconNameController;
  late bool isShowClearIconAuthorController;
  late bool isShowClearIconLanguageController;
  late bool isShowClearIconCategoryController;
  late bool isShowClearIconDescriptionController;
  late GlobalKey<FormState> _formKey;
  late DecorationImage? decorationImage;
  late String? imagePath;
  late bool isShowLoading;
  List<String> list = <String>['Vietnamese', 'English', 'Other'];
  List<String> categories = <String>['Novel', 'Comic', 'Other'];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    nameController = TextEditingController();
    authorController = TextEditingController();
    languageController = TextEditingController();
    categoryController = TextEditingController();
    descriptionController = TextEditingController();
    isShowClearIconNameController = false;
    isShowClearIconAuthorController = false;
    isShowClearIconLanguageController = false;
    isShowClearIconCategoryController = false;
    isShowClearIconDescriptionController = false;
    decorationImage = null;
    imagePath = null;
    isShowLoading = false;
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(addBookStateNotifierProvider, (previous, next) {
      if (next is UIStateLoading) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UIStateSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: "Add book successfully!"));
        Navigator.pop(context);
      } else if (next is UIStateError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
      }
    });
    return Form(
      key: _formKey,
      child: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isShowLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Create a new book",
                style: S.textStyles.heading3,
              ),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: S.colors.primary_3,
              ),
              backgroundColor: S.colors.white,
              elevation: 0.5,
              actions: [
                IconButton(
                  color: S.colors.primary_3,
                  icon: const Icon(
                    FontAwesomeIcons.barcode,
                  ),
                  onPressed: () {
                    // ref
                    //     .watch(addBookSettingNotifierProvider.notifier)
                    //     .updateImagePath(File(''));
                    // ref
                    //     .watch(addBookSettingNotifierProvider.notifier)
                    //     .scanBarcode(context);
                  },
                ),
              ],
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
                            return "Please enter your book's name";
                          } else if (value.length < 2) {
                            return "Book's name must be at least 1 characters";
                          }
                        }
                        return null;
                      },
                      hintText: "Name",
                      obscureText: false,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.name,
                      suffixIconData: isShowClearIconNameController
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
                          : null,
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
                            return "Please enter book's author!";
                          } else if (value.length < 2) {
                            return "Book's author must be at least 1 characters!";
                          }
                        }
                        return null;
                      },
                      hintText: "Author",
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
                      hintText: "Description (Optional)",
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
                            return "Please enter book's language!";
                          }
                        }
                        return null;
                      },
                      hintText: "Language",
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
                            return "Please enter book's category!";
                          }
                        }
                        return null;
                      },
                      hintText: "Category",
                      obscureText: false,
                      readOnly: true,
                      controller: categoryController,
                      textInputAction: TextInputAction.done,
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
                      height: S.size.length_20Vertical,
                    ),
                    CustomElevatedButton(
                      child: const Center(child: Text("Add book")),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .watch(addBookStateNotifierProvider.notifier)
                              .addBook(
                                  nameController.text,
                                  authorController.text,
                                  descriptionController.text,
                                  languageController.text,
                                  categoryController.text,
                                  imagePath);
                        }
                      },
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
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
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