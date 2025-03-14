import 'package:attendance_appschool/features/admin/widgets/detailscolumn.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../provider/AuthenticationProvider.dart';
import '../../../admin/widgets/detailsrowarabic.dart';
import '../../../admin/widgets/detaliscolumnarabic.dart';
import '../widgets/app_drawer.dart';

class EnseignantsDetails extends StatefulWidget {
  const EnseignantsDetails({
    super.key,
  });

  @override
  _EnseignantsDetailsState createState() => _EnseignantsDetailsState();
}

class _EnseignantsDetailsState extends State<EnseignantsDetails> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final Enseignantnom =
        authProvider.authenticatedEnseignant?.nom ?? 'Enseignant';
    final EnseignantPrenom =
        authProvider.authenticatedEnseignant?.prenom ?? 'Enseignant';
    final Enseignantcin =
        authProvider.authenticatedEnseignant?.cin ?? 'Enseignant';
    final Enseignantmail =
        authProvider.authenticatedEnseignant?.email ?? 'Enseignant';
    final Enseignantgender =
        authProvider.authenticatedEnseignant?.gender ?? 'Enseignant';
    final Enseignantphone =
        authProvider.authenticatedEnseignant?.phonenumber ?? 'Enseignant';
    final Enseignantdateofbirth =
        authProvider.authenticatedEnseignant?.dateofbirth ?? 'Enseignant';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: TColors.white,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
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
      drawer: const AppDrawerProf(),
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
                        details_column(title:"Nom de famille", subtitle: Enseignantnom),
                        details_column_arabic(title:"اسم العائلة", subtitle: Enseignantnom),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        details_column(title:"Prénom", subtitle: EnseignantPrenom),
                        details_column_arabic(title:"الاسم الأول", subtitle: EnseignantPrenom),
                      ],
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"la carte nationale d'identité",
                      titlear:"لبطاقة الوطنية للتعريف",
                      subtitle: Enseignantcin,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"Date de naissance",
                      titlear:"تاريخ الميلاد",
                      subtitle: Enseignantdateofbirth,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr:"Courriel",
                      titlear:"بريد إلكتروني",
                      subtitle: Enseignantmail,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr: "Numéro de téléphone",
                      titlear: "رقم الهاتف",
                      subtitle: Enseignantphone,
                    ),
                    const SizedBox(height: 16),
                    details_row_arabic(
                      titlefr: "Genre",
                      titlear: "جنس",
                      subtitle: Enseignantgender,
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
