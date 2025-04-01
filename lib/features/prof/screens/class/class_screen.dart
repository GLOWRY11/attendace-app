import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
  import 'package:attendance_appschool/features/prof/screens/class/etudiante_activity.dart';
  import 'package:attendance_appschool/features/prof/screens/notification/notification_page.dart';
  import 'package:attendance_appschool/features/prof/screens/widgets/notification_icon.dart';
  import 'package:attendance_appschool/models/SeanceItem.dart';
  import 'package:attendance_appschool/models/ElementItem.dart';
  import 'package:attendance_appschool/models/ModuleItem.dart';
  import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
    import 'package:attendance_appschool/util/constant/colors.dart';
    import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:provider/provider.dart';

  import '../../../../generated/l10n.dart';
  import '../widgets/app_drawer.dart';

      class ClassScreen extends StatefulWidget {
      const ClassScreen({super.key});

      @override
      State<ClassScreen> createState() => _ClassScreenState();
    }

    class _ClassScreenState extends State<ClassScreen> {
      late DBHelper dbHelper;
      late List<SeanceItem> seanceItems = [];
      late List<ModuleItem> moduleItems = [];
      late List<ElementItem> elementItems = [];
      late List<ElementItem> selectedElements = [];
      late TextEditingController classNameController;
      late TextEditingController subjectNameController;
      late TextEditingController moduleNameController;
      late TextEditingController elementNameController;


      ModuleItem? selectedModuleName;
      ElementItem? selectedElementName;


      @override
      void initState() {
        super.initState();
        dbHelper = DBHelper();
        loadData();
        loadDataModule();
        loadDataElement();
        classNameController = TextEditingController();
        subjectNameController = TextEditingController();
        moduleNameController = TextEditingController();
        elementNameController = TextEditingController();

      }

      List<ElementItem> getElementsRelatedToModule(ModuleItem selectedModule) {
        return elementItems.where((element) => element.moduleId == selectedModule.getModuleId).toList();
      }

      onModuleSelected(ModuleItem value) {
        setState(() {
          selectedModuleName = value;
          selectedElements = getElementsRelatedToModule(value);
          selectedElementName = null;
        });
      }

      void loadData() async {
        List<Map<String, dynamic>>? seances = await dbHelper.getClassTable();
        List<SeanceItem> loadedSeanceItems = [];
for (var classMap in seances ?? []) {
            if (classMap.containsKey(DBHelper.SEANCE_ID) &&
              classMap.containsKey(DBHelper.MODULE_NAME) &&
              classMap.containsKey(DBHelper.ELEMENT_NAME) &&
              classMap.containsKey(DBHelper.ENSEIGNANT_ID) &&
              classMap.containsKey(DBHelper.SEANCE_CONTENUE)) {
            int cid = classMap[DBHelper.SEANCE_ID] ?? 0;
            String moduleName = classMap[DBHelper.MODULE_NAME] ?? '';
            String elementName = classMap[DBHelper.ELEMENT_NAME] ?? '';
            String subjectName = classMap[DBHelper.SEANCE_CONTENUE] ?? '';
            int enseignantId = classMap[DBHelper.ENSEIGNANT_ID] ?? '';
            loadedSeanceItems.add(SeanceItem(cid: cid, moduleName: moduleName, elementName: elementName,subjectName: subjectName,enseignantId:enseignantId));
          } else {
            print('Invalid class map: $classMap');
          }
        }
        setState(() {
          seanceItems = loadedSeanceItems;
        });
            }

      void loadDataModule() async {
        // Load module data from the database
        List<Map<String, dynamic>>? modules = await dbHelper.getModuleTable();
        List<ModuleItem> loadedModuleItems = [];
        for (var moduleMap in modules!) {
          print(moduleMap.containsKey(DBHelper.MODULE_ID));
          if (moduleMap.containsKey(DBHelper.MODULE_ID) && moduleMap.containsKey(DBHelper.MODULE_NAME)) {
            int moduleId = moduleMap[DBHelper.MODULE_ID] ?? 0;
            String moduleName = moduleMap[DBHelper.MODULE_NAME] ?? '';
            loadedModuleItems.add(ModuleItem(moduleId: moduleId, moduleName: moduleName));
          } else {
            print('Invalid module map: $moduleMap');
          }
        }
        setState(() {
          moduleItems = loadedModuleItems;
        });

            }
      void loadDataElement() async {
        List<Map<String, dynamic>>? elemenets = await dbHelper.getElementTable();
        List<ElementItem> loadedElementItems = [];
        for (var elemenetsMap in elemenets) {
          if (elemenetsMap.containsKey(DBHelper.ELEMENT_ID) && elemenetsMap.containsKey(DBHelper.ELEMENT_NAME) && elemenetsMap.containsKey(DBHelper.MODULE_ID)) {
            int elementId = elemenetsMap[DBHelper.ELEMENT_ID] ?? 0;
            String moduleName = elemenetsMap[DBHelper.ELEMENT_NAME] ?? '';
            int moduleId = elemenetsMap[DBHelper.MODULE_ID] ?? 0;
            loadedElementItems.add(ElementItem(id: elementId,moduleId:moduleId,name:moduleName));
          } else {
            print('Invalid element map: $elemenetsMap');
          }
        }
        setState(() {
          elementItems = loadedElementItems;
        });

          }


      void addClass(String moduleName,String elementName,String subjectName) async {
        if (moduleName.isNotEmpty && subjectName.isNotEmpty) {
          final enseignantId = Provider.of<AuthenticationProvider>(context, listen: false).authenticatedEnseignant?.id;          int? cid = await dbHelper.addSeance(moduleName,elementName,subjectName,enseignantId);
          SeanceItem seanceItem = SeanceItem(
            cid: cid ?? 0,
            moduleName: moduleName,
            elementName: elementName,
            subjectName: subjectName,
            enseignantId: enseignantId,

          );
          setState(() {
            seanceItems.add(seanceItem);
          });
        } else {
          showToast("Veuillez entrer les noms de la Séance et de la matière.");
        }
      }

      void updateSeance(int position, String moduleName, String subjectName) async {
        await dbHelper.updateSeance(seanceItems[position].cid, moduleName, subjectName);
        setState(() {
          seanceItems[position].moduleName = moduleName;
          seanceItems[position].subjectName = subjectName;
        });
      }
      void deleteSeance(int position) async {
        await dbHelper.deleteSeance(seanceItems[position].cid);
        setState(() {
          seanceItems.removeAt(position);
        });
      }
      void showToast(String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
      void gotoItemActivity(int position) {
        if (position >= 0 && position < seanceItems.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EtudianteActivity(
                moduleName: seanceItems[position].moduleName,
                subjectName: seanceItems[position].subjectName,
                cid: seanceItems[position].cid,
              ),
            ),
          );
        } else {
          showToast('Invalid item selected');
        }
      }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            TNotificationIconProf(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>const EnseignantNotificationScreen()
                    ));
              },
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

          backgroundColor: Colors.transparent,
          title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),

      ),
        drawer: const AppDrawerProf(),
        body: seanceItems.isEmpty ?
        Center(
          child: SizedBox(
            width:MediaQuery.of(context).size.width/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.class_outlined,size: 80,color: Colors.grey,),
                const SizedBox(height: 16,),
                const Text(
                  "Aucune Séance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  width:double.infinity,
                  child:ElevatedButton(
                    onPressed: () {
                      buildShowDialogAddLecon(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: TColors.firstcolor,
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.grey,
                      side: const BorderSide(color: TColors.firstcolor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    child:const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Ajouter une nouvelle séance",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mes séances",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 38,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Vos séances",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  IconButton(onPressed: (){
                    buildShowDialogAddLecon(context);
                  }, icon: const Icon(
                    Icons.add,
                    size: 40,
                  ),)
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: seanceItems.length,
                  separatorBuilder: (context, index) =>const SizedBox(height: 16), // Adjust the height as needed
                  itemBuilder: (context, index) {
                    final seanceItem = seanceItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: TColors.firstcolor,
                      ),

                      padding: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: const Icon(Icons.class_outlined,color:Colors.white,size: 50,),
                        trailing: const Icon(Icons.chevron_right,color:Colors.white,size: 50,),
                        title: Text(
                          seanceItem.getSubjectName,
                                style:const TextStyle(
                                  fontSize: 32,
                                  color:Colors.white,
                                  fontWeight: FontWeight.bold
                                ),

                        ),
                        subtitle: Row(
                          children: [
                            Text(seanceItem.getClassName,style:const TextStyle(
                                fontSize: 28,
                                color:Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(width: 36,),
                            Text(seanceItem.getElementName,style:const TextStyle(
                                fontSize: 28,
                                color:Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                        onTap: () => gotoItemActivity(index),
                        onLongPress: () {
                          showClassOptions(index);
                        },
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

    Future<dynamic> buildShowDialogAddLecon(BuildContext context) {
      return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            backgroundColor: Colors.white,
                            title: const Text(
                              'Ajouter une séance',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownButtonFormField<ModuleItem>(
                                    value: selectedModuleName,
                                    isExpanded: true,
                                    items: moduleItems.map((module) {
                                      return DropdownMenuItem<ModuleItem>(
                                        value: module,
                                        child: Text(
                                          module.moduleName,
                                          style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedModuleName = value;
                                        onModuleSelected(value!);
                                      });

                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Nom du module',

                                      labelStyle:const TextStyle(fontSize: 25, color: Colors.grey),
                                      hintStyle:const TextStyle(fontSize: 25, color: Colors.grey),
                                      enabledBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey), // Default border color
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          fontSize: 25,
                                          color: TColors.firstcolor.withOpacity(0.8)),
                                      focusedBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: TColors.firstcolor), // Color when focused
                                      ),
                                      errorBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red), // Red border when error
                                      ),
                                      focusedErrorBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red), // Red border when focused and error
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Veuillez sélectionner un module';
                                      }
                                      return null; // Return null if validation passes
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownButtonFormField<ElementItem>(
                                    value: selectedElementName,
                                    isExpanded: true,
                                    items: selectedElements.map((element) {
                                      return DropdownMenuItem<ElementItem>(
                                        value: element,
                                        child: Text(
                                          element.name,
                                          style:const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedElementName = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Nom du element',

                                      labelStyle:const TextStyle(fontSize: 25, color: Colors.grey),
                                      hintStyle:const TextStyle(fontSize: 25, color: Colors.grey),
                                      enabledBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey), // Default border color
                                      ),
                                      floatingLabelStyle: TextStyle(
                                          fontSize: 25,
                                          color: TColors.firstcolor.withOpacity(0.8)),
                                      focusedBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(color: TColors.firstcolor), // Color when focused
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red), // Red border when error
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red), // Red border when focused and error
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Veuillez sélectionner un élément';
                                      }
                                      return null; // Return null if validation passes
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    style:const TextStyle(fontSize: 28),
                                    controller: subjectNameController,
                                    decoration: InputDecoration(
                                      errorMaxLines: 3,
                                      labelStyle:const TextStyle(fontSize: 28, color: Colors.grey),
                                      hintStyle:const TextStyle(fontSize: 28, color: Colors.grey),
                                      prefixIconColor: Colors.grey,
                                      floatingLabelStyle: TextStyle(
                                          fontSize: 28,
                                          color: TColors.firstcolor.withOpacity(0.8)),
                                      prefixIcon:const Icon(Icons.class_,size: 30,color: TColors.firstcolor),
                                      labelText: 'Sous-titre de la Séance',
                                      enabledBorder:const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey), // Default color
                                      ),
                                      focusedBorder:const UnderlineInputBorder(
                                        borderSide: BorderSide(color: TColors.firstcolor), // Color when focused
                                      ),
                                    ),

                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          S.of(context).cancel,
                                          style: const TextStyle(
                                            color: TColors.firstcolor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (selectedModuleName != null && selectedElementName != null && subjectNameController.text.isNotEmpty) {
                                            String moduleName = selectedModuleName!.moduleName;
                                            String elementName = selectedElementName!.name;
                                            addClass(moduleName,elementName,subjectNameController.text);
                                            Navigator.pop(context);
                                            subjectNameController.clear();
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                               SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(S.of(context).fill_all_fields),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          foregroundColor: Colors.white,
                                          backgroundColor: TColors.firstcolor,
                                          disabledBackgroundColor: Colors.grey,
                                          disabledForegroundColor: Colors.grey,
                                          side:const BorderSide(color: TColors.firstcolor),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                          textStyle:const TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        child: Text(
                                          S.of(context).ajoutee,
                                          style: const TextStyle(
                                            fontSize: 25,
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
    void showUpdateClassDialog(int position) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9), // Apply border radius to the AlertDialog
            ),
            backgroundColor: Colors.white,
            title:const Text('Mettre à jour la séance'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: seanceItems[position].moduleName),
                  onChanged: (value) {
                    seanceItems[position].moduleName = value;
                  },
                  decoration: InputDecoration(
                      errorMaxLines: 3,
                      labelStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                      hintStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle:const TextStyle().copyWith(color:TColors.firstcolor.withOpacity(0.8)),
                      prefixIcon:const Icon(Icons.class_),
                      labelText: seanceItems[position].moduleName),
                ),
                TextField(
                  controller: TextEditingController(text: seanceItems[position].subjectName),
                  onChanged: (value) {
                    seanceItems[position].subjectName = value;
                  },
                  decoration: InputDecoration(
                      errorMaxLines: 3,
                      labelStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                      hintStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(color:Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.class_outlined),
                      labelText: seanceItems[position].subjectName),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(
                    color: TColors.firstcolor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if (seanceItems[position].moduleName.isNotEmpty && seanceItems[position].subjectName.isNotEmpty) {
                    updateSeance(position, seanceItems[position].moduleName, seanceItems[position].subjectName);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(S.of(context).fill_all_fields),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: TColors.firstcolor,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.grey,
                  side: const BorderSide(color: TColors.firstcolor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                child:const Text(
                  'Mettre à jour',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          );

        },
      );
    }
    void showClassOptions(int position) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9), // Apply border radius to the AlertDialog
            ),
            backgroundColor: Colors.white,
            title:const Text('Options de la séance'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title:const Text('Modifier la séance'),
                  onTap: () {
                    Navigator.pop(context);
                    showUpdateClassDialog(position);
                  },
                ),
                ListTile(
                  title:const Text('Supprimer la séance'),
                  onTap: () {
                    Navigator.pop(context);
                    deleteSeance(position);
                  },
                ),
              ],
            ),
          );

        },
      );
    }
  }
