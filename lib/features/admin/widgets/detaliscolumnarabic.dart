import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class details_column_arabic extends StatelessWidget {
  const details_column_arabic({
    super.key, required this.title, required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              Text(subtitle,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),),
              const SizedBox(
                height: 5,
              ),
              const Icon(
                Icons.arrow_left,
                color: TColors.firstcolor,
                size: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
