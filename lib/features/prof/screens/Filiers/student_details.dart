import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/widgets/detailscolumn.dart';
import 'package:attendance_appschool/features/admin/widgets/detailsrowarabic.dart';
import 'package:attendance_appschool/features/admin/widgets/detaliscolumnarabic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../util/constant/colors.dart';


class ShowStudentEnseignatDetails extends StatefulWidget {
  final int studentid;
  final String massar;
  final String nom;
  final String? gender;
  final String prenom;
  final String email;
  final String phonenuber;
  final String dateofbirth;
  const ShowStudentEnseignatDetails({super.key, required this.massar, required this.nom, this.gender, required this.prenom, required this.email, required this.studentid,required this.phonenuber,required this.dateofbirth});

  @override
  State<ShowStudentEnseignatDetails> createState() => _ShowEnseignantDetailsState();
}

class _ShowEnseignantDetailsState extends State<ShowStudentEnseignatDetails> {
  late DBHelper dbHelper;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }




  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,

      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(
            Icons.chevron_left,size: 40,color: TColors.firstcolor,
          ),),
        backgroundColor: TColors.white,
      ),
      body: _studentdetailsCard(),
    );
  }
  Widget _studentdetailsCard(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("détails sur l'étudiant",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
          const SizedBox(height: 26,),
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        details_column(title:"Nom de famille",subtitle: widget.nom ,),
                        details_column_arabic(title:"اسم العائلة",subtitle: widget.nom ,),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        details_column(title:"Prénom",subtitle:widget.prenom ,),
                        details_column_arabic(title:"الاسم الأول",subtitle: widget.prenom ,),

                      ],
                    ),
                  ),
                  Expanded(
                      child: details_row_arabic(
                        titlefr:"Code massar",
                        titlear:"رمز مسار",
                        subtitle: widget.massar,
                      )
                  ),

                  Expanded(
                      child: details_row_arabic(
                        titlefr:"Date de naissance",
                        titlear:"تاريخ الميلاد",
                        subtitle: widget.dateofbirth,
                      )
                  ),
                  Expanded(
                      child: details_row_arabic(
                        titlefr:"Courriel",
                        titlear:"بريد إلكتروني",
                        subtitle: widget.email,
                      )
                  ),
                  Expanded(
                      child: details_row_arabic(
                        titlefr: "Numéro de téléphone",
                        titlear: "رقم الهاتف",
                        subtitle: widget.phonenuber, // Assurez-vous que 'widget.phoneNumber' contient le numéro de téléphone
                      )
                  ),
                  Expanded(
                      child: details_row_arabic(
                        titlefr: "Genre",
                        titlear: "جنس",
                        subtitle: widget.gender.toString(), // Assurez-vous que 'widget.phoneNumber' contient le numéro de téléphone
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

