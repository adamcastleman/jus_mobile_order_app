import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/app_store_ids_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/app_store_ids_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:open_store/open_store.dart';

class ForceAppUpdatePage extends ConsumerWidget {
  const ForceAppUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: DisplayImagesProviderWidget(
            builder: (images) => AppStoreIdsProviderWidget(
              builder: (ids) => CallToActionBanner(
                backgroundColor: backgroundColor,
                imagePath: images['images'][22]['url'],
                title: 'A new version is available',
                description:
                    'Please update to the newest available version to continue using your app',
                callToActionText: 'Update',
                callToActionOnPressed: () {
                  _launchAppStore(ids);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchAppStore(AppStoreIdsModel ids) {
    return OpenStore.instance.open(
      ///TODO update the database with these values
      appStoreId: ids.appStoreIdiOS,
      androidAppBundleId: ids.appStoreIdGooglePlay,
    );
  }
}
