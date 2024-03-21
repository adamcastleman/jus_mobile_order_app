import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';

class LargeElevatedButton extends ConsumerWidget {
  final Key? buttonKey;
  final VoidCallback onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final bool? border;
  final Color? borderColor;
  final double? fontSize;

  const LargeElevatedButton({
    this.buttonKey,
    this.buttonText,
    this.textColor,
    this.border,
    this.buttonColor,
    this.borderColor,
    this.fontSize,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(buttonKeyProvider);
    final loading = ref.watch(loadingProvider);
    return buttonKey == key && loading
        ? LargeElevatedLoadingButton(
            buttonColor: buttonColor,
            borderColor: borderColor,
            border: border,
            iconColor: borderColor,
          )
        : Center(
            child: ElevatedButton(
              key: key,
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.9, 50.0),
                ),
                backgroundColor: MaterialStateProperty.all(buttonColor),
                side: border != null && border!
                    ? MaterialStateProperty.all(
                        BorderSide(
                          color: borderColor ?? Colors.black,
                          width: 1.0,
                        ),
                      )
                    : null,
              ),
              onPressed: onPressed,
              child: AutoSizeText(
                buttonText ?? '',
                style: TextStyle(
                  fontSize: fontSize ?? 16,
                  color: textColor ?? Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          );
  }
}
