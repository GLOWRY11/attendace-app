import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/models/AbsenceItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';


class AttendanceDetailsPage extends StatefulWidget {
  final int attendanceHistoryId;

  const AttendanceDetailsPage({super.key, required this.attendanceHistoryId});

  @override
  State<AttendanceDetailsPage> createState() => _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState extends State<AttendanceDetailsPage> {
  late DBHelper dbHelper;
  late List<AbsenceItem> absenceItems = [];
  Map<int, Map<String, String>> etudiantDetails = {};

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  void loadData() async {
    List<Map<String, dynamic>>? records =
    await dbHelper.getAbsenceRecords(widget.attendanceHistoryId);
    List<AbsenceItem> loadedAbsenceItems = [];
    for (var record in records) {
      if (record.containsKey(DBHelper.ABSENCE_ID) &&
          record.containsKey(DBHelper.ETUDIANT_ID) &&
          record.containsKey(DBHelper.IS_PRESENT) &&
          record.containsKey(DBHelper.ABSENCE_DATE) &&
          record.containsKey(DBHelper.START_TIME) &&
          record.containsKey(DBHelper.END_TIME)) {
        int absenceId = record[DBHelper.ABSENCE_ID] as int;
        int studentId = record[DBHelper.ETUDIANT_ID] as int;
        bool isPresent = (record[DBHelper.IS_PRESENT] as int) == 1;
        DateTime date = DateTime.parse(record[DBHelper.ABSENCE_DATE] as String);
        String startTime = record[DBHelper.START_TIME] as String;
        String endTime = record[DBHelper.END_TIME] as String;
        loadedAbsenceItems.add(AbsenceItem(
          id: absenceId,
          studentId: studentId,
          isPresent: isPresent,
          date: date,
          startTime: startTime,
          endTime: endTime,
        ));

        // Fetch étudiant details and store them
        try {
          Map<String, String> details =
          await dbHelper.getEtudianteDetailsById(studentId);
          etudiantDetails[studentId] = details;
        } catch (e) {
          print('Error fetching étudiant details: $e');
          etudiantDetails[studentId] = {
            'nom': 'Unknown',
            'prenom': '',
          };
        }
      } else {
        print('Invalid record: $record');
      }
    }
    setState(() {
      absenceItems = loadedAbsenceItems;
    });
  }


    void downloadExcelFile() {
    final exel = Excel.createExcel();
    exel.rename(exel.getDefaultSheet()!, "test sheet");
    Sheet sheet = exel["test sheet"];
    var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue("Index ke A1"); // Line 72 - Removed 'const'

    var cell2 = sheet.cell(CellIndex.indexByString("A2"));
    cell2.value = TextCellValue("Index ke A2"); // Line 76 - Removed 'const'


    String dir = Directory.current.path;
    String filePath = '$dir/Test_Export.xlsx';

    exel.save(fileName: filePath);
    print("Excel file saved to: $filePath");
    print(Directory.current.path);
    }
    

  @override
  Widget build(BuildContext context) {
    // Implement UI to display attendance details here
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
        backgroundColor: TColors.white,
        leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: 40,
                  color: TColors.firstcolor,
                ),
              );
            }
        ), // Translate 'Attendance Details' to French
      ),
      body: absenceItems.isEmpty
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Search-rafiki.png', // Replace 'your_image.png' with the path to your image asset
                width: 500,
                height: 500,
                // Adjust width and height as needed
              ),
              const SizedBox(width: 10),

              const Text('Aucun enregistrement de présence disponible.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 28,
                  fontFamily: 'Sarala',
                  fontWeight: FontWeight.normal,
                  height: 0,
                ),),
            ],
          )) // Translate 'No attendance records available.' to French
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Détails de présence",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                TextButton(
                  child:const Row(
                    children: [
                       Icon(Icons.install_mobile,color:Colors.green,size: 30,),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Export',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          height: 0,
                        ),
                      )

                    ],
                  ),
                  onPressed: () {
                    downloadExcelFile();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>const SizedBox(height: 16,),
                scrollDirection: Axis.vertical,
                itemCount: absenceItems.length,
                itemBuilder: (context, index) {
                  final absence = absenceItems[index];
                  final etudiantId = absence.studentId;
                  final etudiantDetail = etudiantDetails[etudiantId] ?? {'nom': 'Unknown', 'prenom': ''};
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: absence.isPresent ? Colors.green[100] : Colors.red[100], // Change color based on presence
                    ),
                    child: ListTile(
                      title: Text(
                        '${etudiantDetail['nom']} ${etudiantDetail['prenom']}',
                        style: const TextStyle(
                          fontFamily: 'Sarala',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        absence.isPresent ? 'Présent' : 'Absent', // Change text based on presence
                        style: TextStyle(
                          color: absence.isPresent ? Colors.green : Colors.red, // Change color based on presence
                          fontFamily: 'Sarala',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8,),
                           Text(
                            'Heure de début : ${absence.startTime.substring(11,16)}',
                            style:const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sarala',
                                fontSize: 25,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Text(
                            'Heure de fin : ${absence.endTime.substring(11,16)}',
                            style:const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sarala',
                                fontSize: 25,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        ),
    );
  }
}
