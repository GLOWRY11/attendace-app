          import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/prof/screens/history/attendance_details_page.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
          import 'package:intl/date_symbol_data_local.dart';
          import 'package:intl/intl.dart';

          class AttendanceHistoryPageParseance extends StatefulWidget {
            final int cid;
            const AttendanceHistoryPageParseance({super.key, required this.cid});

            @override
            State<AttendanceHistoryPageParseance> createState() => _AttendanceHistoryPageState();
          }

          class _AttendanceHistoryPageState extends State<AttendanceHistoryPageParseance> {
            DateTime? selectedDate;
            late DBHelper dbHelper;
            late Future<List<Map<String, dynamic>>> attendanceHistoryFuture;



            @override
            void initState() {
              super.initState();
              initializeDateFormatting('fr_FR', null);
              dbHelper = DBHelper();
              attendanceHistoryFuture = _loadAttendanceHistory();

            }

            Future<List<Map<String, dynamic>>> _loadAttendanceHistory() async {
              return dbHelper.getAttendanceHistoryWithDetailsForSeance(widget.cid);
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
                  backgroundColor: TColors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 40,
                      color: TColors.firstcolor,
                    ),
                  ),

                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           const Text("Les enregistrements des présences",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                           IconButton(
                             icon:const Icon(Icons.calendar_today,color:TColors.firstcolor,size: 40,),
                             onPressed: () {
                               selectionnerDate(context);
                             },
                           ),
                         ],
                       ),
                      const SizedBox(height: 16,),
                      Expanded(
                          child:FutureBuilder<List<Map<String, dynamic>>>(
                            future: attendanceHistoryFuture,
                            builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                return Center(child: Text('Erreur : ${snapshot.error}'));
                                } else {
                                        final historiquePresence = snapshot.data!;
                                        if (historiquePresence.isEmpty) {
                                        return Center(
                                          child:Container(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 1, color: Color(0xFFA5A9AC)),
                                                borderRadius: BorderRadius.circular(9),
                                              ),
                                            ),
                                            width: double.infinity,
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width /2,
                                                child: Image.asset(
                                                  'assets/Hidden mining-rafiki.png', // Replace 'your_image.png' with the path to your image asset
                                                  fit: BoxFit.contain, // You can adjust the fit property as needed
                                                  // Adjust width and height as needed
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'Aucun enregistrement de présence disponible',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 32,
                                                  fontFamily: 'Sarala',
                                                  fontWeight: FontWeight.normal,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                                                                    ),
                                          ),);
                                        }
                                        return ListView.separated(
                                        separatorBuilder: (context, index) =>const SizedBox(height: 16,),
                                        itemCount: historiquePresence.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:(context, index) {
                                          final attendanceRecord = historiquePresence[index];

                                          return GestureDetector(
                                            onTap: () => naviguerVersDetails(attendanceRecord[DBHelper.ATTENDANCE_HISTORY_ID]),
                                            child: Container(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1, color: Color(0xFFA5A9AC)),
                                                  borderRadius: BorderRadius.circular(9),
                                                ),
                                              ),
                                              width: double.infinity,
                                              child:Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9),
                                                            color:const Color(0xFFfae7d6),
                                                          ),
                                                          child:   Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment .spaceBetween,
                                                            children:<Widget> [
                                                              Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(DateFormat.d().format(DateTime.parse(attendanceRecord[DBHelper.ATTENDANCE_HISTORY_DATE])), textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        color: TColors.firstcolor,
                                                                        fontFamily: 'Sarala',
                                                                        fontSize: 28,
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 1
                                                                    ),),
                                                                  const SizedBox(height: 10),

                                                                  Text(
                                                                    DateFormat.MMM().format(DateTime.parse(attendanceRecord[DBHelper.ATTENDANCE_HISTORY_DATE])),
                                                                    textAlign: TextAlign.center,
                                                                    style: const TextStyle(
                                                                        color:TColors.firstcolor,
                                                                        fontFamily: 'Sarala',
                                                                        fontSize: 28,
                                                                        fontWeight: FontWeight.normal,
                                                                        height: 1
                                                                    ),),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children:<Widget> [
                                                                Text(
                                                                  '${attendanceRecord['filiere_nom']}',
                                                                  textAlign: TextAlign.center, style:const TextStyle(
                                                                  color:Colors.black,
                                                                  fontSize: 30,
                                                                  letterSpacing: 0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      DateFormat.EEEE().format(DateTime.parse(attendanceRecord[DBHelper.ATTENDANCE_HISTORY_DATE])),
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: Colors.black,
                                                                          fontFamily: 'Sarala',
                                                                          fontSize:25,
                                                                          letterSpacing: 0 ,
                                                                          fontWeight: FontWeight.normal,
                                                                          height: 1
                                                                      ),),

                                                                    const SizedBox(
                                                                      width: 16,
                                                                    ),
                                                                    Text(
                                                                      DateFormat.Hm().format(DateTime.parse(attendanceRecord[DBHelper.ATTENDANCE_HISTORY_DATE])), // Format the time
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'Sarala',
                                                                        fontSize: 25,
                                                                        letterSpacing: 0,
                                                                        fontWeight: FontWeight.normal,
                                                                        height: 1,
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        );
                                        }
                            }
                      ),),
                    ],
                  ),
                ),
              );
            }
            Future<void> selectionnerDate(BuildContext context) async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: TColors.firstcolor, // Color of the date picker header
                        onPrimary: Colors.white, // Text color of the date picker header
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            }
            void naviguerVersDetails(int idHistoriquePresence) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailsPage(attendanceHistoryId: idHistoriquePresence),
                ),
              );
            }
          }
