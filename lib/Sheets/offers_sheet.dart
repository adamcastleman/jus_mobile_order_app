import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/offers_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_grid_view.dart';
import 'package:jus_mobile_order_app/constants.dart';

class OffersSheet extends ConsumerWidget {
  const OffersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return OffersProviderWidget(
      builder: (offers) {
        return Container(
          height: double.infinity,
          color: backgroundColor,
          padding: EdgeInsets.only(
            top: isDrawerOpen == null || !isDrawerOpen ? 50.0 : 12.0,
            right: 12.0,
            left: 12.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SheetHeader(
                  title: 'Offers',
                  showCloseButton: isDrawerOpen == null || !isDrawerOpen,
                ),
                const SizedBox(height: 40),
                OffersGridView(user: user, offers: offers),
              ],
            ),
          ),
        );
      },
    );
  }
}
