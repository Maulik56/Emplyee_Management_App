import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/components/common_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/connectivity_checker.dart';
import '../models/response_model/events_response_model.dart';
import '../models/response_model/get_events_detail_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/event_detail_view_model.dart';
import '../viewModel/get_events_view_model.dart';
import 'event_detail_screen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final NavigationService _navigationService = NavigationService();

  GetEventsViewModel getEventsViewModel = Get.put(GetEventsViewModel());

  EventDetailViewModel eventDetailViewModel = Get.put(EventDetailViewModel());

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    connectivityChecker.checkInterNet();
    getEventsViewModel.getEventList(
      year: _focusedDay.year.toString(),
      month: _focusedDay.month.toString(),
    );
    getEventsViewModel.getEventDetail(
      year: _focusedDay.year.toString(),
      month: _focusedDay.month.toString(),
      day: _focusedDay.day.toString(),
    );
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<DateTime> days = [];

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ConnectivityChecker>(
        builder: (controller) {
          return controller.isConnected
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<GetEventsViewModel>(
                      builder: (controller) {
                        if (controller.getEventsResponse.status ==
                            Status.LOADING) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100.sp),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (controller.getEventsResponse.status ==
                            Status.COMPLETE) {
                          EventsResponseModel eventList =
                              controller.getEventsResponse.data;

                          for (int i = 0;
                              i < eventList.data!.events!.length;
                              i++) {
                            getDaysInBetween(
                                eventList.data!.events![i].timeStart!,
                                eventList.data!.events![i].timeFinish!);
                          }

                          Map<DateTime, List<Event>>? kEventSource;

                          LinkedHashMap<DateTime, List<Event>>? kEvents;

                          try {
                            kEventSource = {
                              for (var item in List.generate(
                                  days.isNotEmpty ? days.length : 0,
                                  (index) => index))
                                DateTime.utc(days[item].year, days[item].month,
                                    days[item].day): List.generate(
                                  1,
                                  (index) => Event(
                                    timeStart: eventList
                                        .data!.events![index].timeStart,
                                    timeFinish: eventList
                                        .data!.events![index].timeFinish,
                                    title: eventList.data!.events![index].title,
                                    description: eventList
                                        .data!.events![index].description,
                                    location:
                                        eventList.data!.events![index].location,
                                  ),
                                )
                            };
                            kEvents = LinkedHashMap<DateTime, List<Event>>(
                              equals: isSameDay,
                              hashCode: getHashCode,
                            )..addAll(kEventSource);
                          } catch (e) {}
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableCalendar(
                                headerStyle: const HeaderStyle(
                                    formatButtonVisible: false), //WEEK
                                availableGestures: AvailableGestures.none,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: _focusedDay,
                                currentDay: _focusedDay,
                                onPageChanged: (focusedDay) {
                                  eventDetailViewModel
                                      .updateSelectedFocusedDay(focusedDay);

                                  connectivityChecker
                                      .checkInterNet()
                                      .then((value) => {
                                            if (connectivityChecker.isConnected)
                                              {
                                                _focusedDay = focusedDay,
                                                setState(() {}),
                                                getEventsViewModel.getEventList(
                                                    year: focusedDay.year
                                                        .toString(),
                                                    month: focusedDay.month
                                                        .toString(),
                                                    isLoading: false),
                                                getEventsViewModel
                                                    .getEventDetail(
                                                        isLoading: false,
                                                        year: focusedDay.year
                                                            .toString(),
                                                        month: focusedDay.month
                                                            .toString(),
                                                        day: focusedDay.day
                                                            .toString()),
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                      noConnectionSnackBar)
                                              }
                                          });
                                },
                                eventLoader: (day) {
                                  try {
                                    return kEvents![day] ?? [];
                                  } catch (e) {
                                    return [];
                                  }
                                },
                                onDaySelected: (selectedDay, focusedDay) async {
                                  eventDetailViewModel
                                      .updateSelectedFocusedDay(focusedDay);

                                  connectivityChecker
                                      .checkInterNet()
                                      .then((value) => {
                                            if (connectivityChecker.isConnected)
                                              {
                                                _selectedDay = selectedDay,
                                                _focusedDay = focusedDay,
                                                getEventsViewModel
                                                    .getEventDetail(
                                                        isLoading: false,
                                                        year: _focusedDay.year
                                                            .toString(),
                                                        month: _focusedDay.month
                                                            .toString(),
                                                        day: _focusedDay.day
                                                            .toString()),
                                                setState(() {}),
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                      noConnectionSnackBar)
                                              }
                                          });
                                },
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    GetBuilder<GetEventsViewModel>(
                      builder: (controller) {
                        if (controller.getEventDetailResponse.status ==
                            Status.LOADING) {
                          return const Center(
                            child: SizedBox(),
                          );
                        }
                        if (controller.getEventDetailResponse.status ==
                            Status.COMPLETE) {
                          EventsDetailResponseModel eventList =
                              controller.getEventDetailResponse.data;
                          return eventList.data!.events!.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: eventList.data!.events!.length,
                                    itemBuilder: (context, index) {
                                      final events =
                                          eventList.data!.events![index];
                                      var formattedDate =
                                          DateFormat('dd-MM-yyyy HH:mm a')
                                              .format(DateTime.parse(
                                                  events.timeStart.toString()));
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.sp, vertical: 5.sp),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            try {
                                              eventDetailViewModel
                                                  .updateStartTime(
                                                      DateTime.parse(events
                                                          .timeStart
                                                          .toString()));
                                              eventDetailViewModel
                                                  .updateFinishTime(
                                                      DateTime.parse(events
                                                          .timeFinish
                                                          .toString()));

                                              eventDetailViewModel
                                                  .updateEditStatus(true);
                                              eventDetailViewModel
                                                  .updateFirstDateSelectedStatus(
                                                      false);
                                              eventDetailViewModel
                                                  .updateSecondDateSelectedStatus(
                                                      false);
                                            } catch (e) {
                                              // TODO
                                            }

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetailScreen(
                                                    isEdit: true,
                                                    eventId: events.id!,
                                                  ),
                                                ));
                                          },
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              side: const BorderSide(
                                                  color: Colors.black)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.sp),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${formattedDate.toString().split(" ")[1]} ${formattedDate.toString().split(" ").last}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 15.sp,
                                                ),
                                                Text(
                                                  events.title ??
                                                      "No title found",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  events.duration.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.orange),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 30.sp),
                                  child: const Center(
                                    child: Text(
                                      "No events found for the selected day",
                                    ),
                                  ),
                                );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TableCalendar(
                      headerStyle:
                          const HeaderStyle(formatButtonVisible: false), //WEEK
                      availableGestures: AvailableGestures.none,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      currentDay: _focusedDay,
                      onPageChanged: (focusedDay) {
                        eventDetailViewModel
                            .updateSelectedFocusedDay(focusedDay);
                        _focusedDay = focusedDay;
                        setState(() {});
                      },
                      onDaySelected: (selectedDay, focusedDay) async {
                        eventDetailViewModel
                            .updateSelectedFocusedDay(focusedDay);
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      },
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    Center(
                      child: CommonText.textBoldWeight500(
                          text: "Unable to connect to server", fontSize: 15.sp),
                    )
                  ],
                );
        },
      ),
    );
  }
}
