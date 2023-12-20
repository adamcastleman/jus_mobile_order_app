import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Views/checkout_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class CheckoutButton extends ConsumerWidget {
  final UserModel user;
  final List<ProductModel> products;
  const CheckoutButton({required this.user, required this.products, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'Checkout',
      onPressed: () {
        HapticFeedback.lightImpact();
        if (LocationHelper().selectedLocation(ref) == null) {
          chooseLocation(context, ref);
        } else {
          OrderHelpers(ref: ref).setOrderingDateAndTimeProviders(products);
          setCheckoutPageProviderToTrue(ref);
          setAvailablePointsProvider(ref, user);

          ModalBottomSheet().fullScreen(
            context: context,
            builder: (context) => const CheckoutPage(),
          );
        }
      },
    );
  }

  chooseLocation(BuildContext context, WidgetRef ref) {
    return LocationHelper().chooseLocation(context, ref);
  }

  setCheckoutPageProviderToTrue(WidgetRef ref) {
    ref.read(checkOutPageProvider.notifier).state = true;
  }

  setAvailablePointsProvider(WidgetRef ref, UserModel user) {
    if (user.uid == null) {
      return;
    } else {
      ref.read(totalPointsProvider.notifier).set(user.points!);
    }
  }
}
