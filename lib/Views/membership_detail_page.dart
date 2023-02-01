import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/description_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class MembershipDetailPage extends ConsumerWidget {
  const MembershipDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);
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
                          return DescriptionTile(data: data, index: index)
                              .right();
                        } else {
                          return DescriptionTile(data: data, index: index)
                              .left();
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

  descriptionTileImageRight(MembershipDetailsModel data, int index) {
    return Stack(
      children: [
        Positioned(
          top: 25.0,
          left: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.perks[index]['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacing().vertical(10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: 150,
                  child: Text(
                    data.perks[index]['description'],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 225,
            width: 225,
            child: CachedNetworkImage(
              imageUrl: data.perks[index]['image'],
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }

  descriptionTileImageLeft(MembershipDetailsModel data, int index) {
    return Stack(
      children: [
        Positioned(
          top: 45.0,
          right: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.perks[index]['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacing().vertical(10),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: SizedBox(
                  width: 150,
                  child: Text(
                    data.perks[index]['description'],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 225,
            width: 225,
            child: CachedNetworkImage(
              imageUrl: data.perks[index]['image'],
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }
}
