import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/ElementItem.dart';

class ShowElementOfModule extends StatefulWidget {
  final int moduleId;
  final String modleName;
  const ShowElementOfModule({super.key, required this.moduleId, required this.modleName});

  @override
  State<ShowElementOfModule> createState() => _ShowElementOfModuleState();
}

class _ShowElementOfModuleState extends State<ShowElementOfModule> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;
  List<ElementItem> elementItems = [];
  late TextEditingController elementNameController;



  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    elementNameController = TextEditingController();
    loadDataElementofModule(widget.moduleId);


  }

  Future<void> loadDataElementofModule(int moduleId) async {
    List<Map<String, dynamic>>? elements = await dbHelper.getElementofModuleTable(moduleId);
    List<ElementItem> loadedElementItems = [];
    for (var elementMap in elements ?? []) {
      if (elementMap.containsKey(DBHelper.ELEMENT_ID) &&
          elementMap.containsKey(DBHelper.ELEMENT_NAME) &&
          elementMap.containsKey(DBHelper.MODULE_ID)) {
        int elementId = elementMap[DBHelper.ELEMENT_ID] ?? 0;
        String elementName = elementMap[DBHelper.ELEMENT_NAME] ?? '';
        loadedElementItems.add(ElementItem(id: elementId, moduleId: moduleId, name: elementName));
      } else {
        print('Invalid element map: $elementMap');
      }
    }
    setState(() {
      elementItems = loadedElementItems;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),
      backgroundColor: Colors.white,

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start  ,
          children: [
            const SizedBox(
              height: 26,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  'Tous les éléments de ${widget.modleName}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Sarala',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(onPressed: (){
                  buildShowDialogAddElemet(context);
                },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),                        backgroundColor: WidgetStateProperty.all<Color>(TColors.firstcolor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child:const Row(
                      children: [
                        Icon(Icons.add,color: Colors.white,size: 30,),
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
              height: 36,
            ),
            Text(
              '${elementItems.length} Total des éléments',
              textAlign: TextAlign.center,
              style:const TextStyle(
                color:Colors.grey,
                fontSize: 28,
                fontFamily: 'Sarala',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Expanded(
              child: Container(
                child: elementItems.isEmpty?
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/File searching-cuate.png', // Replace 'your_image.png' with the path to your image asset
                        width: MediaQuery.of(context).size.width/2,

                        // Adjust width and height as needed
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
                      const SizedBox(height: 16,),
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
                ):ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 16), // Adjust the height as needed
                  scrollDirection: Axis.vertical,
                  itemCount: elementItems.length,
                  itemBuilder: (context, index) {
                    final elementItem = elementItems[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                                children: [
                                  const Icon(
                                    Icons.class_outlined,
                                    size: 80,
                                    color: TColors.firstcolor,
                                  ),
                                  const SizedBox(width: 17),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> buildShowDialogAddElemet(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title:const Text('Ajouter un element', style: TextStyle(fontSize: 30,

              fontWeight: FontWeight.bold),),
          content: Form(
            key:_formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2,

              // Adjust the height as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const SizedBox(
                    height:36,
                  ),
                  TextFormField(
                    style:const TextStyle(fontSize: 28),
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
                      hintStyle: const TextStyle().copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24,
                          color: Colors.grey.withOpacity(0.8)),
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
                        child:const  Text('Annuler',style: TextStyle(
                          color: TColors.firstcolor,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (elementNameController.text.isNotEmpty) {
                            addElement(widget.moduleId,elementNameController.text);
                            Navigator.pop(context);
                            elementNameController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Veuillez entrer un nom d\'élément et sélectionner un module.'),
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
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        child:const Text(
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
  void addElement(int moduleId, String elementName) async {
    if (elementName.isNotEmpty) {
      int? elementId = await dbHelper.addElement(moduleId, elementName);
      setState(() {
        // Create a new ElementItem instance for the added element
        ElementItem elementItem = ElementItem(
          id: elementId, // Assuming the element ID can be used as the cid
          moduleId:moduleId,
          name: elementName,
        );
        // Add the element to the list of elementItems
        elementItems.add(elementItem);
      });
        } else {
      showToast("Veuillez entrer le nom de l'élément et sélectionner un module.");
    }
  }
  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
