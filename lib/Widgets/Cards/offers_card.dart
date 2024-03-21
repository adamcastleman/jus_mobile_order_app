import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OffersCard extends ConsumerWidget {
  final OffersModel offer;
  const OffersCard({required this.offer, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);

    if (offer.isMemberOnly &&
        (user.uid == null ||
            user.subscriptionStatus != SubscriptionStatus.active)) {
      return const SizedBox();
    }
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      openColor: backgroundColor,
      closedColor: backgroundColor,
      transitionType: ContainerTransitionType.fadeThrough,
      tappable: true,
      openBuilder: (context, open) => Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: JusCloseButton(),
            ),
            Spacing.vertical(20),
            AutoSizeText(
              offer.name,
              maxLines: 1,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Spacing.vertical(20),
            AutoSizeText(
              offer.description,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18),
            ),
            Spacing.vertical(60),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: {'offerID': offer.uid, 'userID': user.uid ?? ''}
                      .toString(),
                ),
              ),
            ),
          ],
        ),
      ),
      closedBuilder: (context, close) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoSizeText(
                offer.name,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                offer.description,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const AutoSizeText(
                'Tap to scan in-store, or apply at checkout',
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
