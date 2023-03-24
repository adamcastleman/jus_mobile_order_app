import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/empty_cart_image_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';

class EmptyCartPage extends ConsumerWidget {
  const EmptyCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmptyCartImageProviderWidget(
      builder: (image) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: image.data().containsKey('url') ? image['url'] : '',
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 44.0, horizontal: 15.0),
            child: Column(
              children: [
                AutoSizeText(
                  image.data().containsKey('title') ? image['title'] : '',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Spacing().vertical(10),
                AutoSizeText(
                  image.data().containsKey('description')
                      ? image['description']
                      : '',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Center(
            child: MediumElevatedButton(
              buttonText: 'Order Now',
              onPressed: () {
                if (ref.read(selectedLocationProvider) == null) {
                  LocationHelper().chooseLocation(context, ref);
                }
                ref.read(bottomNavigationProvider.notifier).state = 2;
              },
            ),
          ),
        ],
      ),
    );
  }
}
