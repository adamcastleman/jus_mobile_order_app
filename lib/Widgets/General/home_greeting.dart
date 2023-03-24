import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';

class HomeGreeting extends ConsumerWidget {
  const HomeGreeting({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              '${dayPartGreeting()} ${determineNameForGreeting(user, context)}',
              style: const TextStyle(fontSize: 26),
              maxLines: 1,
            ),
          ],
        ),
      ),
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

  dayPartEmoji() {
    final now = DateTime.now();
    if (now.hour >= 4 && now.hour < 12) {
      return EmojiParser().emojify(':coffee:');
    } else if (now.hour >= 12 && now.hour < 16) {
      return EmojiParser().emojify(':sunny:');
    } else if (now.hour >= 16 && now.hour < 20) {
      return EmojiParser().emojify(':sparkles:');
    } else if (now.hour >= 20 && now.hour <= 24 ||
        now.hour >= 0 && now.hour < 4) {
      return EmojiParser().emojify(':crescent_moon:');
    } else {
      return EmojiParser().emojify(':wave:');
    }
  }

  determineNameForGreeting(UserModel user, BuildContext context) {
    if (user.uid == null) {
      return '${dayPartEmoji()}';
    } else {
      return ', ${user.firstName} ${dayPartEmoji()}';
    }
  }
}
