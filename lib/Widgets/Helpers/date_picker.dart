import 'package:flutter/cupertino.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';

class Picker {
  date(BuildContext context) {
    return ModalBottomSheet().partScreen(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (value) {},
          initialDateTime: DateTime.now(),
          minimumDate: DateTime.now().subtract(
            const Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}
