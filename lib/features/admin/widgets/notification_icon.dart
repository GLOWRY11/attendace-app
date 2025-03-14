import 'package:attendance_appschool/provider/notification_provider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TNotificationIcon extends StatelessWidget {
  const TNotificationIcon({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: TColors.firstcolor,
              size: 40,
            )),
      ),
      // if (notificationProvider.notificationCount > 0)
      Positioned(
        left: 35,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color:  TColors.firstcolor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              '${notificationProvider.unreadCount}',
              style:const TextStyle(
                fontSize: 18,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}