import 'package:flutter/material.dart';

class CommonText {
  static textBoldWeight400(
      {required String text,
      double? fontSize,
      Color? color,
      TextAlign? textAlign,
      FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      text,
      maxLines: 2,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static Widget textBoldWeight500(
      {required String text,
      double? fontSize,
      Color? color,
      height = 0.0,
      TextDecoration textDecoration = TextDecoration.none,
      FontWeight fontWeight = FontWeight.w500}) {
    return Text(
      text,
      style: TextStyle(
        height: height,
        fontWeight: fontWeight,
        decoration: textDecoration,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static Widget textBoldWeight600(
      {required String text,
      double? fontSize,
      Color? color,
      FontWeight fontWeight = FontWeight.w600}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static textBoldWeight700(
      {required String text,
      double? fontSize,
      Color? color,
      TextDecoration textDecoration = TextDecoration.none}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        decoration: textDecoration,
        color: color,
      ),
    );
  }
}
