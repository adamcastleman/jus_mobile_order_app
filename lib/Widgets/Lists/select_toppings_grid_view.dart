import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Providers/stream_providers.dart';
import '../Cards/select_toppings_card.dart';

class SelectToppingsGridView extends ConsumerWidget {
  final bool isQuickAdd;
  const SelectToppingsGridView({required this.isQuickAdd, Key? key})
      : super(key: key);

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
          Text(
            'Select up to three toppings:',
            style: Theme.of(context).textTheme.headline6,
          ),
          Spacing().vertical(10),
          isQuickAdd
              ? SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    separatorBuilder: (context, index) {
                      return Spacing().horizontal(5);
                    },
                    itemBuilder: (context, index) {
                      return SelectToppingsCard(
                        topping: data[index],
                      );
                    },
                  ),
                )
              : Flexible(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(0.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.2,
                            crossAxisCount: 3,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3),
                    itemCount: data.length,
                    itemBuilder: (context, index) => SelectToppingsCard(
                      topping: data[index],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
