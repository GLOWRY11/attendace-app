import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/provider/notification_provider.dart';
import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import '../../../../util/constant/colors.dart';

class EnseignantNotificationScreen extends StatefulWidget {
  const EnseignantNotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<EnseignantNotificationScreen> {
  late DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  Future<Map<String, String>> getFonctionnaireDetailsById(int Id) async {
    final fonctionnaire = await dbHelper.getFonctionaireDetailsById(Id);
    return {
      'nom': fonctionnaire[DBHelper.FONCTIONNAIRE_NOM] ?? 'Unknown',
      'prenom': fonctionnaire[DBHelper.FONCTIONNAIRE_PRENOM] ?? '',
    };
  }

  // Method to mark notification as read
  Future<void> markNotificationAsRead(int? notificationId) async {
    // Implement your logic here to update the notification's isRead status in the database
    await dbHelper.markNotificationAsRead(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final enseignanteID = authProvider.authenticatedEnseignant?.id ?? 0;
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: TColors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: TColors.firstcolor,
          ),
        ),
        centerTitle: true,
        backgroundColor: TColors.white,
        title: const Text(
          "ESTM Digital",
          style: TextStyle(
            color: TColors.firstcolor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: notificationProvider.fetchNotifications(),
        builder: (context, snapshot) {
          final notifications =
          notificationProvider.getNotificationsByFonctionnaireId(enseignanteID);
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune notification disponible',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 26),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          markNotificationAsRead(notifications[index].id); // Assuming `id` is the identifier for the notification
                        },
                        child: FutureBuilder<Map<String, String>>(
                          future: getFonctionnaireDetailsById(notifications[index].idFonctionner),
                          builder: (context, snapshot) {
                            final fonctionnaireDetails = snapshot.data ?? {'nom': 'Unknown', 'prenom': ''};
                            return buildNotificationItem(notifications[index], fonctionnaireDetails);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildNotificationItem(MyNotification notification, Map<String, String> fonctionnaireDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TColors.firstcolor,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: TColors.firstcolor,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fonctionnaire: ${fonctionnaireDetails['nom']} ${fonctionnaireDetails['prenom']}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
              Text(
                notification.dateTime,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              Icon(
                notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                color: notification.isRead ? Colors.green : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
