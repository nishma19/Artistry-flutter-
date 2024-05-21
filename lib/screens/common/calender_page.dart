import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
class DatePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        // Handle selected date
      },
      activeColor: Color(0xfff3be98),
      //const Color(0xff85A389),
      dayProps: const EasyDayProps(

        borderColor:  Color(0xfff3be98),
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: Color(0xffF6E4CF),
      ),
    );
  }
}




