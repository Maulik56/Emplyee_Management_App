import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/color_const.dart';
import '../constant/strings_const.dart';
import 'common_text.dart';
import 'package:get/get.dart';

import 'connectivity_checker.dart';

class CommonWidget {
  static SizedBox commonSizedBox({double? height, double? width}) {
    return SizedBox(height: height, width: width);
  }

  static bool validate = false;
  static Widget textFormField(
      {String? hintText,
      List<TextInputFormatter>? inputFormatter,
      required TextEditingController controller,
      int? maxLength,
      int? maxLine = 1,
      TextInputType? keyBoardType,
      bool isObscured = false,
      bool readOnly = false,
      void Function(String)? onChanged,
      String? Function(String?)? validator,
      TextCapitalization textCapitalization = TextCapitalization.none,
      void Function()? onTap,
      Widget? prefix,
      Widget? suffix,
      AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction,
      String? errorText}) {
    return TextFormField(
      onTap: onTap,
      textCapitalization: textCapitalization,
      validator: validator,
      autovalidateMode: autoValidateMode,
      obscureText: isObscured,
      readOnly: readOnly,
      inputFormatters: inputFormatter,
      maxLength: maxLength,
      maxLines: maxLine,
      controller: controller,
      keyboardType: keyBoardType,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      cursorColor: Colors.black,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        errorText: errorText,
        labelText: hintText,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  static Widget textFormFieldWithUnderline(
      {String? hintText,
      List<TextInputFormatter>? inputFormatter,
      required TextEditingController controller,
      int? maxLength,
      int? maxLine = 1,
      TextInputType? keyBoardType,
      bool isObscured = false,
      bool readOnly = false,
      void Function(String)? onChanged,
      String? Function(String?)? validator,
      TextCapitalization textCapitalization = TextCapitalization.none,
      Widget? prefix,
      Widget? suffix,
      dynamic keyboardType,
      dynamic inputFormatters}) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyBoardType,
      inputFormatters: inputFormatter,
      textCapitalization: textCapitalization,
      style: const TextStyle(
          color: Color(0xff707070), fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffafafaf), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffafafaf), width: 2),
        ),
        labelText: hintText,
        labelStyle: const TextStyle(
            color: Color(0xff828282), fontWeight: FontWeight.w500),
      ),
    );
  }

  static commonButton(
      {required VoidCallback onTap,
      required String text,
      Color color = const Color(0xff02d435),
      Color textColor = Colors.white,
      bool isLoading = false,
      bool needBorder = false,
      Color? borderColor}) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 3,
        side: BorderSide(color: needBorder ? borderColor! : Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLoading ? 7.sp : 15.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : CommonText.textBoldWeight500(
                    text: text, color: textColor, fontSize: 14.sp)
          ],
        ),
      ),
    );
  }

  static commonSmallButton(
      {required VoidCallback onTap,
      required String text,
      Color textColor = Colors.red,
      Color buttonColor = Colors.red}) {
    return SizedBox(
      width: 100.sp,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: buttonColor,
            ),
          ),
          height: 50,
          child: Center(
            child: CommonText.textBoldWeight600(
                text: text, color: textColor, fontSize: 14),
          ),
        ),
      ),
    );
  }

  static cancelButton({required VoidCallback onTap, required String text}) {
    return SizedBox(
      width: 100.sp,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: CommonColor.themColor309D9D,
              )),
          height: 50,
          child: Center(
            child: CommonText.textBoldWeight600(
                text: text, color: CommonColor.themColor309D9D, fontSize: 14),
          ),
        ),
      ),
    );
  }

  static getSnackBar(BuildContext context,
      {required String message,
      Color color = CommonColor.themColor309D9D,
      Color colorText = Colors.white,
      int duration = 1}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              CommonText.textBoldWeight500(text: message, color: colorText),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static AppBar commonAppBar(
      {required String title,
      PreferredSize? bottomWidget,
      Widget? leading,
      double? leadingWidth = 56,
      List<Widget>? actions}) {
    return AppBar(
      leading: leading,
      centerTitle: true,
      leadingWidth: leadingWidth,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: CupertinoColors.systemGrey5,
      title: CommonText.textBoldWeight500(
          fontSize: 16.sp, text: title, color: Colors.black),
      elevation: 0,
      actions: actions,
      bottom: bottomWidget,
    );
  }
}

class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;

  const ShowDialogToDismiss(
      {Key? key,
      required this.title,
      required this.buttonText,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              buttonText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              buttonText[0].toUpperCase() +
                  buttonText.substring(1).toLowerCase(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  }
}

const noConnectionSnackBar = SnackBar(
  content: Text(
    'Unable to connect to server.. please check your internet connection.',
    textAlign: TextAlign.center,
  ),
  backgroundColor: Colors.red,
);

class NoInternetWidget extends StatelessWidget {
  final void Function() onPressed;
  const NoInternetWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText.textBoldWeight700(
              text: "Something went wrong.", fontSize: 22.sp),
          SizedBox(
            height: 17.sp,
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              side: BorderSide(color: CommonColor.lightGrayColor300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(13.sp),
              child: CommonText.textBoldWeight600(
                  text: "Try Again.", fontSize: 15.sp, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

class AdaptiveDialogBox extends StatelessWidget {
  final String message;

  const AdaptiveDialogBox({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.ok))
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              AppStrings.ok,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  }
}
