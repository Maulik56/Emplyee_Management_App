import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/add_event_repo.dart';
import 'package:news_app/repo/delete_event_repo.dart';
import '../components/common_text.dart';
import '../constant/color_const.dart';
import '../models/response_model/event_detail_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:get/get.dart';
import '../viewModel/event_detail_view_model.dart';
import '../viewModel/get_events_view_model.dart';
import 'main_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final bool isEdit;
  final String? eventId;
  const EventDetailScreen({
    Key? key,
    this.isEdit = false,
    this.eventId,
  }) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final NavigationService _navigationService = NavigationService();

  TextEditingController titleController = TextEditingController();

  TextEditingController eventTypeController = TextEditingController();

  GetEventsViewModel getEventsViewModel = Get.put(GetEventsViewModel());

  final formKey = GlobalKey<FormState>();

  EventDetailViewModel eventDetailViewModel = Get.put(EventDetailViewModel());

  bool _titleValidator = false;
  bool _startTimeValidator = false;
  bool _finishTimeValidator = false;
  bool _eventTypeValidator = false;

  List eventTypes = [
    'Personal Event',
    'Whole Crew Event',
  ];

  getEventDetail() async {
    if (widget.isEdit) {
      await eventDetailViewModel.getParticularEventDetail(
          eventId: widget.eventId!);
      ParticularEventDetailResponseModel eventDetail =
          eventDetailViewModel.getEventDetailResponse.data;
      titleController = TextEditingController(text: eventDetail.data!.title);
      int startMinutes = eventDetail.data!.startTime!.minute;

      eventDetailViewModel.selectedStartDateTime =
          DateTime.parse(eventDetail.data!.startTime.toString());
      eventDetailViewModel.selectedFinishDateTime =
          DateTime.parse(eventDetail.data!.finishTime.toString());

      // eventDetailViewModel.startTime = eventDetail.data!.startTime!;
      // eventDetailViewModel.finishTime = eventDetail.data!.finishTime!;

      if (eventDetail.data!.startTime!.minute % 15 != 0) {
        startMinutes = eventDetail.data!.startTime!.minute -
            eventDetail.data!.startTime!.minute % 15 +
            15;
      }

      int finishMinutes = eventDetail.data!.finishTime!.minute;

      if (eventDetail.data!.finishTime!.minute % 15 != 0) {
        finishMinutes = eventDetail.data!.finishTime!.minute -
            eventDetail.data!.finishTime!.minute % 15 +
            15;
      }

      var startDate = DateFormat.yMMMEd()
          .format(DateTime.parse(eventDetail.data!.startTime.toString()))
          .toString();

      var startTime = DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.parse(
          DateTime(
                  eventDetail.data!.startTime!.year,
                  eventDetail.data!.startTime!.month,
                  eventDetail.data!.startTime!.day,
                  eventDetail.data!.startTime!.hour,
                  startMinutes)
              .toString()));

      eventDetailViewModel.startTimeController = TextEditingController(
          text:
              "$startDate ${startTime.toString().split(" ")[1]} ${startTime.toString().split(" ").last}");

      var endDate = DateFormat.yMMMEd()
          .format(DateTime.parse(eventDetail.data!.finishTime.toString()))
          .toString();
      var endTime = DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.parse(
          DateTime(
                  eventDetail.data!.finishTime!.year,
                  eventDetail.data!.finishTime!.month,
                  eventDetail.data!.finishTime!.day,
                  eventDetail.data!.finishTime!.hour,
                  finishMinutes)
              .toString()));

      eventDetailViewModel.finishTimeController = TextEditingController(
          text:
              "$endDate ${endTime.toString().split(" ")[1]} ${endTime.toString().split(" ").last}");

      eventTypeController = TextEditingController(
          text: eventDetail.data!.personal == true
              ? eventTypes.first
              : eventTypes.last);
    }
  }

  @override
  void initState() {
    eventDetailViewModel.startTimeController.clear();
    eventDetailViewModel.finishTimeController.clear();
    eventDetailViewModel.selectedStartDateTime = null;
    eventDetailViewModel.selectedFinishDateTime = null;
    getEventDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            appBar: CommonWidget.commonAppBar(
              title: "Event Details",
              leadingWidth: 60.sp,
              leading: TextButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      eventDetailViewModel
                          .startTimeController.text.isNotEmpty &&
                      eventDetailViewModel
                          .finishTimeController.text.isNotEmpty &&
                      eventTypeController.text.isNotEmpty) {
                    progress!.show();

                    final formattedStartDate = eventDetailViewModel
                        .selectedStartDateTime!
                        .toIso8601String();

                    final formattedEndDate = eventDetailViewModel
                        .selectedFinishDateTime!
                        .toIso8601String();

                    var response = await AddEventRepo.addEvent(
                        eventId: widget.eventId ?? "",
                        title: titleController.text,
                        startTime: formattedStartDate,
                        finishTime: formattedEndDate,
                        personal: eventTypeController.text == eventTypes.first
                            ? true
                            : false);

                    if (response['success'] == true) {
                      try {
                        await getEventsViewModel.getEventList(
                          year: eventDetailViewModel.selectedFocusedDay.year
                              .toString(),
                          month: eventDetailViewModel.selectedFocusedDay.month
                              .toString(),
                        );

                        await getEventsViewModel.getEventDetail(
                          year: eventDetailViewModel.selectedFocusedDay.year
                              .toString(),
                          month: eventDetailViewModel.selectedFocusedDay.month
                              .toString(),
                          day: eventDetailViewModel.selectedFocusedDay.day
                              .toString(),
                        );
                      } catch (e) {
                        // TODO
                      }

                      eventDetailViewModel
                          .updateSelectedDateTimeFirstTime(false);

                      _navigationService.pop();
                      progress.dismiss();
                    } else {
                      progress.dismiss();
                      CommonWidget.getSnackBar(context,
                          color: CommonColor.red,
                          duration: 1,
                          message: response['error']);
                    }
                  } else {
                    if (titleController.text.isEmpty) {
                      _titleValidator = true;
                    }
                    if (eventTypeController.text.isEmpty) {
                      _eventTypeValidator = true;
                    }
                    if (eventDetailViewModel.startTimeController.text.isEmpty) {
                      _startTimeValidator = true;
                    }

                    if (eventDetailViewModel
                        .finishTimeController.text.isEmpty) {
                      _finishTimeValidator = true;
                    }
                    setState(() {});
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 15.sp, color: CommonColor.appBarButtonColor),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _navigationService.pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 15.sp, color: Colors.red),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: GetBuilder<EventDetailViewModel>(
              builder: (controller) {
                if (widget.isEdit &&
                    controller.getEventDetailResponse.status ==
                        Status.LOADING) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.getEventDetailResponse.status ==
                    Status.COMPLETE) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30.sp,
                                  ),
                                  CommonWidget.textFormField(
                                      onTap: () {
                                        _titleValidator = false;
                                        setState(() {});
                                      },
                                      controller: titleController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      errorText: _titleValidator
                                          ? 'Please enter the title'
                                          : null,
                                      prefix: const Icon(Icons.edit_calendar),
                                      hintText: "Title"),
                                  SizedBox(
                                    height: 20.sp,
                                  ),
                                  CommonWidget.textFormField(
                                      onTap: () {
                                        _startTimeValidator = false;
                                        setState(() {});

                                        eventDetailViewModel
                                            .selectStartDate(context);
                                      },
                                      readOnly: true,
                                      controller: eventDetailViewModel
                                          .startTimeController,
                                      errorText: _startTimeValidator
                                          ? 'Please select start time'
                                          : null,
                                      prefix: const Icon(Icons.schedule),
                                      suffix: const Icon(
                                          Icons.chevron_right_outlined),
                                      hintText: "Start time"),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  CommonWidget.textFormField(
                                      onTap: () {
                                        _finishTimeValidator = false;
                                        setState(() {});
                                        eventDetailViewModel
                                            .selectFinishDate(context);
                                      },
                                      readOnly: true,
                                      controller: eventDetailViewModel
                                          .finishTimeController,
                                      errorText: _finishTimeValidator
                                          ? 'Please select finish time'
                                          : null,
                                      prefix: const Icon(Icons.schedule),
                                      suffix: const Icon(
                                          Icons.chevron_right_outlined),
                                      hintText: "Finish time"),
                                  SizedBox(
                                    height: 20.sp,
                                  ),
                                  CommonWidget.textFormField(
                                      onTap: () {
                                        _eventTypeValidator = false;
                                        setState(() {});
                                        buildSelectEventTypeActionSheet(context,
                                            actionsValueList: eventTypes);
                                      },
                                      readOnly: true,
                                      controller: eventTypeController,
                                      errorText: _eventTypeValidator
                                          ? 'Please enter event type'
                                          : null,
                                      prefix: const Icon(Icons.group),
                                      suffix: const Icon(
                                          Icons.chevron_right_outlined),
                                      hintText: "Event type"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30.sp,
                                ),
                                CommonWidget.textFormField(
                                    onTap: () {
                                      _titleValidator = false;
                                      setState(() {});
                                    },
                                    controller: titleController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    errorText: _titleValidator
                                        ? 'Please enter the title'
                                        : null,
                                    prefix: const Icon(Icons.edit_calendar),
                                    hintText: "Title"),
                                SizedBox(
                                  height: 20.sp,
                                ),
                                CommonWidget.textFormField(
                                    onTap: () {
                                      _startTimeValidator = false;
                                      setState(() {});

                                      eventDetailViewModel
                                          .selectStartDate(context);
                                    },
                                    readOnly: true,
                                    controller: eventDetailViewModel
                                        .startTimeController,
                                    errorText: _startTimeValidator
                                        ? 'Please select start time'
                                        : null,
                                    prefix: const Icon(Icons.schedule),
                                    suffix: const Icon(
                                        Icons.chevron_right_outlined),
                                    hintText: "Start time"),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                CommonWidget.textFormField(
                                    onTap: () {
                                      _finishTimeValidator = false;
                                      setState(() {});
                                      eventDetailViewModel
                                          .selectFinishDate(context);
                                    },
                                    readOnly: true,
                                    controller: eventDetailViewModel
                                        .finishTimeController,
                                    errorText: _finishTimeValidator
                                        ? 'Please select finish time'
                                        : null,
                                    prefix: const Icon(Icons.schedule),
                                    suffix: const Icon(
                                        Icons.chevron_right_outlined),
                                    hintText: "Finish time"),
                                SizedBox(
                                  height: 20.sp,
                                ),
                                CommonWidget.textFormField(
                                    onTap: () {
                                      _eventTypeValidator = false;
                                      setState(() {});
                                      buildSelectEventTypeActionSheet(context,
                                          actionsValueList: eventTypes);
                                    },
                                    readOnly: true,
                                    controller: eventTypeController,
                                    errorText: _eventTypeValidator
                                        ? 'Please enter event type'
                                        : null,
                                    prefix: const Icon(Icons.group),
                                    suffix: const Icon(
                                        Icons.chevron_right_outlined),
                                    hintText: "Event type"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar:
                widget.isEdit ? deleteEventButton(context) : const SizedBox(),
          );
        },
      ),
    );
  }

  /// Delete event button:
  SafeArea deleteEventButton(BuildContext context) {
    return SafeArea(
      child: Material(
        color: const Color(0xffe8e8ec),
        child: InkWell(
          onTap: () {
            buildDeleteEventActionSheet(context, widget.eventId);
          },
          child: SizedBox(
              height: 50.sp,
              child: Center(
                child: Text(
                  "Delete Event",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CommonColor.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  /// Delete event action sheet:
  Future<dynamic> buildDeleteEventActionSheet(
      BuildContext bottomSheetContext, String? eventId) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "Yes, Delete Event", color: CommonColor.red),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();

            var response = await DeleteEventRepo.deleteEvent(eventId: eventId!);

            if (response['success'] == true) {
              try {
                getEventsViewModel.getEventList(
                    year:
                        eventDetailViewModel.selectedFocusedDay.year.toString(),
                    month: eventDetailViewModel.selectedFocusedDay.month
                        .toString(),
                    isLoading: false);
              } catch (e) {
                // TODO
              }

              try {
                getEventsViewModel.getEventDetail(
                    year:
                        eventDetailViewModel.selectedFocusedDay.year.toString(),
                    month: eventDetailViewModel.selectedFocusedDay.month
                        .toString(),
                    day: eventDetailViewModel.selectedFocusedDay.day.toString(),
                    isLoading: false);
              } catch (e) {
                // TODO
              }

              Navigator.pop(bottomSheetContext);
            } else {
              CommonWidget.getSnackBar(bottomSheetContext,
                  color: CommonColor.red,
                  duration: 2,
                  message: response['error']);
            }
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  /// Select event type action sheet:
  Future<dynamic> buildSelectEventTypeActionSheet(
    BuildContext context, {
    List? actionsValueList,
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
          onPressed: (context) {
            eventTypeController =
                TextEditingController(text: eventTypes[index]);
            Navigator.pop(context);
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
