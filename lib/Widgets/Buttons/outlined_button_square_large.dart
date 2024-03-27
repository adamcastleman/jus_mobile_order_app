import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';

class LargeOutlineSquareButton extends ConsumerWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? color;

  const LargeOutlineSquareButton({
    required this.buttonText,
    required this.onPressed,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(updateMembershipLoadingProvider);
    return OutlinedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 50.0),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        backgroundColor: MaterialStateProperty.all(color ?? Colors.white),
      ),
      onPressed: onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: Loading(),
            )
          : Text(
              buttonText,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}
