import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/provider/notification_provider.dart';
import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import '../../../generated/l10n.dart';
import '../../../util/constant/colors.dart';

class NotificationScreenFonction extends StatefulWidget {
  const NotificationScreenFonction({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreenFonction> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late List<DropdownMenuItem<int>> dropdownItems = [];
  int selectedEnseignanteId = 0;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadEnseignantsData();
  }
  Future<Map<String, String>> getEnseignantDetails(int enseignantId) async {
    final enseignant = await dbHelper.getEnseignantDetailsById(enseignantId); // Assuming dbHelper is accessible
    return {
      'nom': enseignant['nom'] ?? 'Unknown',
      'prenom': enseignant['prenom'] ?? '',
    };
  }

  void loadEnseignantsData() async {
    List<Map<String, dynamic>>? enseignants = await dbHelper.getAllEnseignantTable();
    Set<int> uniqueIds = {};
    List<DropdownMenuItem<int>> items = [];

    for (var enseignantMap in enseignants ?? []) {
      if (enseignantMap.containsKey(DBHelper.ENSEIGNANT_ID) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_NOM) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_PRENOM)) {
        int id = enseignantMap[DBHelper.ENSEIGNANT_ID] ?? 0;
        String nom = enseignantMap[DBHelper.ENSEIGNANT_NOM] ?? '';
        String prenom = enseignantMap[DBHelper.ENSEIGNANT_PRENOM] ?? '';

        if (!uniqueIds.contains(id)) {
          uniqueIds.add(id);
          items.add(DropdownMenuItem<int>(
            value: id,
            child: Text('$nom $prenom'),
          ));
        }
      } else {
        print('Invalid enseignant map: $enseignantMap');
      }
    }

    setState(() {
      dropdownItems = items;
      if (dropdownItems.isNotEmpty) {
        selectedEnseignanteId = dropdownItems.first.value!;
      }
    });
    }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final fonctionnaireId = authProvider.authenticatedFonctionnaire?.id ?? 0;
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
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
      ),
      body: FutureBuilder(
        future: notificationProvider.fetchNotifications(),
        builder: (context, snapshot) {
          final notifications = notificationProvider.getNotificationsByFonctionnaireId(fonctionnaireId);
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
          return FutureBuilder<Map<String, String>>(
          future: getEnseignantDetails(notifications[index].idEnseignante),
          builder: (context, snapshot) {
          final enseignantDetails = snapshot.data ?? {'nom': 'Unknown', 'prenom': ''};
          return buildNotificationItem(notifications[index], enseignantDetails);
          },
          );
          },
          ),
          ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNotificationDialog(notificationProvider);
        },
        backgroundColor: TColors.firstcolor,
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
  Widget buildNotificationItem(MyNotification notification, Map<String, String> enseignantDetails) {
    return GestureDetector(
      onLongPress: () {
        Provider.of<NotificationProvider>(context, listen: false).removeNotification(notification.id!);
      },
      child: Container(
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
              "Enseignant: ${enseignantDetails['nom']} ${enseignantDetails['prenom']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
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
      ),
    );
  }

  void _showAddNotificationDialog(NotificationProvider notificationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Ajouter une notification',
            style: TextStyle(
              color: TColors.firstcolor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 36),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      labelText: 'Titre',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le titre ne peut pas être vide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      labelText: 'Contenu',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le contenu ne peut pas être vide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      labelText: 'Date (YYYY-MM-DD)',
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: TColors.firstcolor, // Color of the date picker header
                                    onPrimary: Colors.white, // Text color of the date picker header
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            dateController.text = pickedDate.toString().substring(0, 10); // Format the picked date
                          }
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez choisir une date';
                      }
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                        return 'Format de date invalide (YYYY-MM-DD)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      labelText: 'Enseignante',
                    ),
                    value: selectedEnseignanteId,
                    items: dropdownItems.isEmpty
                        ? null
                        : dropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedEnseignanteId = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Veuillez sélectionner une enseignante';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).cancel,
                style: const TextStyle(
                  color: TColors.firstcolor,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String title = titleController.text;
                  final String content = contentController.text;
                  final String date = dateController.text;
                  final int fonctionnaireId = Provider.of<AuthenticationProvider>(context, listen: false).authenticatedFonctionnaire?.id ?? 0;
                  final int enseignanteId = selectedEnseignanteId;

                  await notificationProvider.addNotification(
                    MyNotification(
                      title: title,
                      message: content,
                      dateTime: date,
                      idFonctionner: fonctionnaireId,
                      idEnseignante: enseignanteId,
                    ),
                  );

                  titleController.clear();
                  contentController.clear();
                  dateController.clear();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: TColors.firstcolor,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                side: const BorderSide(color: TColors.firstcolor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: Text(
                S.of(context).ajoutee,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
