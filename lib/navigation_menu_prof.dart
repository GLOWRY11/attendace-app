import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

import 'features/prof/screens/Filiers/Filiere_pages.dart';
import 'features/prof/screens/class/class_screen.dart';
import 'features/prof/screens/home/home_page.dart';
import 'features/prof/screens/profil/prof_details.dart';

class NavigationMenuProf extends StatefulWidget {
  const NavigationMenuProf({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}


class _NavigationMenuState extends State<NavigationMenuProf> {
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
          NavigationDestination(icon: Icons.home,label: S.of(context).home),
          NavigationDestination(
              icon: Icons.share_arrival_time, label: 'Séance'),
          NavigationDestination(
              icon: Icons.group, label: 'Filières'),
          NavigationDestination(icon: Icons.person, label: S.of(context).profile_space),
        ],
      ),
      body: _getContainer(selectedIndex), // Call _getContainer method
    );
  }

  Widget _getContainer(int index) {
    switch (index) {
      case 0:
        return const HomePageScreenProf(); // Return HomeScreen widget for index 0
      case 1:
        return const ClassScreen(); // Return appropriate widget for other indices
      case 2:
        return const EspaceFiliereProf();
      case 3:
        return const EnseignantsDetails();
      default:
        return const HomePageScreenProf();
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
