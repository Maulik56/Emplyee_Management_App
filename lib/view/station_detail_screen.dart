import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/models/response_model/get_timezone_list_response_model.dart';
import 'package:news_app/repo/team_info_repo.dart';
import 'package:news_app/viewModel/loader_view_model.dart';
import '../constant/color_const.dart';
import '../models/response_model/filter_country_response_model.dart';
import '../models/response_model/sector_list_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/create_team_view_model.dart';
import '../viewModel/get_team_info_view_model.dart';
import 'main_screen.dart';

class StationDetailScreen extends StatefulWidget {
  const StationDetailScreen({Key? key}) : super(key: key);

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  final NavigationService _navigationService = NavigationService();

  LoaderViewModel settingsViewModel = Get.put(LoaderViewModel());

  CreateTeamViewModel getTimeZoneListViewModel = Get.put(CreateTeamViewModel());

  TextEditingController teamNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController timeZoneController = TextEditingController();
  TextEditingController sectorController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Country? country;

  void getCurrentCountry() async {
    try {
      final currentCountry = WidgetsBinding.instance.window.locale.countryCode;
      getTimeZoneListViewModel.getFilterCountyList();

      setState(() {});
      getTimeZoneListViewModel.getSectorList();

    } on Exception catch (e) {
      // TODO
    }
  }

  bool _teamNameValidator = false;
  bool _timeZoneValidator = false;
  bool _countryValidator = false;
  bool _sectorValidator = false;
  GetTeamInfoViewModel getTeamInfoViewModel = Get.put(GetTeamInfoViewModel());

  populateFormDetails() async {
    await getTeamInfoViewModel.getTeamInfo();
    var response = getTeamInfoViewModel.getTeamInfoResponse.data;
    final teamInfo = response['data'];
    try {
      country = Country.parse(teamInfo['country']);
      teamNameController = TextEditingController(text: teamInfo['name']);
      sectorController = TextEditingController(text: teamInfo['sector']);
      countryController = TextEditingController(text: teamInfo['country']);
      timeZoneController = TextEditingController(text: teamInfo['timezone']);
      getTimeZoneListViewModel.getTimeZoneList(country: teamInfo['country']??country!.name);
    } catch (e) {
      // TODO
    }
    setState(() {});
  }

  @override
  void initState() {
    getCurrentCountry();
    populateFormDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CommonWidget.commonAppBar(
            title: "Station Detail",
            leading: InkResponse(
              onTap: () {
                _navigationService.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (countryController.text.isNotEmpty &&
                      sectorController.text.isNotEmpty &&
                      teamNameController.text.isNotEmpty &&
                      timeZoneController.text.isNotEmpty) {
                    progress!.show();

                    bool? status = await TeamInfoRepo.sendTeamInfo(
                        name: teamNameController.text,
                        country: countryController.text,
                        timezone: timeZoneController.text,
                        sector: sectorController.text);

                    if (status) {
                      await getTeamInfoViewModel.getTeamInfo();
                      _navigationService.pop();
                      progress.dismiss();
                    } else {
                      progress.dismiss();
                      CommonWidget.getSnackBar(context,
                          color: CommonColor.red,
                          duration: 2,
                          message: "Please try again!");
                    }
                  } else {
                    if (timeZoneController.text.isEmpty) {
                      _timeZoneValidator = true;
                    }
                    if (countryController.text.isEmpty) {
                      _countryValidator = true;
                    }
                    if (sectorController.text.isEmpty) {
                      _sectorValidator = true;
                    }
                    if (teamNameController.text.isEmpty) {
                      _teamNameValidator = true;
                    }
                    setState(() {});
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: CommonColor.appBarButtonColor),
                ),
              )
            ],
          ),
          body: ProgressHUD(child: Builder(
            builder: (context) {
              final progress = ProgressHUD.of(context);
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35.sp,
                          ),
                          CommonWidget.textFormField(
                              onTap: () {
                                _teamNameValidator = false;
                                setState(() {});
                              },
                              controller: teamNameController,
                              textCapitalization: TextCapitalization.words,
                              errorText: _teamNameValidator
                                  ? 'Please enter the team name'
                                  : null,
                              prefix: const Icon(Icons.groups_outlined),
                              hintText: "Team Name"),
                          SizedBox(
                            height: 10.sp,
                          ),
                          GetBuilder<CreateTeamViewModel>(
                            builder: (controller) {
                              if (controller.getSectorListResponse.status ==
                                  Status.LOADING) {
                                return const SizedBox();
                              }
                              if (controller.getSectorListResponse.status ==
                                  Status.COMPLETE) {
                                SectorListResponseModel sectorList =
                                    controller.getSectorListResponse.data;
                                return CommonWidget.textFormField(
                                    onTap: () {
                                      _sectorValidator = false;
                                      setState(() {});
                                      buildSelectSectorActionSheet(context,
                                          actionsValueList:
                                              sectorList.data!.sectors!);
                                    },
                                    readOnly: true,
                                    controller: sectorController,
                                    errorText: _sectorValidator
                                        ? 'Please select the sector'
                                        : null,
                                    prefix: const Icon(Icons.category_outlined),
                                    suffix: Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 35.sp,
                                    ),
                                    hintText: "Select Sector");
                              }
                              return const SizedBox();
                            },
                          ),
                          SizedBox(
                            height: 50.sp,
                          ),
                          GetBuilder<CreateTeamViewModel>(
                            builder: (controller) {
                              if (controller
                                      .getFilterCountryListResponse.status ==
                                  Status.LOADING) {
                                return const CircularProgressIndicator();
                              }
                              if (controller
                                      .getFilterCountryListResponse.status ==
                                  Status.COMPLETE) {
                                FilterCountryResponseModel filterCountryList =
                                    controller
                                        .getFilterCountryListResponse.data;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWidget.textFormField(
                                        onTap: () {
                                          _countryValidator = false;
                                          setState(() {});
                                          showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                const CountryListThemeData(
                                              bottomSheetHeight: 450,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            countryFilter: filterCountryList
                                                .data!.countries,
                                            onSelect: (Country country) {
                                              this.country = country;
                                              countryController =
                                                  TextEditingController(
                                                      text: country.name);
                                              getTimeZoneListViewModel
                                                  .getTimeZoneList(
                                                      country: country.name,
                                                      isLoading: false);
                                              timeZoneController.clear();

                                              setState(() {});
                                            },
                                          );
                                        },
                                        readOnly: true,
                                        errorText: _countryValidator
                                            ? 'Please select the country'
                                            : null,
                                        controller: countryController,
                                        prefix: country?.flagEmoji != null
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 10.sp,
                                                  ),
                                                  Text(
                                                    country!.flagEmoji,
                                                    style: TextStyle(
                                                        fontSize: 21.sp),
                                                  ),
                                                ],
                                              )
                                            : Icon(
                                                Icons.flag,
                                                size: 30.sp,
                                              ),
                                        suffix: Icon(
                                          Icons.arrow_drop_down_sharp,
                                          size: 35.sp,
                                        ),
                                        hintText: "Country"),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          SizedBox(
                            height: 10.sp,
                          ),
                          GetBuilder<CreateTeamViewModel>(
                            builder: (controller) {
                              if (controller.getTimeZoneListResponse.status ==
                                  Status.LOADING) {
                                return const SizedBox();
                              }
                              if (controller.getTimeZoneListResponse.status ==
                                  Status.COMPLETE) {
                                GetTimeZoneListResponseModel timeZoneList =
                                    controller.getTimeZoneListResponse.data;
                                return CommonWidget.textFormField(
                                    onTap: () {
                                      _timeZoneValidator = false;
                                      setState(() {});

                                      if (countryController.text.isNotEmpty) {
                                        print(
                                            'DATA==>${timeZoneList.data!.timezones}');
                                        buildChangeTimeZoneActionSheet(context,
                                            actionsValueList:
                                                timeZoneList.data!.timezones);
                                      } else {
                                        showOkAlertDialog(
                                          context: context,
                                          builder: (context, child) =>
                                              AlertDialog(
                                            title: const Text(
                                                "Please select the country first."),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text(AppStrings.ok))
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    readOnly: true,
                                    controller: timeZoneController,
                                    errorText: _timeZoneValidator
                                        ? 'Please select the timezone'
                                        : null,
                                    prefix: const Icon(Icons.public),
                                    suffix: Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 35.sp,
                                    ),
                                    hintText: "Timezone");
                              }
                              return const SizedBox();
                            },
                          ),
                          SizedBox(
                            height: 50.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
        );
      },
    ));
  }

  /// Select Timezone Action Sheet:
  Future<dynamic> buildChangeTimeZoneActionSheet(
    BuildContext context, {
    List<Timezone>? actionsValueList,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].displayName.toString()),
              color: CommonColor.blue),
          onPressed: (context) {
            Navigator.pop(context);
            timeZoneController =
                TextEditingController(text: actionsValueList[index].name);
            setState(() {});
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  /// Select Sector Action Sheet:
  Future<dynamic> buildSelectSectorActionSheet(
    BuildContext context, {
    List<String>? actionsValueList,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].toString()),
              color: CommonColor.blue),
          onPressed: (context) async {
            Navigator.pop(context);
            sectorController =
                TextEditingController(text: actionsValueList[index].toString());
            setState(() {});
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
