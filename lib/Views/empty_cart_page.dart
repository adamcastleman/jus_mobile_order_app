import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/choose_location_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class EmptyCartPage extends ConsumerWidget {
  const EmptyCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(emptyCartImageProvider);
    return image.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: data.data().containsKey('url') ? data['url'] : '',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 44.0, horizontal: 15.0),
              child: Column(
                children: [
                  AutoSizeText(
                    data.data().containsKey('title') ? data['title'] : '',
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Spacing().vertical(10),
                  AutoSizeText(
                    data.data().containsKey('description')
                        ? data['description']
                        : '',
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Center(
              child: MediumElevatedButton(
                buttonText: 'Order Now',
                onPressed: () async {
                  if (ref.read(selectedLocationID) == 0) {
                    await HandlePermissions(context, ref).locationPermission();
                    ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (BuildContext context) =>
                          const ChooseLocationPage(),
                    );
                  }
                  ref.read(bottomNavigationProvider.notifier).state = 2;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
