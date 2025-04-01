import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../provider/localization_provider.dart';
import '../../util/constant/colors.dart';

class AppLanguageSettings extends StatefulWidget {
  const AppLanguageSettings({super.key});



  @override
  State<AppLanguageSettings> createState() => _AppLanguageSettingsState();
}

class _AppLanguageSettingsState extends State<AppLanguageSettings> {

  _selectLanguage(Locale selectedLocale) {
    Provider.of<LocalizationProvider>(context, listen: false)
        .changeLocale(selectedLocale);
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
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
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: localizationProvider.localesCount,
          itemBuilder: (context, index) => Card(
            color: Colors.white,
            child: RadioListTile<Locale>(
              hoverColor: TColors.firstcolor,
              activeColor: TColors.firstcolor,
              groupValue: localizationProvider.currentLocale,
              onChanged: (val) =>
                  _selectLanguage(localizationProvider.supportedLocales[index]),
              value: localizationProvider.supportedLocales[index],
              title: Text(localizationProvider
                  .supportedLocales[index].languageCode
                  .toUpperCase()),
            ),
          ),
        ),
      ),
    );
  }
}
