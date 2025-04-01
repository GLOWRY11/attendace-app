import 'package:flutter/material.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import '../../../../navigation_menu_prof.dart';

class AbsenceSuccessPage extends StatelessWidget {
  const AbsenceSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building AbsenceSuccessPage');
    return Scaffold(
      backgroundColor: TColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 150,
              color: Color(0xFF00A223),
            ),
            const SizedBox(height: 36,),
            const Text(
              textAlign: TextAlign.center,
              "Sauvegarde des données d'absence réussie !",style: TextStyle(fontSize: 40 , color: Colors.grey,fontWeight: FontWeight.bold),),
            const SizedBox(height: 36,),
            ElevatedButton(
              onPressed: () {
                debugPrint('Navigating to NavigationMenuProf');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavigationMenuProf()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.firstcolor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Retour à l\'accueil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
