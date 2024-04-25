import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/points_activity_list.dart';
import 'package:jus_mobile_order_app/constants.dart';

class PointsActivitySheet extends ConsumerWidget {
  const PointsActivitySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: isDrawerOpen == null || isDrawerOpen ? 50.0 : 12.0,
        left: 12.0,
        right: 12.0,
        bottom: 12.0,
      ),
      child: ListView(
        primary: false,
        children: [
          SheetHeader(
            title: 'Points Activity',
            showCloseButton: isDrawerOpen == null || !isDrawerOpen,
          ),
          Spacing.vertical(10),
          const PointsActivityListView(),
          Spacing.vertical(5),
          const Center(
            child: Text(
              'That\'s all (from the last 120 days)',
            ),
          ),
        ],
      ),
    );
  }
}
