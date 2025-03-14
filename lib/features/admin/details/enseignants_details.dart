import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/details/attendance_details_page_Enseignant.dart';
import 'package:attendance_appschool/features/admin/widgets/detailscolumn.dart';
import 'package:attendance_appschool/features/admin/widgets/detailsrowarabic.dart';
import 'package:attendance_appschool/features/admin/widgets/detaliscolumnarabic.dart';
import 'package:attendance_appschool/models/ElementItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../util/constant/colors.dart';

class ShowEnseignantDetails extends StatefulWidget {
  final int enseignantid;
  final String cin;
  final String nom;
  final String? gender;
  final String prenom;
  final String email;
  final String phonenumberl;
  final String dateofbirth;
  const ShowEnseignantDetails({super.key, required this.cin, required this.nom, this.gender, required this.prenom, required this.email, required this.enseignantid,required this.phonenumberl, required this.dateofbirth});

  @override
  State<ShowEnseignantDetails> createState() => _ShowEnseignantDetailsState();
}

class _ShowEnseignantDetailsState extends State<ShowEnseignantDetails> {
  DateTime? selectedDate;
  late DBHelper dbHelper;
  late Future<List<Map<String, dynamic>>> attendanceHistoryFuture;
  String? selectedElement = "Sélectionner l'élément";
  List<String> elements = ["Sélectionner l'élément"];
  int? selectedElementId;
  late List<ElementItem> elementItems = [];
  late List<ElementItem> enseignantElementItems = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    attendanceHistoryFuture = _loadAttendanceHistory();
    loadElement();
    loadEnseignantElement();
  }

  Future<List<Map<String, dynamic>>> _loadAttendanceHistory() async {
    return dbHelper.getAttendanceHistoryForEnseignant(widget.enseignantid);
  }
  void naviguerVersDetails(int idHistoriquePresence) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceDetailsEnseignantPage(attendanceHistoryId: idHistoriquePresence),
      ),
    );
  }
  void loadElement() async {
    List<Map<String, dynamic>> elementsFromDb = await dbHelper.getElementTableWithModuleNames();

    setState(() {
      elements.clear();
      elements.add("Sélectionner l'élément");
      for (var elementMap in elementsFromDb) {
        if (elementMap.containsKey(DBHelper.ELEMENT_NAME) &&
            elementMap.containsKey(DBHelper.ELEMENT_ID) &&
            elementMap.containsKey(DBHelper.MODULE_NAME)) {
          String elementName = elementMap[DBHelper.ELEMENT_NAME] ?? '';
          String moduleName = elementMap[DBHelper.MODULE_NAME] ?? '';
          String fullName = '$moduleName - $elementName';
          elements.add(fullName);
        } else {
          print('Invalid element map: $elementMap');
        }
      }
    });
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

  void loadEnseignantElement() async {
    List<Map<String, dynamic>> enseignantElements =
    await dbHelper.getEnseignantElementTable(widget.enseignantid);

    setState(() {
      enseignantElementItems.clear();
      for (var elementMap in enseignantElements) {
        if (elementMap.containsKey(DBHelper.ENSEIGNANT_ELEMENT_ID) &&
            elementMap.containsKey(DBHelper.ELEMENT_ID)) {
          int elementId = elementMap[DBHelper.ELEMENT_ID];
          dbHelper.getElementDetails(elementId).then((elementDetails) {
            if (elementDetails != null) {
              String elementName = elementDetails[DBHelper.ELEMENT_NAME] ?? '';
              int moduleId = elementDetails[DBHelper.MODULE_ID] ?? 0;
              ElementItem elementItem =
              ElementItem(id: elementId, name: elementName, moduleId: moduleId);

              setState(() {
                enseignantElementItems.add(elementItem);
              });
            } else {
              print('Element details not found for id: $elementId');
            }
          }).catchError((error) {
            print('Error fetching element details: $error');
          });
        } else {
          print('Invalid enseignant element map: $elementMap');
        }
      }
    });
  }

  Future<dynamic> showDialogAddElement(BuildContext context) async {
    int selectedElementId = 0;
    List<Map<String, dynamic>> elementsFromDb = await dbHelper.getElementTableWithModuleNames();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Ajouter un élément à l'enseignant",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedElement,
                  isExpanded: true,
                  items: elements.map((String elementName) {
                    return DropdownMenuItem<String>(
                      value: elementName,
                      child: Text(
                        elementName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedElement = value;
                      // You might want to extract the elementId from elementsFromDb based on selectedElement
                      // For simplicity, I'm assuming the selectedElement is in the form of "Module Name - Element Name"
                      selectedElementId = elementsFromDb.firstWhere((elementMap) =>
                      '${elementMap[DBHelper.MODULE_NAME]} - ${elementMap[DBHelper.ELEMENT_NAME]}' == value)[DBHelper.ELEMENT_ID];
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sélectionner l\'élément',
                    labelStyle: TextStyle(fontSize: 25, color: Colors.grey),
                    hintStyle: TextStyle(fontSize: 25, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA5A9AC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: TColors.firstcolor),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: TColors.firstcolor,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedElementId != 0) {
                          int enseignantId = widget.enseignantid;
                          int? result = await dbHelper.addElementToEnseignant(enseignantId, selectedElementId);
                          if (result! > 0) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Élément ajouté avec succès à l'enseignant"),
                              ),
                            );
                            // Reload enseignant elements after adding
                            loadEnseignantElement();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Erreur lors de l'ajout de l'élément à l'enseignant"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez sélectionner un élément'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.firstcolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      child: const Text(
                        'Ajouter',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom:const TabBar(
            labelColor: TColors.firstcolor,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: TColors.firstcolor,
            indicatorPadding: EdgeInsets.symmetric(vertical: -10),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.class_rounded,
                  size: 30,
                ),
                text: "Détails",
              ),
              Tab(
                icon: Icon(
                  Icons.class_outlined,
                  size: 30,
                ),
                text: "Vos éléments",
              ),
              Tab(
                icon: Icon(
                  Icons.class_outlined,
                  size: 30,
                ),
                text: "Historique d'absence",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _enseignantdetailsCard(),
            _elementsCard(),
              _attendanceHistoryCard(),
          ],
        ),
      ),
    );
  }

  Widget _elementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Vos éléments",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined, size: 45, color: TColors.firstcolor),
                onPressed: () {
                  showDialogAddElement(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              child: enseignantElementItems.isEmpty
                  ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Hidden mining-rafiki.png',
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Aucun éléments",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 26,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.normal,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Veuillez sélectionner un élément",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 26,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.normal,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: enseignantElementItems.length,
                itemBuilder: (context, index) {
                  final elementItem = enseignantElementItems[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        elementItem.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,size: 35,color: Colors.red,),
                        onPressed: () async {
                          int enseignantElementId = elementItem.id;
                          int? result = await dbHelper.removeEnseignantElement(enseignantElementId);
                          if (result > 0) {
                            showToast("Élément supprimé avec succès de l'enseignant");
                            // Reload enseignant elements after deletion
                            loadEnseignantElement();
                          } else {
                            showToast("Erreur lors de la suppression de l'élément de l'enseignant");
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceHistoryCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Les enregistrements des présences",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, size: 30),
                onPressed: () {
                  selectionnerDate(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side:const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: attendanceHistoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  } else {
                    final historiquePresence = snapshot.data!;
                    if (historiquePresence.isEmpty) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Image.asset(
                                'assets/File searching-rafiki.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Aucun enregistrement de présence disponible',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 32,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemCount: historiquePresence.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => naviguerVersDetails(historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_ID]),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFfaf2ea),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(9),
                                          color: const Color(0xFFfae7d6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat.d().format(DateTime.parse(historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_DATE])),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: TColors.firstcolor,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  DateFormat.MMM().format(DateTime.parse(historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_DATE])),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: TColors.firstcolor,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
                                      children: <Widget>[
                                        Text(
                                          'Enregistrement de présence ${historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_ID]}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat.EEEE().format(DateTime.parse(historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_DATE])),
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
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              DateFormat.Hm().format(DateTime.parse(historiquePresence[index][DBHelper.ATTENDANCE_HISTORY_DATE])),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 106,
                                    ),
                                    const Icon(Icons.chevron_right, size: 40, color: TColors.firstcolor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _enseignantdetailsCard(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("détails sur l'étudiant",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){}, icon: const Icon(
                  Icons.mode_edit_outline_outlined,
                size: 40,
                color:TColors.firstcolor,
              ))
            ],
          ),
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
                        titlefr:"la carte nationale d'identité",
                        titlear:"لبطاقة الوطنية للتعريف",
                        subtitle: widget.cin,
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
                        subtitle: widget.phonenumberl, // Assurez-vous que 'widget.phoneNumber' contient le numéro de téléphone
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

