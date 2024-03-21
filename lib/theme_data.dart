import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class ThemeManager {
  final ThemeData theme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xffF5F5F7),
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: GoogleFonts.quicksand().fontFamily,
        ),
        pickerTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: GoogleFonts.quicksand().fontFamily,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: false,
      backgroundColor: const Color(0xffF5F5F7),
      elevation: 0,
      actionsIconTheme: const IconThemeData(color: Colors.black, size: 20),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 30,
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black, foregroundColor: Colors.white),
    unselectedWidgetColor: Colors.grey,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    textTheme: GoogleFonts.quicksandTextTheme(),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      color: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 25,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(8),
      constraints: BoxConstraints(
        maxWidth: WidgetsBinding
                .instance.platformDispatcher.views.first.physicalSize.width *
            0.9,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey[300],
      hintStyle: TextStyle(
        color: Colors.grey[600],
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      childrenPadding: EdgeInsets.symmetric(vertical: 12.0),
      expandedAlignment: Alignment.topLeft,
      shape: RoundedRectangleBorder(side: BorderSide.none),
      iconColor: Colors.black,
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      textColor: Colors.black,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: const BorderSide(color: Colors.black, width: 0.5),
      ),
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.black;
        }
        return Colors.white;
      }),
      checkColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );

  Future setIOSCardEntryTheme({required bool isMembershipMigration}) async {
    var themeConfigurationBuilder = IOSThemeBuilder();
    themeConfigurationBuilder.saveButtonTitle = isMembershipMigration
        ? 'Update Payment Method for Membership'
        : 'Add Card';

    themeConfigurationBuilder.tintColor = RGBAColorBuilder()
      ..r = 0
      ..g = 0
      ..b = 0
      ..a = 1;
    themeConfigurationBuilder.keyboardAppearance = KeyboardAppearance.light;

    await InAppPayments.setIOSCardEntryTheme(themeConfigurationBuilder.build());
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int? maxLines;

  const TitleText(
      {required this.text, required this.fontSize, this.maxLines, super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: GoogleFonts.raleway(
          fontSize: fontSize, fontWeight: FontWeight.bold, letterSpacing: -2),
      textAlign: TextAlign.center,
      maxLines: maxLines ?? 2,
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int? maxLines;

  const DescriptionText(
      {required this.text, required this.fontSize, this.maxLines, super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(fontSize: fontSize, letterSpacing: -1),
      textAlign: TextAlign.center,
      maxLines: maxLines ?? 3,
    );
  }
}
