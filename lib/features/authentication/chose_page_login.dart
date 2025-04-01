import 'package:attendance_appschool/features/authentication/login_enseignant.dart';
import 'package:attendance_appschool/features/authentication/login_fonctionnaire.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/provider/localization_provider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

class ChosePageLogin extends StatefulWidget {
  const ChosePageLogin({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<ChosePageLogin> {
  @override
  Widget build(BuildContext context) {


    List<DropdownMenuItem<Locale>> locales =
        Provider.of<LocalizationProvider>(context)
            .supportedLocales
            .map((l) => DropdownMenuItem<Locale>(
                value: l,
                child: Text(l.languageCode,
                    style:const TextStyle(
                      fontSize: 18,
                      color: TColors.firstcolor
                    ))))
            .toList();
    Widget languagesDropDown() {
      return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            dropdownColor: Colors.white,
            items: locales,
            onChanged: (selectedLocale) {
              Provider.of<LocalizationProvider>(context, listen: false)
                  .changeLocale(selectedLocale as Locale);
            },
            value: Provider.of<LocalizationProvider>(context).currentLocale,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: languagesDropDown(),
        ),
      ]),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1100),
                      child: Center(
                        child: Image.asset(
                          "assets/logo3.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Text(
                            S.of(context).ready_to_start,
                            style: const TextStyle(
                              color: TColors.firstcolor,
                              fontSize: 35,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Text(
                            S
                                .of(context)
                                .selectionnez_une_option_ci_dessous_pour_commencer,
                            style: const TextStyle(
                              color: TColors.firstcolor,
                              fontSize: 35,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 56,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginEnsignScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  color: TColors.firstcolor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.school,
                                      size: 120,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      S.of(context).enseignant,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginFonctionnaireScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  color: TColors.firstcolor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.admin_panel_settings,
                                      size: 120,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      S.of(context).fonctionnaire,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 56,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: Center(
                        child: Text(
                          "ESTM Digital",
                          style: TextStyle(
                            color: TColors.firstcolor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          S.of(context).realisation_par,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontFamily: 'SaralaRegulair',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
