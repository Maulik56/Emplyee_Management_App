import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/color_const.dart';
import 'common_text.dart';

class DescriptionWidget extends StatelessWidget {
  final String description;
  const DescriptionWidget({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 10.sp, right: 10.sp, top: 25.sp, bottom: 25.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.textBoldWeight400(
              text: description,
              textAlign: TextAlign.center,
              color: CommonColor.greyColor838589,
              fontSize: 13.sp),
        ],
      ),
    );
  }
}
