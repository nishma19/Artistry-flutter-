// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DateTimePicker extends StatefulWidget {
//   final DateTime initialSelectedDate;
//   final DateTime startDate;
//   final DateTime endDate;
//   final DateTime startTime;
//   final DateTime endTime;
//   final Duration timeInterval;
//   final String datePickerTitle;
//   final String timePickerTitle;
//   final String timeOutOfRangeError;
//   final bool is24h;
//   final ValueChanged<DateTime>? onDateChanged;
//   final ValueChanged<DateTime>? onTimeChanged;
//
//   const DateTimePicker({
//     Key? key,
//     required this.initialSelectedDate,
//     required this.startDate,
//     required this.endDate,
//     required this.startTime,
//     required this.endTime,
//     required this.timeInterval,
//     required this.datePickerTitle,
//     required this.timePickerTitle,
//     required this.timeOutOfRangeError,
//     required this.is24h,
//     this.onDateChanged,
//     this.onTimeChanged,
//   }) : super(key: key);
//
//   @override
//   _DateTimePickerState createState() => _DateTimePickerState();
// }
//
// class _DateTimePickerState extends State<DateTimePicker> {
//   late DateTime _selectedDate;
//   late TimeOfDay _selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.initialSelectedDate;
//     _selectedTime = TimeOfDay.fromDateTime(widget.startTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () => _showDatePicker(context),
//           child: Text(widget.datePickerTitle),
//         ),
//         SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () => _showTimePicker(context),
//           child: Text(widget.timePickerTitle),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _showDatePicker(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: widget.startDate,
//       lastDate: widget.endDate,
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         widget.onDateChanged?.call(pickedDate);
//       });
//     }
//   }
//
//   Future<void> _showTimePicker(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );
//     if (pickedTime != null) {
//       final DateTime selectedDateTime = DateTime(
//         _selectedDate.year,
//         _selectedDate.month,
//         _selectedDate.day,
//         pickedTime.hour,
//         pickedTime.minute,
//       );
//       if (!_isTimeInRange(selectedDateTime)) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(widget.timeOutOfRangeError),
//         ));
//         return;
//       }
//       setState(() {
//         _selectedTime = pickedTime;
//         widget.onTimeChanged?.call(selectedDateTime);
//       });
//     }
//   }
//
//   bool _isTimeInRange(DateTime dateTime) {
//     final DateTime startDateTime = DateTime(
//       _selectedDate.year,
//       _selectedDate.month,
//       _selectedDate.day,
//       widget.startTime.hour,
//       widget.startTime.minute,
//     );
//     final DateTime endDateTime = DateTime(
//       _selectedDate.year,
//       _selectedDate.month,
//       _selectedDate.day,
//       widget.endTime.hour,
//       widget.endTime.minute,
//     );
//     return dateTime.isAfter(startDateTime) && dateTime.isBefore(endDateTime);
//   }
// }
