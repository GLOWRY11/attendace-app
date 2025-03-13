import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:flutter/material.dart';
class MyNotification {
  final int? id;
  final String title;
  final String message;
  final String dateTime;
  final bool isRead;
  final int idFonctionner;  // Updated to int
  final int idEnseignante;  // Updated to int

  MyNotification({
    this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    this.isRead = false,
    required this.idFonctionner,
    required this.idEnseignante,
  });
}

class NotificationProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<MyNotification> _notifications = [];

  List<MyNotification> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    final data = await _dbHelper.getNotifications();
    List<MyNotification> loadedNotifications = [];

    for (var item in data) {
      if (item.containsKey(DBHelper.NOTIFICATION_ID) &&
          item.containsKey(DBHelper.NOTIFICATION_TITLE) &&
          item.containsKey(DBHelper.NOTIFICATION_CONTENT) &&
          item.containsKey(DBHelper.NOTIFICATION_DATE) &&
          item.containsKey(DBHelper.NOTIFICATION_IS_READ) &&
          item.containsKey(DBHelper.NOTIFICATION_FONCTIONNAIRE_ID) &&
          item.containsKey(DBHelper.NOTIFICATION_ENSEIGNANTE_ID)) {
        int id = item[DBHelper.NOTIFICATION_ID] ?? 0;
        String title = item[DBHelper.NOTIFICATION_TITLE] ?? '';
        String message = item[DBHelper.NOTIFICATION_CONTENT] ?? '';
        String dateTime = item[DBHelper.NOTIFICATION_DATE] ?? '';
        bool isRead = item[DBHelper.NOTIFICATION_IS_READ] == 1;
        int idFonctionner = item[DBHelper.NOTIFICATION_FONCTIONNAIRE_ID] ?? 0;
        int idEnseignante = item[DBHelper.NOTIFICATION_ENSEIGNANTE_ID] ?? 0;

        loadedNotifications.add(MyNotification(
          id: id,
          title: title,
          message: message,
          dateTime: dateTime,
          isRead: isRead,
          idFonctionner: idFonctionner,
          idEnseignante: idEnseignante,
        ));
      } else {
        print('Invalid notification map: $item');
      }
    }

    _notifications = loadedNotifications;
    notifyListeners();
    }

  Future<void> addNotification(MyNotification notification) async {
    await _dbHelper.addNotification(
      notification.title,
      notification.message,
      notification.dateTime,
      notification.idFonctionner,
      notification.idEnseignante,
    );
    fetchNotifications();
  }

  Future<void> removeNotification(int id) async {
    await _dbHelper.deleteNotification(id);
    fetchNotifications();
  }

  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index] = MyNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        dateTime: _notifications[index].dateTime,
        isRead: true,
        idFonctionner: _notifications[index].idFonctionner,
        idEnseignante: _notifications[index].idEnseignante,
      );
      notifyListeners();
    }
  }

  int get unreadCount {
    return _notifications.where((MyNotification) => !MyNotification.isRead).length;
  }

  List<MyNotification> getNotificationsByFonctionnaireId(int fonctionnaireId) {
    return _notifications.where((MyNotification) => MyNotification.idFonctionner == fonctionnaireId).toList();
  }
  List<MyNotification> getNotificationsByEnseignanteId(int enseignanteId) {
    return _notifications.where((MyNotification) => MyNotification.idEnseignante == enseignanteId).toList();
  }
}
