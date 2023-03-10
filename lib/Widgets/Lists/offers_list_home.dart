import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/offers_card.dart';

class OffersList extends ConsumerWidget {
  const OffersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);
    return offers.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (offers) => SizedBox(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Offers',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      Spacing().horizontal(15),
                  itemCount: offers.isEmpty ? 0 : offers.length,
                  itemBuilder: (context, index) => OffersCard(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
