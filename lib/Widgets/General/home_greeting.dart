import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class MobileHomeGreeting extends ConsumerWidget {
  const MobileHomeGreeting({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    return AutoSizeText(
      '${dayPartGreeting()}${determineNameForGreeting(user ?? const UserModel(), context)}',
      style: const TextStyle(fontSize: 24),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  dayPartGreeting() {
    final now = DateTime.now();
    if (now.hour >= 4 && now.hour < 12) {
      return 'Good morning';
    } else if (now.hour >= 12 && now.hour < 16) {
      return 'Good afternoon';
    } else if (now.hour >= 16 && now.hour < 20) {
      return 'Good evening';
    } else if (now.hour >= 20 && now.hour <= 24 ||
        now.hour >= 0 && now.hour < 4) {
      return 'Good night';
    } else {
      return 'Hello';
    }
  }

  determineNameForGreeting(UserModel user, BuildContext context) {
    if (user.uid == null) {
      return '';
    } else {
      return ', ${user.firstName} ';
    }
  }
}
