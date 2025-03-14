import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class MyCalendar extends StatelessWidget {
  final ValueChanged<DateTime> onCalendarOkClick;

  const MyCalendar({super.key, required this.onCalendarOkClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDatePickerDialog(context);
      },
      child: const Icon(Icons.calendar_today,size: 70,color: TColors.white,),
    );
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      onCalendarOkClick(picked);
    }
  }
}
