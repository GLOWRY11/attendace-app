import 'package:attendance_appschool/features/admin/espace/espace_enseignants.dart';
import 'package:attendance_appschool/features/admin/espace/espace_filier.dart';
import 'package:attendance_appschool/features/admin/home/home_page.dart';
import 'package:attendance_appschool/features/admin/profil/fonctionner_details.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class NavigationMenuAdmin extends StatefulWidget {
  const NavigationMenuAdmin({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenuAdmin> {
  int selectedIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        destinations: [
          NavigationDestination(icon: Icons.home, label: S.of(context).home),
          NavigationDestination(icon: Icons.school_sharp, label: S.of(context).espace_enseignants),
            NavigationDestination(icon: Icons.group, label: S.of(context).major_space),
          NavigationDestination(icon: Icons.person_outline, label: S.of(context).profile_space),
        ],
      ),
      body: _getContainer(selectedIndex), // Call _getContainer method
    );
  }

  Widget _getContainer(int index) {
    switch (index) {
      case 0:
        return const HomePageScreen(); // Return HomeScreen widget for index 0
      case 1:
        return const EspaceEnsgeint(); // Return appropriate widget for other indices
      case 2:
        return const EspaceFiliere();
      case 3:
        return const FonctionnerDetails();
      default:
        return const FonctionnerDetails();
    }
  }
}

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;

  const NavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      backgroundColor: Colors.white,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: destinations
          .map((destination) => BottomNavigationBarItem(
        backgroundColor: Colors.white,
                icon: Icon(
                  destination.icon,
                  size: 35,
                  color: TColors.firstcolor,
                ),
                label: destination.label,
              ))
          .toList(),
      selectedItemColor: TColors.firstcolor,
      selectedLabelStyle: const TextStyle(
        fontSize:22
      ),
    );
  }
}

class NavigationDestination {
  final IconData icon;
  final String label;

  NavigationDestination({required this.icon, required this.label});
}
