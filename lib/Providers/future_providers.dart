import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/square_subscription_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

final deviceTimezoneProvider =
    FutureProvider<String>((ref) => Time().currentDeviceTimezone());

final getLocationProvider = FutureProvider.family<LocationModel, int>(
    (ref, locationId) =>
        LocationServices().getLocationFromLocationID(locationId));

final appVersionProvider = FutureProvider<String>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
});

final getSubscriptionFromApiProvider =
    FutureProvider.family.autoDispose<SquareSubscriptionModel, String>(
  (ref, subscriptionId) =>
      SubscriptionServices().getSubscriptionFromApi(subscriptionId),
);

final getSubscriptionInvoiceFromApiProvider =
    FutureProvider.family.autoDispose<List<SubscriptionInvoiceModel>, String>(
  (ref, squareCustomerId) => SubscriptionServices().getSubscriptionInvoices(
    squareCustomerId,
  ),
);

final cardDetailsFromSquareCardIdProvider =
    FutureProvider.family<PaymentsModel, Tuple2>((ref, params) {
  String userId = params.item1;
  String cardId = params.item2;
  return PaymentMethodDatabaseServices()
      .getCardDetailsFromSquareCardId(userId, cardId);
});

final isBreakingChangeProvider = FutureProvider<bool>((ref) async {
  // Get current app version
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersionParts = packageInfo.version.split('.');

  // Check for new version on app stores
  final checker = InStoreAppVersionChecker();
  final result = await checker.checkUpdate();

  // Ensure newVersion is not null before splitting
  final newVersion = result.newVersion ??
      packageInfo.version; // Use current version as fallback
  final newVersionParts = newVersion.split('.');

  // Compare major version numbers to determine if a breaking update is needed
  if (newVersionParts.isNotEmpty && currentVersionParts.isNotEmpty) {
    return int.parse(newVersionParts[0]) > int.parse(currentVersionParts[0]);
  }
  return false;
});
