import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/components/description_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/contact_us_repo.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../constant/routes_const.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final NavigationService _navigationService = NavigationService();

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  final messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f4),
            appBar: CommonWidget.commonAppBar(
              title: "Contact Us",
              leading: InkResponse(
                onTap: () {
                  _navigationService.pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
            body: Column(
              children: [
                DescriptionWidget(
                    description:
                        "Enter your message below and then click the send button"),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLines: 20,
                        controller: messageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the message';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Write your message here",
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonWidget.commonButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              progress!.show();

                              var response = await ContactUsRepo.sendMessage(
                                  message: messageController.text);

                              if (response['success'] == true) {
                                progress.dismiss();
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: Text(response['data']['message']),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: const Text(
                                          AppStrings.ok,
                                        ),
                                        onPressed: () {
                                          _navigationService.pop();
                                          _navigationService.pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                progress.dismiss();
                                CommonWidget.getSnackBar(context,
                                    color: CommonColor.red,
                                    duration: 2,
                                    message: "Something went wrong");
                              }
                            } else {
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 1,
                                  message: "Please enter the message");
                            }
                          },
                          text: "Send Message"),
                    ],
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: SafeArea(
            //   child:
            // ),
          );
        },
      ),
    );
  }
}
