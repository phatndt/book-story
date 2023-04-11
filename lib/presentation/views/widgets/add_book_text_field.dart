import 'package:flutter/material.dart';

import '../../../../../core/colors/colors.dart';

class AddBookTextField extends StatelessWidget {
  const AddBookTextField({
    Key? key,
    // required this.width,
    required this.text,
    required this.textEditingController,
  }) : super(key: key);

  // final double width;
  final String text;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: S.size.length_8,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: textEditingController,
          style: S.textStyles.addBookTextfield,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: S.textStyles.addBookTextfield,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.white,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.white,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.orange,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
