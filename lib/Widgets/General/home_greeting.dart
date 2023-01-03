import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';

class HomeGreeting extends ConsumerWidget {
  const HomeGreeting({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return user.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(error: e.toString()),
        data: (data) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dayPartGreeting()},',
                  style: Theme.of(context).textTheme.headline4,
                ),
                determineNameForGreeting(user, context),
              ],
            ),
          );
        });
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

  determineNameForGreeting(user, context) {
    if (user.value?.uid == null) {
      return Text(
        'Guest ${dayPartEmoji()}',
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      return Text(
        '${user.value?.firstName} ${dayPartEmoji()}',
        style: Theme.of(context).textTheme.headline4,
      );
    }
  }
}
