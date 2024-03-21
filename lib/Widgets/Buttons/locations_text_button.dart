import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class LocationsTextButton extends ConsumerWidget {
  final double? fontSize;
  final VoidCallback onPressed;
  const LocationsTextButton(
      {this.fontSize, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    final locationLoading = ref.watch(locationLoadingProvider);
    final scaffoldKey = AppConstants.scaffoldKey;
    final currentPage = ref.watch(webNavigationProvider);
    return Row(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text('locations', style: buttonStyle),
        ),
        _handleLoadingIndicator(ref, locationLoading, scaffoldKey, currentPage),
      ],
    );
  }

  _handleLoadingIndicator(WidgetRef ref, bool locationLoading,
      GlobalKey<ScaffoldState> scaffoldKey, int currentPage) {
    if (locationLoading == false) {
      return const SizedBox();
    }
    if (locationLoading && ref.read(isInHamburgerMenuProvider)) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 15,
          width: 15,
          child: Loading(),
        ),
      );
    }
    if (!scaffoldKey.currentState!.isEndDrawerOpen &&
        currentPage != AppConstants.menuPageWeb) {
      return const SizedBox(width: 10, height: 10, child: Loading());
    } else {
      return const SizedBox();
    }
  }
}
