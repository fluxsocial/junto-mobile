import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:google_maps_webservice/places.dart';

// ignore: unused_element
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController;
  TextEditingController dateController;
  TextEditingController locationController;
  TextEditingController detailsController;

  DateTime _startDate = DateTime.now();
  bool startPickerOpen = false;
  String startMinute;
  String startHour;
  String startDay;
  String startMonth;
  String startYear;
  String startPeriod = '';

  bool endPickerOpen = false;
  String endMinute = '';
  String endHour = '';
  String endDay = '';
  String endMonth = '';
  String endYear = '';
  String endPeriod = '';

  @override
  void initState() {
    super.initState();
    print(DateTime.now());
    titleController = TextEditingController();
    dateController = TextEditingController();
    locationController = TextEditingController();
    detailsController = TextEditingController();

    startDay = DateTime.now().day.toString();
    startMonth = transformMonth(DateTime.now().month).toString();
    startYear = DateTime.now().year.toString();
    startHour = transformHour(DateTime.now().hour, 'start').toString();
    startMinute = transformMinute(DateTime.now().minute);
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    locationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  int transformHour(int hour, String period) {
    if (hour < 12 && hour != 0) {
      if (period == 'start') {
        setState(() {
          startPeriod = 'AM';
        });
      } else if (period == 'end') {
        setState(() {
          endPeriod = 'AM';
        });
      }
      return hour;
    } else if (hour > 12) {
      if (period == 'start') {
        setState(() {
          startPeriod = 'PM';
        });
      } else if (period == 'end') {
        setState(() {
          endPeriod = 'PM';
        });
      }
      return hour - 12;
    } else if (hour == 0) {
      if (period == 'start') {
        setState(() {
          startPeriod = 'aM';
        });
      } else if (period == 'end') {
        setState(() {
          endPeriod = 'AM';
        });
      }
      return 12;
    } else if (hour == 12) {
      if (period == 'start') {
        setState(() {
          startPeriod = 'PM';
        });
      } else if (period == 'end') {
        setState(() {
          endPeriod = 'PM';
        });
      }
      return hour;
    }
    return 0;
  }

  String transformMinute(int minute) {
    if (minute < 10) {
      return '0' + minute.toString();
    } else {
      return minute.toString();
    }
  }

  String transformMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
    }
    return '';
  }

  void _updateDate(DateTime date, String period) {
    print(DateTime.now());
    setState(() {
      if (period == 'start') {
        startDay = date.day.toString();
        startMonth = transformMonth(date.month).toString();
        startYear = date.year.toString();
        startHour = transformHour(date.hour, 'start').toString();
        startMinute = transformMinute(date.minute);
      } else if (period == 'end') {
        endDay = date.day.toString();
        endMonth = transformMonth(date.month).toString();
        endYear = date.year.toString();
        endHour = transformHour(date.hour, 'end').toString();
        endMinute = transformMinute(date.minute);
      }
    });

    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: <Widget>[
                  Container(
                    // color: Colors.blue,
                    child: TextFormField(
                      validator: Validator.validateNonEmpty,
                      controller: titleController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name of event',
                        hintStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff333333),
                        ),
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      maxLength: 140,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  // Container(
                  //   height: .75,
                  //   color: Color(0xffeeeeee),
                  // ),
                  Container(
                    color: const Color(0xfffbfbfb),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: const Text('Add a cover photo (optional)'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      switch (startPickerOpen) {
                        case false:
                          setState(() {
                            startPickerOpen = true;
                          });
                          break;
                        case true:
                          setState(() {
                            startPickerOpen = false;
                          });
                          break;
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Start Date',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                startMonth +
                                    ' ' +
                                    startDay +
                                    ', ' +
                                    startYear +
                                    ', ' +
                                    startHour +
                                    ':' +
                                    startMinute +
                                    ' ' +
                                    startPeriod,
                                style: const TextStyle(fontSize: 17),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  startPickerOpen
                      ? Container(
                          height: 200,
                          child: CupertinoDatePicker(
                            initialDateTime: _startDate,
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime date) {
                              // print(date);
                              _updateDate(date, 'start');
                              _startDate = date;
                            },
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () {
                      switch (endPickerOpen) {
                        case false:
                          setState(() {
                            endPickerOpen = true;
                          });
                          break;
                        case true:
                          setState(() {
                            endPickerOpen = false;
                          });
                          break;
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'End Date',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          endDay == ''
                              ? const SizedBox()
                              : Row(
                                  children: <Widget>[
                                    Text(
                                      endMonth +
                                          ' ' +
                                          endDay +
                                          ', ' +
                                          endYear +
                                          ', ' +
                                          endHour +
                                          ':' +
                                          endMinute +
                                          ' ' +
                                          endPeriod,
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  endPickerOpen
                      ? Container(
                          height: 200,
                          child: CupertinoDatePicker(
                            initialDateTime: _startDate,
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime date) {
                              _updateDate(date, 'end');
                            },
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      'Location',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      'Details',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    color: const Color(0xfffbfbfb),
                    constraints:
                        const BoxConstraints(minHeight: 140, maxHeight: 240),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      validator: Validator.validateNonEmpty,
                      controller: detailsController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff333333),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
