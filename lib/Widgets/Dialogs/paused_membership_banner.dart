import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PausedMembershipBanner extends ConsumerWidget {
  const PausedMembershipBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return InkWell(
      onTap: () {
        NavigationHelpers.handleMembershipNavigation(
          context,
          ref,
          user,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        color: Colors.red,
        child: const Center(
          child: Text(
            'There was an error processing your membership payment. Your membership is paused. Please update your payment method.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
