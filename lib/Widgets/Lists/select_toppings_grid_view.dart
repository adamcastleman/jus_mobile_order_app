import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Providers/stream_providers.dart';
import '../Cards/select_multiple_ingredients_card.dart';

class SelectToppingsGridView extends ConsumerWidget {
  const SelectToppingsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toppings = ref.watch(toppingsOnlyIngredientsProvider);
    return toppings.when(
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      loading: () => const Loading(),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select up to three toppings:',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Spacing().vertical(10),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1.2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3),
              itemCount: data.length,
              itemBuilder: (context, index) => SelectMultipleIngredientsCard(
                ingredient: data[index],
                isAllergy: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
