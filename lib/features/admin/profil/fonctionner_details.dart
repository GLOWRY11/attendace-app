import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../provider/AuthenticationProvider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/detailscolumn.dart';
import '../widgets/detailsrowarabic.dart';
import '../widgets/detaliscolumnarabic.dart';

class FonctionnerDetails extends StatefulWidget {
  const FonctionnerDetails({
    super.key,
  });

  @override
  _FonctionnerDetailsState createState() => _FonctionnerDetailsState();
}

class _FonctionnerDetailsState extends State<FonctionnerDetails> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final fonctionnernom =
        authProvider.authenticatedFonctionnaire?.nom ?? 'Fonctionnaire';
    final fonctionnerPrenom =
        authProvider.authenticatedFonctionnaire?.prenom ?? 'Fonctionnaire';
    final fonctionnercin =
        authProvider.authenticatedFonctionnaire?.cin ?? 'Fonctionnaire';
    final fonctionnermail =
        authProvider.authenticatedFonctionnaire?.email ?? 'Fonctionnaire';
    final fonctionnermobile =
        authProvider.authenticatedFonctionnaire?.phonenumber ?? 'Fonctionnaire';
    final fonctionnergender =
        authProvider.authenticatedFonctionnaire?.gender ?? 'Fonctionnaire';
    final fonctionnerdateofbirth =
        authProvider.authenticatedFonctionnaire?.dateofbirth ?? 'Fonctionnaire';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: TColors.white,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .logout(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
              size: 45,
            ),
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: TColors.firstcolor,
              size: 45,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Votre information",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 26,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        details_column(title:"Nom de famille", subtitle: fonctionnernom),
                        details_column_arabic(title:"اسم العائلة", subtitle: fonctionnernom),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        details_column(title:"Prénom", subtitle: fonctionnerPrenom),
                        details_column_arabic(title:"الاسم الأول", subtitle: fonctionnerPrenom),
                      ],
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"la carte nationale d'identité",
                      titlear:"لبطاقة الوطنية للتعريف",
                      subtitle: fonctionnercin,
                    ),
                     const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"Date de naissance",
                      titlear:"تاريخ الميلاد",
                      subtitle: fonctionnerdateofbirth,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"Courriel",
                      titlear:"بريد إلكتروني",
                      subtitle: fonctionnermail,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr: "Numéro de téléphone",
                      titlear: "رقم الهاتف",
                      subtitle: fonctionnermobile,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr: "Genre",
                      titlear: "جنس",
                      subtitle: fonctionnergender,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
