import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';
import '../models/response_model/banner_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_banner_view_model.dart';
import 'common_text.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({Key? key}) : super(key: key);

  final NavigationService _navigationService = NavigationService();

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetBannerViewModel>(
      builder: (controller) {
        if (controller.getBannerResponse.status == Status.LOADING) {
          return const SizedBox();
        }
        if (controller.getBannerResponse.status == Status.COMPLETE) {
          BannerResponseModel data = controller.getBannerResponse.data;

          final bannerResponseModel = data.data!;
          if (bannerResponseModel.visible == true) {
            return Container(
              height: 50.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: bannerResponseModel.background != null
                      ? Color(int.parse(
                          "0xff${bannerResponseModel.background!.replaceAll("#", "").removeAllWhitespace}"))
                      : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                        color: CommonColor.lightGrayColor300,
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(2, 2))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Row(
                  children: [
                    CachedNetworkImage(
                        fadeInDuration: Duration.zero,
                        errorWidget: (context, url, error) =>
                            SizedBox(height: 25.sp, width: 25.sp),
                        imageUrl: AppImages.appImagePrefix +
                            bannerResponseModel.imageId!,
                        height: 25.sp,
                        width: 25.sp),
                    SizedBox(
                      width: 10.sp,
                    ),
                    CommonText.textBoldWeight400(
                        text: bannerResponseModel.text ?? "No data found",
                        color: bannerResponseModel.fontColor != null
                            ? Color(int.parse(
                                "0xff${bannerResponseModel.fontColor!.replaceAll("#", "").removeAllWhitespace}"))
                            : Colors.black,
                        fontSize: 13.sp),
                    const Spacer(),

                    /// Unlock Button:
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: CommonColor.blue,
                          ),
                        ),
                        onPressed: () {
                          if (bannerResponseModel.button!.action ==
                              "SUBSCRIBE") {
                            _navigationService.navigateTo(
                                AppRoutes.subscriptionScreen,
                                arguments: {'isFromDrawer': false});
                          } else if (bannerResponseModel.button!.action ==
                              "OPEN_URL") {
                            _launchInBrowser(Uri.parse(
                                bannerResponseModel.button?.url ?? ""));
                          }
                        },
                        child: Center(
                          child: CommonText.textBoldWeight400(
                            color: CommonColor.blue,
                            text: bannerResponseModel.button!.text!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
