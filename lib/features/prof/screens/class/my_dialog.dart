import 'package:flutter/material.dart';

import '../../../../util/constant/colors.dart';

class MyDialog extends StatefulWidget {
  final Function(String, String) onClick;

  const MyDialog({super.key, required this.onClick});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String name = "";
  String subtitle  = "";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9), // Apply border radius to the AlertDialog
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ajouter une nouvelle Séance',
              style: TextStyle(fontSize: 18,

                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                errorMaxLines: 3,
                labelStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                hintStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                prefixIconColor: Colors.grey,
                floatingLabelStyle: const TextStyle().copyWith(color:TColors.firstcolor.withOpacity(0.8)),
                prefixIcon: const Icon(Icons.class_outlined),
                labelText: 'Nom de la Séance',

              ),

              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                errorMaxLines: 3,
                labelStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                hintStyle: const TextStyle().copyWith(fontSize: 15,color:Colors.grey ),
                prefixIconColor: Colors.grey,
                floatingLabelStyle: const TextStyle().copyWith(color:TColors.firstcolor.withOpacity(0.8)),
                prefixIcon: const Icon(Icons.class_),
                labelText: 'Sous-titre de la Séance',
              ),
              onChanged: (value) => subtitle = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler',style: TextStyle(
            color: TColors.firstcolor,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),),
        ),
        ElevatedButton(
          onPressed: () {
            if (name.isNotEmpty && subtitle.isNotEmpty) {
              widget.onClick(name, subtitle);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez remplir tous les champs.'),
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
          child: const Text('Ajouter',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),),
        ),
      ],
    );
  }
}