import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/perks_description_tile.dart';

class MembershipDetailPage extends ConsumerWidget {
  const MembershipDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final membershipDetails = ref.watch(membershipDetailsProvider);
    return membershipDetails.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) => Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Spacing().vertical(MediaQuery.of(context).size.height * 0.05),
              Align(
                alignment: Alignment.topLeft,
                child: JusCloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  membershipPriceCard(data),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: data.perks.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        if (index.isEven) {
                          return PerksDescriptionTileImageRight(
                              name: data.perks[index]['name'],
                              description: data.perks[index]['description'],
                              imageURL: data.perks[index]['image']);
                        } else {
                          return PerksDescriptionTileImageLeft(
                              name: data.perks[index]['name'],
                              description: data.perks[index]['description'],
                              imageURL: data.perks[index]['image']);
                        }
                      },
                    ),
                  ),
                  Text(
                    data.signUpText,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Spacing().vertical(50),
                ],
              ),
            ],
          ),
        ),
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
          Spacing().vertical(30),
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
          Spacing().vertical(10),
        ],
      ),
    );
  }
}
