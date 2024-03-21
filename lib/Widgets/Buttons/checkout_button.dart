import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/order_validators.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Views/checkout_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/errors.dart';

class CheckoutButton extends ConsumerWidget {
  final UserModel user;

  const CheckoutButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'Checkout',
      onPressed: () {
        HapticFeedback.lightImpact();
        if (LocationHelper().selectedLocation(ref) == null) {
          NavigationHelpers().navigateToLocationPage(context, ref);
        } else if (OrderValidators().checkUnavailableItems(ref) != null) {
          NavigationHelpers.navigateToPartScreenSheet(context,
              InvalidSheetSinglePop(error: ErrorMessage.unavailableItem));
        } else {
          OrderHelpers().setOrderingDateAndTimeProviders(ref);
          setCheckoutPageProviderToTrue(ref);
          setAvailablePointsProvider(ref, user);
          if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
            ModalBottomSheet().fullScreen(
              context: context,
              builder: (context) => const CheckoutPage(),
            );
          } else {
            ref.read(drawerPageProvider.notifier).state = const CheckoutPage();
          }
        }
      },
    );
  }

  setCheckoutPageProviderToTrue(WidgetRef ref) {
    ref.read(isCheckOutPageProvider.notifier).state = true;
  }

  setAvailablePointsProvider(WidgetRef ref, UserModel user) {
    if (user.uid == null) {
      return;
    } else {
      ref.read(totalPointsProvider.notifier).set(user.points!);
    }
  }
}
