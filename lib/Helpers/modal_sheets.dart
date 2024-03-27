import 'package:flutter/material.dart';

class ModalBottomSheet {
  fullScreen({
    required BuildContext context,
    required WidgetBuilder builder,
    VoidCallback? whenComplete,
  }) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: builder,

    ).whenComplete(whenComplete ?? () {});
  }

  partScreen(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool? enableDrag,
      bool? isDismissible,
      bool? isScrollControlled,
        VoidCallback? whenComplete,
      }) {
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
    ).whenComplete(whenComplete ?? () {});
  }
}
