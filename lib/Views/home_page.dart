import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/loyalty_card.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/loyalty_guest.dart';
import 'package:jus_mobile_order_app/Widgets/General/home_greeting.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/favorites_list.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_list_home.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/recommended_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/announcement_tile.dart';

import '../Widgets/Cards/favorites_guest.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final offers = ref.watch(offersProvider);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => offers.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (offers) => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacing().vertical(25),
              const Align(
                alignment: Alignment.centerLeft,
                child: HomeGreeting(),
              ),
              Spacing().vertical(25),
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: AnnouncementCard(),
              ),
              user.uid == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LoyaltyCardGuest(),
                    )
                  : const LoyaltyCard(),
              showOffersList(user, offers),
              user.uid == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: FavoritesCardGuest(),
                    )
                  : const FavoritesList(),
              const RecommendedList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showOffersList(UserModel user, List<OffersModel> offers) {
    if (user.uid == null) {
      return const SizedBox();
    }
    if (offers.isEmpty) {
      return const SizedBox();
    }

    bool allMemberOnly = true;
    for (var offer in offers) {
      if (!offer.isMemberOnly) {
        allMemberOnly = false;
        break;
      }
    }

    if (allMemberOnly && !user.isActiveMember!) {
      return const SizedBox();
    } else {
      return const OffersList();
    }
  }
}
