import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/offers_card.dart';

class OffersGridView extends StatelessWidget {
  final UserModel user;
  final List<OffersModel> offers;

  const OffersGridView({required this.user, required this.offers, super.key});

  @override
  Widget build(BuildContext context) {
    final isMember = user.uid != null && user.subscriptionStatus!.isActive;
    if (!_isUserEligibleForAnyOffer(isMember)) {
      return const Center(
        child: AutoSizeText(
          'There are no eligible offers available.',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.only(bottom: 24.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1 / 1.3,
        ),
        itemCount:
            offers.where((offer) => !offer.isMemberOnly || (isMember)).length,
        itemBuilder: (context, index) {
          final offer = offers
              .where((offer) => !offer.isMemberOnly || (isMember))
              .elementAt(index);
          return OffersCard(
            offer: offer,
          );
        },
      );
    }
  }

  bool _isUserEligibleForAnyOffer(bool isMember) {
    return offers.any((offer) {
      // Check if the offer is active
      if (!offer.isActive) {
        return false;
      }

      // Trim whitespace from each string in the qualifyingUsers list before checking for a match
      bool isUserQualified = offer.qualifyingUsers.isEmpty ||
          offer.qualifyingUsers
              .map((user) => user.trim())
              .contains(user.uid!.trim());

      // Check if the offer is for members only and if the user is an active member
      bool isEligibleForMemberOnlyOffer =
          !offer.isMemberOnly || (offer.isMemberOnly && isMember);

      return isUserQualified && isEligibleForMemberOnlyOffer;
    });
  }
}
