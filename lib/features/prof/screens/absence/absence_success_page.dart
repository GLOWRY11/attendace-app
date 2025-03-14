import 'package:flutter/material.dart';

import '../../../../navigation_menu_prof.dart';


class AbsenceSuccessPage extends StatelessWidget {
  const AbsenceSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Verified-amico.png',height: MediaQuery.of(context).size.height/2,),
            const SizedBox(height: 36,),
            const Text(
              textAlign: TextAlign.center,
              "Sauvegarde des données d'absence réussie !",style: TextStyle(fontSize: 40 , color: Colors.grey,fontWeight: FontWeight.bold),),
            const SizedBox(height: 36,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>const NavigationMenuProf()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF00A223),
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist_rtl, size: 40, color: Colors.white),
                    SizedBox(width: 27),
                    Text(
                      "Fin de l'enregistrement d'absence",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )],
        ),
      ),
    );
  }
}
