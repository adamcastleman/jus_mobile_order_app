import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_guest.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/loyalty_guest.dart';
import 'package:jus_mobile_order_app/Widgets/General/home_greeting.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../Widgets/Lists/recommended_items.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
              const LoyaltyCardGuest(),
              Spacing().vertical(25),
              const RecommendedItems(),
              Spacing().vertical(25),
              const FavoritesCardGuest(),
              Spacing().vertical(25),
            ],
          ),
        ),
      ],
    );
  }
}
