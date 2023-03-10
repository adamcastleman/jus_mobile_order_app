import 'package:flutter/material.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class ModalBottomSheet {
  fullScreen({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.white,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: builder,
    );
  }

  partScreen(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool? enableDrag,
      bool? isDismissible,
      bool? isScrollControlled}) {
    return showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.white,
      enableDrag: enableDrag ?? false,
      isScrollControlled: isScrollControlled ?? false,
      isDismissible: isDismissible ?? false,
      context: context,
      builder: builder,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
    );
  }
}

class ModalTopSheet {
  fullScreen({
    required BuildContext context,
    required Widget child,
  }) {
    return showTopModalSheet<String?>(
      context,
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: child,
      ),
    );
  }
}
