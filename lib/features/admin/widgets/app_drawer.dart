import 'package:attendance_appschool/features/admin/espace/espace_enseignants.dart';
import 'package:attendance_appschool/features/admin/espace/espace_etudianat.dart';
import 'package:attendance_appschool/features/admin/espace/espace_filier.dart';
import 'package:attendance_appschool/features/admin/espace/espace_module.dart';
import 'package:attendance_appschool/features/admin/history/attendance_history_page.dart';
import 'package:attendance_appschool/features/admin/profil/fonctionner_details.dart';
import 'package:attendance_appschool/navigation_menu_admin.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../provider/AuthenticationProvider.dart';
import '../../settings/app_language_settings.dart';
import '../notificaton/notification_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {
        "title": S.of(context).home,
        "icon": Icons.home,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationMenuAdmin(),
            ),
          );
        }
      },
      {
        "title": S.of(context).espace_enseignants,
        "icon": Icons.school,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EspaceEnsgeint(),
            ),
          );
        }
      },
      {
        "title": S.of(context).major_space,
        "icon": Icons.group,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EspaceFiliere(),
            ),
          );
        }
      },
      {
        "title": S.of(context).student_space,
        "icon": Icons.school_outlined,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EspaceEtudiante(),
            ),
          );
        }
      },
      {
        "title": S.of(context).module_management_space,
        "icon": Icons.class_outlined,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddModuleElementPage(),
            ),
          );
        }
      },
      {
        "title":"Les enregistrements des présences",
        "icon": Icons.list_alt,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const AttendanceHistoryPageforAdmin(),
            ),
          );
        }
      },
      {
        "title":"Notifications",
        "icon": Icons.notifications,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const NotificationScreenFonction(),
            ),
          );
        }
      },
      {
        "title":"Paramètre",
        "icon": Icons.settings,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const AppLanguageSettings(),
            ),
          );
        }
      },
      {
        "title": S.of(context).profile_space,
        "icon": Icons.person,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FonctionnerDetails(),
            ),
          );
        }
      },
    ];

    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      backgroundColor: TColors.white,
      child: SafeArea(
        child: Column(
          children: [
            _studentDetails(context),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 26,
                ),
                itemCount: drawerItems.length,
                itemBuilder: (ctx, i) => ListTile(
                  onTap: () => drawerItems[i]["onClick"](),
                  leading: Icon(
                    drawerItems[i]["icon"],
                    size: 35,
                  ),
                  title: Text(
                    drawerItems[i]["title"],
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            _logoutButton(context)
          ],
        ),
      ),
    );
  }

  void _openStudentDetailPage(BuildContext context) {
    // context.go(StudentDetails.route);
  }
  Widget _studentDetails(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final Fonctionnairenom =
        authProvider.authenticatedFonctionnaire?.nom ?? 'Fonctionnaire';
    final FonctionnairePrenom =
        authProvider.authenticatedFonctionnaire?.prenom ?? 'Enseignant';
    final Fonctionnairemail =
        authProvider.authenticatedFonctionnaire?.email ?? 'Enseignant';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            leading: const CircleAvatar(
              maxRadius: 30,
              minRadius: 30,
              backgroundColor: TColors.firstcolor,
              child: Icon(
                Icons.person,
                size: 35,
              ),
            ),
            onTap: () => _openStudentDetailPage(context),
            title: Text(
              '$FonctionnairePrenom $Fonctionnairenom',
              style: const TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              Fonctionnairemail,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Divider(),
        )
      ],
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(
        onTap: () => Provider.of<AuthenticationProvider>(context, listen: false)
            .logout(context),
        leading: const Icon(
          Icons.logout,
          size: 35,
        ),
        title: Text(
          S.of(context).logout,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
