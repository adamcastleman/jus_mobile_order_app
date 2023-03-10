import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/recommended_card.dart';

class RecommendedList extends ConsumerWidget {
  const RecommendedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedProducts = ref.watch(recommendedProductsProvider);
    return recommendedProducts.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (recommended) => SizedBox(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended for you',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Spacing().horizontal(15),
                itemCount: recommended.isEmpty ? 0 : recommended.length,
                itemBuilder: (context, index) => RecommendedCard(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
