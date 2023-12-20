import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/offers_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/offers_card.dart';

import '../Widgets/Buttons/close_button.dart';

class OffersSheet extends ConsumerWidget {
  const OffersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return OffersProviderWidget(
      builder: (offers) => Container(
        height: double.infinity,
        color: backgroundColor,
        padding: const EdgeInsets.only(top: 60.0, left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: JusCloseButton(),
            ),
            Text(
              'Offers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Spacing.vertical(40),
            offers.isEmpty
                ? const Center(
                    child: AutoSizeText(
                    'There are no active offers available.',
                    style: TextStyle(fontSize: 18),
                  ))
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1 / 1.3),
                      itemCount: offers.isEmpty ? 0 : offers.length,
                      itemBuilder: (context, index) => OffersCard(
                        index: index,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
