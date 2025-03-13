import 'package:attendance_appschool/features/prof/screens/notification/notification_page.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../../navigation_menu_prof.dart';
import '../../../settings/app_language_settings.dart';
import '../Filiers/Filiere_pages.dart';
import '../history/attendance_history_page_enseignate.dart';
import '../profil/prof_details.dart';


class AppDrawerProf extends StatelessWidget {
  const AppDrawerProf({super.key});

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
              builder: (context) => const NavigationMenuProf(),
            ),
          );
        }
      },

      {
        "title": "Filières",
        "icon": Icons.group,
        "onClick": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EspaceFiliereProf(),
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
              builder: (context) =>const AttendanceHistoryPageParEnsiegnate(),
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
              builder: (context) =>const EnseignantNotificationScreen(),
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
              builder: (context) => const EnseignantsDetails(),
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
                    style:const TextStyle(fontSize: 22),
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
    final Enseignantnom =
        authProvider.authenticatedEnseignant?.nom ?? 'Enseignant';
    final EnseignantPrenom =
        authProvider.authenticatedEnseignant?.prenom ?? 'Enseignant';
    final Enseignantmail =
        authProvider.authenticatedEnseignant?.email ?? 'Enseignant';

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
              '$EnseignantPrenom $Enseignantnom',
              style: const TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              Enseignantmail,
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
