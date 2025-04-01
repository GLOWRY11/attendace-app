import 'package:attendance_appschool/features/prof/screens/absence/absence_page.dart';
import 'package:attendance_appschool/features/prof/screens/absence/absence_qr_code.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class AbsenceChosePage extends StatefulWidget {
  final String moduleName;
  final String subjectName;
  final int cid;
  final int filierid;
  final DateTime? selectedDate;
  final DateTime? startAbsenceDateTime;
  final String? selectedDuration;
  final String? selectedClass;
  final int idenseignants;

  const AbsenceChosePage({super.key, required this.moduleName, required this.subjectName, required this.cid, this.selectedDate, this.startAbsenceDateTime, this.selectedDuration, this.selectedClass,required this.filierid,required this.idenseignants});

  @override
  State<AbsenceChosePage> createState() => _AbsenceChosePageState();
}

class _AbsenceChosePageState extends State<AbsenceChosePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: TColors.white,
      appBar: AppBar(
        backgroundColor: TColors.white,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(
            Icons.chevron_left,size: 40,color: TColors.firstcolor,
          ),),
      ),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Veuillez choisir un système de présence avec lequel travailler",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 56,),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbsenceQrCodePage(
                        moduleName: widget.moduleName,
                        subjectName: widget.subjectName,
                        cid: widget.cid,
                        filierid: widget.filierid,
                        selectedDate: widget.selectedDate,
                        selectedDuration: widget.selectedDuration,
                        selectedClass: widget.selectedClass,
                        startAbsenceDateTime:widget.startAbsenceDateTime,
                        idenseignants: widget.idenseignants,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width /3,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    color: TColors.firstcolor
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2,size: 220,color: Colors.white,),
                      Text(
                        "Scan",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ],
                  ),
                ),
                            ),
              ),
              const SizedBox(height: 56,),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbsencePage(
                        moduleName: widget.moduleName,
                        subjectName: widget.subjectName,
                        cid: widget.cid,
                        filierid: widget.filierid,
                        selectedDate: widget.selectedDate,
                        selectedDuration: widget.selectedDuration,
                        selectedClass: widget.selectedClass,
                        startAbsenceDateTime:widget.startAbsenceDateTime,
                        idenseignants: widget.idenseignants,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width /3,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      color: TColors.firstcolor
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Raising hand-pana.png', // Replace this URL with your image URL
                          fit: BoxFit.contain, // You can adjust the fit property as needed
                        ),
                        const Text(
                          "manuelle",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
