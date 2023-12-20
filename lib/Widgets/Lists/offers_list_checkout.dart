import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/offers_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/redeem_offer_card.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';

class AvailableOffersList extends ConsumerWidget {
  const AvailableOffersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return PointsDetailsProviderWidget(
      builder: (points) => OffersProviderWidget(
        builder: (offers) {
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CategoryWidget(text: 'Offers'),
                qualifyingOffers(ref, offers).isEmpty
                    ? noQualifyingOffers()
                    : SizedBox(
                        height: 200,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: qualifyingOffers(ref, offers).length,
                          separatorBuilder: (context, index) =>
                              Spacing.horizontal(10),
                          itemBuilder: (context, index) {
                            return RedeemOfferCard(
                                index: index,
                                offers: qualifyingOffers(ref, offers));
                          },
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }

  List<OffersModel> qualifyingOffers(WidgetRef ref, List<OffersModel> offers) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return offers
        .where(
          (offer) => currentOrder.any((order) =>
              offer.qualifyingProducts.contains(order['productID']) ||
              offer.pointsMultiple != 1),
        )
        .toList();
  }

  noQualifyingOffers() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 65.0),
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'No qualifying offers available',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
