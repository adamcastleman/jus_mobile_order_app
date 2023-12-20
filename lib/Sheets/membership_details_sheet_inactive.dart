import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/perks_description_tile.dart';

class InactiveMembershipDetailsSheet extends StatelessWidget {
  const InactiveMembershipDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MembershipDetailsProviderWidget(
      builder: (membership) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                membership.name,
                style: const TextStyle(fontSize: 28),
              ),
            ],
          ),
          membershipPriceCard(membership),
          Spacing.vertical(15),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: membership.perks.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                if (index.isEven) {
                  return PerksDescriptionTileImageRight(
                      name: membership.perks[index]['name'],
                      description: membership.perks[index]['description'],
                      imageURL: membership.perks[index]['image']);
                } else {
                  return PerksDescriptionTileImageLeft(
                      name: membership.perks[index]['name'],
                      description: membership.perks[index]['description'],
                      imageURL: membership.perks[index]['image']);
                }
              },
            ),
          ),
          Text(
            membership.signUpText,
            style: const TextStyle(fontSize: 18),
          ),
          Spacing.vertical(50),
        ],
      ),
    );
  }

  membershipPriceCard(MembershipDetailsModel data) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(
            data.description,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Spacing.vertical(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Monthly',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${(data.subscriptionPrice[0]['amount'] / 100).toStringAsFixed(2)}${data.subscriptionPrice[0]['name']}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Annually',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${(data.subscriptionPrice[1]['amount'] / 100).toStringAsFixed(2)}${data.subscriptionPrice[1]['name']}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Spacing.vertical(10),
        ],
      ),
    );
  }
}
