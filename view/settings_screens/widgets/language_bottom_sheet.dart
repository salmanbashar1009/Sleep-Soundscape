import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/localizaiton_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'bottom_sheet_header.dart';
import '../../../l10n/app_localizations.dart';


void LanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.w),
        topRight: Radius.circular(10.w),
      ),
    ),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          final darkTheme = innerContext.watch<ThemeProvider>().isDarkMode;
         final localizationProvider = context.watch<LocalizationProvider>();
          final appLocalizations = AppLocalizations.of(context)!;

          final List<Map<String, String>> languages = [
            {"code": "system", "name": "System Language"},
            {"code": "en", "name": "English"},
            {"code": "hi", "name": "हिन्दी (Hindi)"},
            {"code": "pa", "name": "ਪੰਜਾਬੀ (Punjabi)"},
            {"code": "zh", "name": "中文 (Chinese)"},
            {"code": "it", "name": "Italiano (Italian)"},
            {"code": "nl", "name": "Nederlands (Dutch)"},
            {"code": "fr", "name": "Français (French)"},
            {"code": "es", "name": "Español (Spanish)"},
            {"code": "de", "name": "Deutsch (German)"},
          ];

          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(innerContext).size.height * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 6.h),

                  Container(
                    width: 115.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.10) : Color.fromRGBO(0, 0, 0, 0.10),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  BottomSheetHeader(
                    imagePath: "assets/icons/back.png",
                    title: appLocalizations.language,
                  ),

                  Expanded(
                    child: ListView.separated(
                      itemCount: languages.length,
                      separatorBuilder: (context, index) => Divider(
                        color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.1) : Color.fromRGBO(0, 0, 0, 0.1),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        final bool isSelected = localizationProvider.selectedIndex == index;


                        return ListTile(
                          // tileColor: darkTheme ?Color.fromRGBO(0, 0, 0, 0.10) : Color.fromRGBO(255, 255, 255, 0.10),

                          title: Text(
                            language["name"]!,
                            style: Theme.of(innerContext).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w300,
                              fontFamily: "Lexend",
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.radio_button_checked, color: Color(0xFFFAD051))
                              : Icon(Icons.radio_button_off, color: darkTheme ? Color.fromRGBO(255,255,255,0.6) : Color.fromRGBO(0,0,0,0.6)),

                          onTap: () async {

                            localizationProvider.setSelectedIndex(index);

                            try {
                              final currentLocale = localizationProvider.locale?.languageCode;
                              final selectedLocale = language["code"];

                              if (currentLocale != selectedLocale) {
                                // await localizationProvider.changeLanguage(Locale(selectedLocale!));
                                localizationProvider.setLocale(Locale(selectedLocale!));
                                debugPrint("Language changed to: $selectedLocale");
                              } else {
                                debugPrint("Selected language is already active.");
                              }

                              Navigator.pop(context); // Close BottomSheet after language change
                            } catch (e) {
                              debugPrint("Error changing language: $e");
                            }
                          },


                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
