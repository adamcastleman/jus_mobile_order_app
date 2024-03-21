import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium_loading.dart';

class MediumElevatedButton extends ConsumerWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const MediumElevatedButton(
      {required this.buttonText, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingProvider);
    if (loading) {
      return const MediumElevatedLoadingButton();
    } else {
      return ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            ResponsiveLayout.isMobileBrowser(context)
                ? Size(MediaQuery.of(context).size.width * 0.4, 45.0)
                : Size(MediaQuery.of(context).size.width * 0.15, 45.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
        ),
      );
    }
  }
}
