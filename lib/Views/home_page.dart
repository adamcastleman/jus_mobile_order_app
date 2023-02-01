import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/loyalty_card.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/loyalty_guest.dart';
import 'package:jus_mobile_order_app/Widgets/General/home_greeting.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacing().vertical(25),
          Expanded(
            child: ListView(
              clipBehavior: Clip.none,
              primary: false,
              children: [
                const HomeGreeting(),
                Spacing().vertical(25),
                user.uid == null
                    ? const LoyaltyCardGuest()
                    : const LoyaltyCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
