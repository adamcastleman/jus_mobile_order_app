import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';

class SheetHeader extends ConsumerWidget {
  final String title;
  final List<Widget>? trailingButtons;
  final bool showCloseButton;
  final Color? color;
  final Function()? onClose;

  const SheetHeader({
    required this.title,
    this.trailingButtons,
    this.showCloseButton = true,
    this.color,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final headerStyle = ref.watch(scaffoldTextStyleProvider);

    List<Widget> trailingWidgets = [];

    if (trailingButtons != null) {
      trailingWidgets.addAll(trailingButtons!);
    }

    if (showCloseButton) {
      trailingWidgets.add(
        JusCloseButton(
          onPressed: onClose ??
              () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
        ),
      );
    } else {
      trailingWidgets.add(const SizedBox.shrink());
    }

    return Container(
      color: color ?? backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: headerStyle,
            ),
          ),
          ...trailingWidgets,
        ],
      ),
    );
  }
}
