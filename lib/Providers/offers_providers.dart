import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';

final pointsMultiplierProvider = StateProvider<double>((ref) => 1);

final offersQuantityProvider =
    StateNotifierProvider.autoDispose<OffersInUse, List<Map>>(
        (ref) => OffersInUse());

class OffersInUse extends StateNotifier<List<Map>> {
  OffersInUse() : super([]);

  add(
    WidgetRef ref,
    int index,
    int numberOfOffers,
    int maxQuantity,
  ) {
    var offers = ref.read(offersQuantityProvider);

    if (index >= offers.length) {
      offers = List.generate(
          numberOfOffers,
          (i) => i == index
              ? {
                  'quantity': 1,
                  'maxQuantity': maxQuantity,
                }
              : {'quantity': 0, 'maxQuantity': 0});
      HapticFeedback.lightImpact();
    } else {
      var offer = offers[index];
      offer['maxQuantity'] = maxQuantity;
      if (offer['quantity'] < offer['maxQuantity']) {
        offer['quantity']++;
        HapticFeedback.lightImpact();
      }
    }

    state = [...offers];
  }

  remove(WidgetRef ref, int index) {
    var offers = ref.read(offersQuantityProvider);

    if (index < 0 || index >= offers.length) {
      return;
    }

    var offer = offers[index];
    if (offer['quantity'] == 0) {
      return;
    }

    offer['quantity']--;
    HapticFeedback.lightImpact();

    bool allZero = true;
    for (var item in offers) {
      if (item['quantity'] != 0) {
        allZero = false;
        break;
      }
    }
    allZero == true ? ref.invalidate(isRewardsAvailableProvider) : null;
    state = [...offers];
  }
}
