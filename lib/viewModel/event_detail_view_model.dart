import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/response_model/event_detail_response_model.dart';
import '../repo/get_event_detail_repo.dart';
import '../services/api_service/api_response.dart';

class EventDetailViewModel extends GetxController {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController finishTimeController = TextEditingController();

  DateTime selectedFocusedDay = DateTime.now();

  void updateSelectedFocusedDay(DateTime value) {
    selectedFocusedDay = value;
    update();
  }

  DateTime startTime = DateTime.now();

  void updateStartTime(DateTime value) {
    startTime = value;
    update();
  }

  DateTime finishTime = DateTime.now();

  DateTime minimumDate = DateTime.now();

  DateTime? selectedStartDateTime;

  DateTime? selectedFinishDateTime;

  bool isEdit = false;

  void updateEditStatus(bool value) {
    isEdit = value;
    update();
  }

  void updateFinishTime(DateTime value) {
    finishTime = value;
    update();
  }

  DateTime initialDateTime = DateTime.now();

  bool isFirstDateSelected = false;

  bool isSecondDateSelected = false;

  bool isSelectedDateTimeFirstTime = true;

  void updateFirstDateSelectedStatus(bool value) {
    isFirstDateSelected = value;
    update();
  }

  void updateSecondDateSelectedStatus(bool value) {
    isSecondDateSelected = value;
    update();
  }

  void updateSelectedDateTimeFirstTime(bool value) {
    isSelectedDateTimeFirstTime = value;
    update();
  }

  String dateTimeFormat(DateTime time) {
    var formattedDate =
        DateFormat.yMMMEd().format(DateTime.parse(time.toString())).toString();

    var formattedTime = DateFormat('dd-MM-yyyy HH:mm a')
        .format(DateTime.parse(time.toString()));
    return "$formattedDate ${formattedTime.toString().split(" ")[1]} ${formattedTime.toString().split(" ").last}";
  }

  Future<void> selectStartDate(BuildContext context) async {
    String? tempDate;
    DateTime startTimeDateValue;
    if (startTimeController.text.isNotEmpty) {
      startTimeDateValue = selectedStartDateTime!;
    } else {
      startTimeDateValue = DateTime.now();
    }

    int initialMinute = startTimeDateValue.minute;

    if (startTimeDateValue.minute % 15 != 0) {
      initialMinute =
          startTimeDateValue.minute - startTimeDateValue.minute % 15 + 15;
    }

    int startMinutes = startTimeDateValue.minute;

    if (startTimeDateValue.minute % 15 != 0) {
      startMinutes =
          startTimeDateValue.minute - startTimeDateValue.minute % 15 + 15;
    }

    int minimumDateTime = startTimeDateValue.minute;

    if (startTimeDateValue.minute % 15 != 0) {
      minimumDateTime =
          startTimeDateValue.minute - startTimeDateValue.minute % 15 + 15;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: 450,
        child: Column(
          children: [
            SizedBox(
              height: 350,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                minuteInterval: 15,
                initialDateTime: DateTime(
                    startTimeDateValue.year,
                    startTimeDateValue.month,
                    startTimeDateValue.day,
                    startTimeDateValue.hour,
                    startMinutes),
                onDateTimeChanged: (DateTime newDateTime) {
                  tempDate = newDateTime.toString();
                  update();
                },
              ),
            ),
            // Close the modal
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () {
                if (tempDate == null) {
                  var startDate = DateFormat.yMMMEd()
                      .format(DateTime.parse(DateTime(
                              startTime.year,
                              startTime.month,
                              startTime.day,
                              startTime.hour,
                              startMinutes)
                          .toString()))
                      .toString();
                  setStartTime(time: null);
                } else {
                  final newDate = DateTime.parse(tempDate!);
                  setStartTime(time: newDate);
                }
                isFirstDateSelected = true;
                update();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectFinishDate(BuildContext context) async {
    String? tempDate;
    DateTime endDateControllerValue;
    if (finishTimeController.text.isNotEmpty) {
      endDateControllerValue = selectedFinishDateTime!;
    } else {
      endDateControllerValue = DateTime.now();
    }
    int startMinutes = endDateControllerValue.minute;

    if (endDateControllerValue.minute % 15 != 0) {
      startMinutes = endDateControllerValue.minute -
          endDateControllerValue.minute % 15 +
          15;
    }

    int finishMinutes = finishTime.minute;

    if (finishTime.minute % 15 != 0) {
      finishMinutes = finishTime.minute - finishTime.minute % 15 + 15;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: 450,
        child: Column(
          children: [
            SizedBox(
              height: 350,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                minuteInterval: 15,
                initialDateTime: DateTime(
                    endDateControllerValue.year,
                    endDateControllerValue.month,
                    endDateControllerValue.day,
                    endDateControllerValue.hour,
                    startMinutes),
                onDateTimeChanged: (DateTime newDateTime) {
                  tempDate = newDateTime.toString();

                  update();
                },
              ),
            ),
            // Close the modal
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () {
                if (tempDate == null) {
                  setEndTime(time: null);
                } else {
                  final newDate = DateTime.parse(tempDate!);

                  setEndTime(time: newDate);
                }
                isSecondDateSelected = true;
                update();

                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  setStartTime({DateTime? time}) {
    if (time != null) {
      startTimeController = TextEditingController(text: dateTimeFormat(time));
      selectedStartDateTime = time;
      DateTime? endTime;

      if (finishTimeController.text.isNotEmpty) {
        endTime = DateTime.parse(
            selectedFinishDateTime.toString().replaceAll('Z', ''));

        if (time.isBefore(endTime)) {
          int diff = time.difference(endTime).inMinutes.abs();

          if (diff < 60) {
            // finishTimeController = TextEditingController(
            //     text: dateTimeFormat(time.add(Duration(hours: 1))));
            //
            // selectedFinishDateTime = time.add(Duration(hours: 1));
          }
        } else {
          finishTimeController = TextEditingController(
              text: dateTimeFormat(time.add(Duration(hours: 1))));

          selectedFinishDateTime = time.add(Duration(hours: 1));
        }
      } else {
        finishTimeController = TextEditingController(
            text: dateTimeFormat(time.add(Duration(hours: 1))));

        selectedFinishDateTime = time.add(Duration(hours: 1));
      }
    } else {
      int startMinutes = startTime.minute;

      if (startTime.minute % 15 != 0) {
        startMinutes = startTime.minute - startTime.minute % 15 + 15;
      }

      int finishMinutes = finishTime.minute;

      if (finishTime.minute % 15 != 0) {
        finishMinutes = finishTime.minute - finishTime.minute % 15 + 15;
      }
      startTimeController = TextEditingController(
          text: dateTimeFormat(DateTime(finishTime.year, finishTime.month,
              finishTime.day, finishTime.hour, finishMinutes)));

      selectedStartDateTime = DateTime(finishTime.year, finishTime.month,
          finishTime.day, finishTime.hour, finishMinutes);

      finishTimeController = TextEditingController(
          text: dateTimeFormat(DateTime(finishTime.year, finishTime.month,
                  finishTime.day, finishTime.hour, finishMinutes)
              .add(Duration(hours: 1))));

      selectedFinishDateTime = DateTime(finishTime.year, finishTime.month,
              finishTime.day, finishTime.hour, finishMinutes)
          .add(Duration(hours: 1));
    }
  }

  setEndTime({DateTime? time}) {
    if (time != null) {
      if (startTimeController.text.isNotEmpty) {
        DateTime? startTime = DateTime.parse(
            selectedStartDateTime.toString().replaceAll('Z', ''));

        if (time.isAfter(startTime)) {
          int diff = time.difference(startTime).inMinutes;

          if (diff < 60) {
            finishTimeController =
                TextEditingController(text: dateTimeFormat(time));
            selectedFinishDateTime = time;
          } else {
            finishTimeController =
                TextEditingController(text: dateTimeFormat(time));

            selectedFinishDateTime = time;
          }
        } else {
          finishTimeController = TextEditingController(
              text: dateTimeFormat(startTime.add(Duration(hours: 1))));
          selectedFinishDateTime = startTime.add(Duration(hours: 1));
        }
      } else {
        startTimeController = TextEditingController(
            text: dateTimeFormat(time.subtract(Duration(hours: 1))));

        selectedStartDateTime = time.subtract(Duration(hours: 1));
        finishTimeController =
            TextEditingController(text: dateTimeFormat(time));

        selectedFinishDateTime = time;
      }
    } else {
      int startMinutes = startTime.minute;

      if (startTime.minute % 15 != 0) {
        startMinutes = startTime.minute - startTime.minute % 15 + 15;
      }

      int finishMinutes = finishTime.minute;

      if (finishTime.minute % 15 != 0) {
        finishMinutes = finishTime.minute - finishTime.minute % 15 + 15;
      }

      startTimeController = TextEditingController(
          text: dateTimeFormat(DateTime(finishTime.year, finishTime.month,
              finishTime.day, finishTime.hour, finishMinutes)));

      selectedStartDateTime = DateTime(finishTime.year, finishTime.month,
          finishTime.day, finishTime.hour, finishMinutes);

      finishTimeController = TextEditingController(
          text: dateTimeFormat(DateTime(finishTime.year, finishTime.month,
                  finishTime.day, finishTime.hour, finishMinutes)
              .add(Duration(hours: 1))));

      selectedFinishDateTime = DateTime(finishTime.year, finishTime.month,
              finishTime.day, finishTime.hour, finishMinutes)
          .add(Duration(hours: 1));
    }
  }

  ApiResponse _getEventDetailResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getEventDetailResponse => _getEventDetailResponse;

  Future<void> getParticularEventDetail({
    bool isLoading = true,
    required String eventId,
  }) async {
    if (isLoading) {
      _getEventDetailResponse = ApiResponse.loading(message: 'Loading');
    }

    try {
      ParticularEventDetailResponseModel response =
          await GetEventDetailRepo.getParticularEventDetail(eventId: eventId);
      if (kDebugMode) {
        print("ParticularEventDetailResponseModel==>${response.data}");
      }

      _getEventDetailResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("ParticularEventDetailResponseModel Error==>$e==");
      }
      _getEventDetailResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
