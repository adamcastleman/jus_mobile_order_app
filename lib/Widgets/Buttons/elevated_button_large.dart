import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';

class LargeElevatedButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final String? buttonText;

  const LargeElevatedButton({
    this.buttonText,
    required this.onPressed,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingProvider);
    if (loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width * 0.9, 50.0),
          ),
        ),
        onPressed: onPressed,
        child: AutoSizeText(
          buttonText ?? '',
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
        ),
      );
    }
  }
}
