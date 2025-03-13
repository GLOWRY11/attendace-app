import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class details_column extends StatelessWidget {
  const details_column({
    super.key, required this.title, required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          Row(
            children: [
              const Icon(
                Icons.arrow_right,
                color: TColors.firstcolor,
                size: 50,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(subtitle,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),),
            ],
          ),
        ],
      ),
    );
  }
}



