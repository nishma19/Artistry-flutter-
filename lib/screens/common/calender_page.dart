import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of disabled dates
    // final List<DateTime> disabledDates = [
    //   DateTime.now().subtract(Duration(days: 1)), // Yesterday
    //   DateTime.now().add(Duration(days: 3)), // 3 days from now
    //   DateTime.now().add(Duration(days: 5)), // 5 days from now
    // ];

    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        // Handle selected date
        print("Selected date: $selectedDate");
      },
      // disabledDates: disabledDates,
      activeColor: Colors.orange[50],
      dayProps:  EasyDayProps(
        borderColor:  Color(0xFFB3261E).withOpacity(0.5),
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: Color(0xffF6E4CF),
      ),
    );
  }
}
