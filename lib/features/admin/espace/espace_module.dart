import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/espace/show_element_of_module.dart';
import 'package:attendance_appschool/features/admin/widgets/app_drawer.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/models/ElementItem.dart';
import 'package:attendance_appschool/models/ModuleItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../util/constant/colors.dart';

class AddModuleElementPage extends StatefulWidget {
  const AddModuleElementPage({super.key});

  @override
  State<AddModuleElementPage> createState() => _AddModuleElementPageState();
}

class _AddModuleElementPageState extends State<AddModuleElementPage> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;
  late TextEditingController moduleNameController;
  late TextEditingController elementNameController;
  late List<ModuleItem> moduleItems = [];
  late List<ElementItem> elementItems = [];
  ModuleItem? selectedModuleName;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadDataModule();
    moduleNameController = TextEditingController();
    elementNameController = TextEditingController();
    loadDataElement();
  }

  void loadDataElement() async {
    List<Map<String, dynamic>>? elemenets = await dbHelper.getElementTable();
    List<ElementItem> loadedElementItems = [];
    for (var elemenetsMap in elemenets) {
      if (elemenetsMap.containsKey(DBHelper.ELEMENT_ID) &&
          elemenetsMap.containsKey(DBHelper.ELEMENT_NAME) &&
          elemenetsMap.containsKey(DBHelper.MODULE_ID)) {
        int elementId = elemenetsMap[DBHelper.ELEMENT_ID] ?? 0;
        String moduleName = elemenetsMap[DBHelper.ELEMENT_NAME] ?? '';
        int moduleId = elemenetsMap[DBHelper.MODULE_ID] ?? 0;
        loadedElementItems.add(
            ElementItem(id: elementId, moduleId: moduleId, name: moduleName));
      } else {
        print('Invalid element map: $elemenetsMap');
      }
    }
    setState(() {
      elementItems = loadedElementItems;
    });
  }

  void addElement(ModuleItem selectedModule, String elementName) async {
    if (elementName.isNotEmpty) {
      int? elementId =
          await dbHelper.addElement(selectedModule.moduleId, elementName);
      setState(() {
        ElementItem elementItem = ElementItem(
          id: elementId ?? 0,
          moduleId: selectedModule.moduleId,
          name: elementName,
        );
        elementItems.add(elementItem);
      });
        } else {
      showToast(
          "Veuillez entrer le nom de l'élément et sélectionner un module.");
    }
  }

  void addModule(String moduleName) async {
    if (moduleName.isNotEmpty) {
      int? moduleId = await dbHelper.addModule(moduleName);
      setState(() {
        // Create a new ClassItem instance for the module
        ModuleItem moduleItem = ModuleItem(
          moduleId: moduleId ?? 0, // Assuming the module ID can be used as the cid
          moduleName: moduleName,
        );
        moduleItems.add(moduleItem); // Add the module to the list
      });
        } else {
      showToast("Veuillez entrer le nom du module.");
    }
  }

  void loadDataModule() async {
    List<Map<String, dynamic>>? modules = await dbHelper.getModuleTable();
    List<ModuleItem> loadedModuleItems = [];
    for (var moduleMap in modules ?? []) {
      if (moduleMap.containsKey(DBHelper.MODULE_ID) &&
          moduleMap.containsKey(DBHelper.MODULE_NAME)) {
        int moduleId = moduleMap[DBHelper.MODULE_ID] ?? 0;
        String moduleName = moduleMap[DBHelper.MODULE_NAME] ?? '';
        loadedModuleItems
            .add(ModuleItem(moduleId: moduleId, moduleName: moduleName));
      } else {
        print('Invalid module map: $moduleMap');
      }
    }
    setState(() {
      moduleItems = loadedModuleItems;
    });
    }

  Widget _moduleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 26,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gérer les modules',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: 'Sarala',
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    buildShowDialogAddModule(context);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(TColors.firstcolor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        S.of(context).ajoutee,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Sarala',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            '${moduleItems.length} Total des modules',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 28,
              fontFamily: 'Sarala',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: moduleItems.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/File searching-cuate.png',
                            width: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Aucun module",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 26,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.normal,
                              height: 0,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Veuillez ajouter un module",
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
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                          height: 16), // Adjust the height as needed
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(16),
                      itemCount: moduleItems.length,
                      itemBuilder: (context, index) {
                        final moduleItem = moduleItems[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset: const Offset(
                                    0, 3), // Offset in x and y directions
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.class_,
                                    size: 80,
                                    color: TColors.firstcolor,
                                  ),
                                  const SizedBox(width: 17),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        moduleItem.moduleName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowElementOfModule(
                                            moduleId: moduleItem.moduleId,
                                            modleName: moduleItem.moduleName,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          moduleItem.moduleId);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
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

  void _showDeleteConfirmationDialogElement(int elementId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Supprimer l'élément",
            style: TextStyle(
              color: TColors.firstcolor,
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir supprimer cet élément ?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
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
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeElement(elementId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: TColors.firstcolor,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                side: const BorderSide(color: TColors.firstcolor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: const Text(
                'Supprimer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int moduleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Supprimer le modul",
            style: TextStyle(
              color: TColors.firstcolor,
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir supprimer cet module ?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
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
            ElevatedButton(
              onPressed: () {
                removeModule(moduleId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: TColors.firstcolor,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                side: const BorderSide(color: TColors.firstcolor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: const Text(
                'Supprimer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void removeModule(int moduleId) async {
    setState(() {
      moduleItems.removeWhere((module) => module.moduleId == moduleId);
    });
    await dbHelper.deleteModule(moduleId);
  }

  void removeElement(int elementId) async {
    setState(() {
      elementItems.removeWhere((element) => element.id == elementId);
    });
    await dbHelper.deleteElement(elementId);
  }

  Widget _elementCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 26,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gérer les éléments du modèle',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: 'Sarala',
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    buildShowDialogAddElemet(context);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(TColors.firstcolor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Ajoutée',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Sarala',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            '${elementItems.length} Total des éléments',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 28,
              fontFamily: 'Sarala',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: elementItems.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/File searching-cuate.png',
                            width: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Aucun élément",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 26,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.normal,
                              height: 0,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Veuillez ajouter un élément",
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
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                          height: 16), // Adjust the height as needed
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      scrollDirection: Axis.vertical,
                      itemCount: elementItems.length,
                      itemBuilder: (context, index) {
                        final elementItem = elementItems[index];
                        return FutureBuilder<String>(
                          future: dbHelper.getModuleName(elementItem.moduleId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                return Text('Erreur: ${snapshot.error}');
                              } else {
                                final moduleName = snapshot.data ?? '';
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 20),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.class_outlined,
                                            size: 70,
                                            color: TColors.firstcolor,
                                          ),
                                          const SizedBox(width: 17),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                elementItem.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.bold,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                moduleName,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showDeleteConfirmationDialogElement(
                                              elementItem.id);
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowDialogAddElemet(BuildContext context) {
    ModuleItem? selectedModule;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Ajouter un element',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,

              // Adjust the height as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ModuleItem>(
                    value: selectedModule,
                    isExpanded: true,
                    items: moduleItems.map((module) {
                      return DropdownMenuItem<ModuleItem>(
                        value: module,
                        child: Text(
                          module.moduleName,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedModule = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.class_outlined),
                      labelText: 'Nom de module',
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 28),
                    controller: elementNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.class_outlined),
                      labelText: 'Nom de l\'élément',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez fournir un nom de module';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 36,
                  ),
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
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (elementNameController.text.isNotEmpty &&
                              selectedModule != null) {
                            addElement(
                                selectedModule!, elementNameController.text);
                            Navigator.pop(context);
                            elementNameController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Veuillez entrer un nom d\'élément et sélectionner un module.'),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: TColors.white,
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(
            'assets/logoestm_digital.svg',
            height: 50,
          ),
          backgroundColor: TColors.white,
          leading:IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:const Icon(
              Icons.chevron_left,size: 40,color: TColors.firstcolor,
            ),),
          bottom: const TabBar(
              labelColor: TColors.firstcolor,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              dividerColor: Colors.transparent,
              indicatorColor: TColors.firstcolor,
              indicatorPadding: EdgeInsets.symmetric(vertical: -10),
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.class_rounded, size: 30),
                  text: "Module",
                ),
                Tab(
                  icon: Icon(
                    Icons.class_outlined,
                    size: 30,
                  ),
                  text: "Element",
                ),
              ]),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          children: [
            _moduleCard(),
            _elementCard(),
          ],
        ),
      ),
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<dynamic> buildShowDialogAddModule(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Ajouter un module',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,

              // Adjust the height as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 28),
                    controller: moduleNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.class_outlined),
                      labelText: 'Nom de module',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez fournir un nom de module';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 36,
                  ),
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
                      const SizedBox(
                        height: 36,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (moduleNameController.text.isNotEmpty) {
                            addModule(moduleNameController.text);
                            Navigator.pop(context);
                            moduleNameController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Veuillez entrer un nom de module.'),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          textStyle: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(
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
          ),
        );
      },
    );
  }
}
