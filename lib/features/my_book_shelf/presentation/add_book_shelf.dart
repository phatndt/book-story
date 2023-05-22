import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/colors/colors.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';
import '../di/book_shelf_module.dart';

class AddBookShelfScreen extends ConsumerStatefulWidget {
  const AddBookShelfScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddBookShelfScreenState();
}

class _AddBookShelfScreenState extends ConsumerState<AddBookShelfScreen> {
  late TextEditingController nameController;
  late bool isShowClearIconNameController;
  late Color? pickedColor;
  late bool isShowLoading;
  late int pickerColorIndex;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    isShowClearIconNameController = false;
    pickedColor = S.colors.primary_3;
    isShowLoading = false;
    pickerColorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(addBookShelfNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.data.toString()));
        Navigator.pop(context);
        ref.watch(bookShelfStateNotifierProvider.notifier).getBookShelfList();
      } else if (next is UIErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
      }
    });
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isShowLoading,
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              'create_new_book_shelf'.tr(),
              style: S.textStyles.heading3,
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: S.colors.primary_3,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
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
                        return 'please_enter_your_book_shelf_name'.tr();
                      } else if (value.length < 2) {
                        return 'bookshelf_name_must_be_at_least_one_character'
                            .tr();
                      }
                    }
                    return null;
                  },
                  hintText: 'book_shelf_name'.tr(),
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
                SizedBox(
                  height: 56,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: S.colors.listColorPicker.length,
                    separatorBuilder: (context, index) => SizedBox(
                      width: 8.w,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(28.r),
                        onTap: () {
                          setState(() {
                            pickerColorIndex = index;
                          });
                        },
                        child: Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: S.colors.listColorPicker[index],
                          ),
                          child: pickerColorIndex == index
                              ? Icon(
                                  Icons.check,
                                  color: S.colors.white,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    ref
                        .watch(addBookShelfNotifierProvider.notifier)
                        .addBookShelf(
                            nameController.text.trim(),
                            getHexColor(
                                S.colors.listColorPicker[pickerColorIndex]));
                  },
                  child: Text('create_new_book_shelf'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getHexColor(Color color) {
    return color.toString().split('(0x')[1].split(')')[0];
  }
}
