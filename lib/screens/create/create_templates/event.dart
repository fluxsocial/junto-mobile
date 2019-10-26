import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> with DateParser {
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

  /// Creates a [CentralizedLongFormExpression] from the given data entered
  /// by the user.
  CentralizedEventFormExpression createExpression() {
    return CentralizedEventFormExpression(
      startTime: DateTime(
        int.parse(startYear),
        transformMonthToInt(startMonth),
        int.parse(startDay),
        int.parse(startHour),
        int.parse(startMinute),
      ).toIso8601String(),
      endTime: DateTime(
        int.parse(endYear),
        transformMonthToInt(endMonth),
        int.parse(endDay),
        int.parse(endHour),
        int.parse(endMinute),
      ).toIso8601String(),
      description: detailsController.value.text,
      location: locationController.value.text,
      photo: '',
      title: titleController.value.text,
    );
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

  void _updateDate(DateTime date, String period) {
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff999999),
                        ),
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      maxLength: 140,
                      style: const TextStyle(
                          fontSize: 20,
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
                    child: const Center(
                      child: Text('Add a cover photo (optional)'),
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
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff999999),
                            ),
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
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
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
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff999999),
                            ),
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
                                          fontWeight: FontWeight.w500),
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
                    // padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextField(
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Location',
                        hintStyle: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      cursorColor: const Color(0xff333333),
                      cursorWidth: 2,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      maxLength: 80,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextField(
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Details',
                        hintStyle: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      cursorColor: const Color(0xff333333),
                      cursorWidth: 2,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      maxLength: 80,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
