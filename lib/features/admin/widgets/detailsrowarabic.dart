import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class details_row_arabic extends StatelessWidget {
  const details_row_arabic({
    super.key, required this.subtitle, required this.titlefr, required this.titlear,
  });

  final String titlefr;
  final String titlear;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titlefr,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Text(titlear,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_right,
                color: TColors.firstcolor,
                size: 50,
              ),
              Text(subtitle,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),),
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
