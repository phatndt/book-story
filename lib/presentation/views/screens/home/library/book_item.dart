import 'package:flutter/material.dart';

import '../../../../../core/colors/colors.dart';

class BookItem extends StatelessWidget {
  const BookItem({
    Key? key,
    required this.onTap,
    required this.imageURL,
    required this.name,
  }) : super(key: key);
  final VoidCallback onTap;
  final String name;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Material(
              // color: Colors.amber,
              shadowColor: S.colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  S.size.length_8,
                ),
              ),
              elevation: 3,
              child: Container(
                width: S.size.length_120,
                height: S.size.length_170Vertical,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: S.colors.grey,
                    width: 0.2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      S.size.length_8,
                    ),
                  ),
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: S.size.length_8),
            //   child: Text(
            //     name,
            //     style: S.textStyles.collection.smallTitle,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
