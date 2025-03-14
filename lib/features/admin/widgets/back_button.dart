

import 'package:flutter/material.dart';

import '../../../util/constant/colors.dart';

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon:const Icon(
        Icons.chevron_left,size: 40,color: TColors.firstcolor,
      ),);
  }
}