import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String _selectedDate = ''; // Define _selectedDate
  String _selectedTime = ''; // Define _selectedTime

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();

    return DateTimePicker(
      type: DateTimePickerType.Time,
      initialSelectedDate:  dt.add(Duration(days: 1)),
      startDate: dt.add(Duration(days: 1)),
      endDate: dt.add(Duration(days: 60)),
      startTime: DateTime(dt.year, dt.month, dt.day, 6),
      endTime: DateTime(dt.year, dt.month, dt.day, 18),
      timeInterval: Duration(hours: 3),
      datePickerTitle: 'Pick your preferred date',
      timePickerTitle: 'Pick your preferred time',
      timeOutOfRangeError: 'Sorry shop is closed now',
      is24h: false,
      onDateChanged: (date) {
        setState(() {
          _selectedDate = DateFormat('dd MMM, yyyy').format(date);
        });
      },
      onTimeChanged: (time) {
        setState(() {
          _selectedTime = DateFormat('hh:mm:ss aa').format(time);
        });
      },
    );
  }

}
