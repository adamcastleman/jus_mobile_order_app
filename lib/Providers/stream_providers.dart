import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/app_store_ids_model.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Models/points_activity_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Services/announcement_services.dart';
import 'package:jus_mobile_order_app/Services/app_services.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/favorites_services.dart';
import 'package:jus_mobile_order_app/Services/image_services.dart';
import 'package:jus_mobile_order_app/Services/ingredient_services.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Services/membership_details_services.dart';
import 'package:jus_mobile_order_app/Services/offers_services.dart';
import 'package:jus_mobile_order_app/Services/order_services.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/Services/points_details_services.dart';
import 'package:jus_mobile_order_app/Services/product_services.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';

import '../Models/payments_model.dart';

final appStoreIdsProvider =
    StreamProvider<AppStoreIdsModel>((ref) => AppServices().appStoreIds);

final authProvider = StreamProvider<UserModel?>((ref) {
  return AuthServices().user;
});

final currentUserProvider = StreamProvider<UserModel>((ref) {
  final auth = ref.watch(authProvider);
  return UserServices(
      uid: auth.maybeWhen(
    data: (userModel) => userModel?.uid,
    orElse: () => null,
  )).user;
});

final locationsProvider =
    StreamProvider<List<LocationModel>>((ref) => LocationServices().locations);

final productsProvider =
    StreamProvider<List<ProductModel>>((ref) => ProductServices().products);

final defaultPaymentMethodProvider = StreamProvider<PaymentsModel>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userId: auth.value?.uid)
      .defaultPaymentCard;
});

final creditCardPaymentMethodsProvider =
    StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userId: auth.value?.uid)
      .squareCreditCards;
});

final walletPaymentMethodsProvider = StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userId: auth.value?.uid).wallets;
});

final ingredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().ingredients);

final productQuantityLimitProvider =
    StreamProvider.family<ProductQuantityModel, QuantityLimitParams>(
        (ref, params) {
  final productUID = params.productUID;
  final locationId = params.locationId;

  return ProductServices(locationId: locationId, productUID: productUID)
      .quantityLimits;
});

final membershipDetailsProvider = StreamProvider<MembershipDetailsModel>(
    (ref) => MembershipDetailsServices().membershipDetails);

final favoritesProvider =
    StreamProvider.autoDispose<List<FavoritesModel>>((ref) {
  final auth = ref.watch(authProvider).value;
  return FavoritesServices(
          userId: auth == null ? 'dummyDocumentName' : auth.uid)
      .favorites;
});

final pointsDetailsProvider = StreamProvider<PointsDetailsModel>(
    (ref) => PointsDetailsServices().pointsDetails);

final pointsActivityProvider =
    StreamProvider.family<List<PointsActivityModel>, String>(
        (ref, userId) => PointsDetailsServices(userId: userId).pointsActivity);

final deleteAccountImageProvider =
    StreamProvider((ref) => ImageServices().deleteAccount);

final displayImagesProvider =
    StreamProvider((ref) => ImageServices().displayImages);

final offersProvider = StreamProvider((ref) => OffersServices().offers);

final announcementsProvider =
    StreamProvider((ref) => AnnouncementServices().announcements);

final topBannerProvider =
    StreamProvider((ref) => AnnouncementServices().topBanner);

final ordersProvider = StreamProvider.family<List<OrderModel>, String>(
    (ref, userID) => OrderServices(userId: userID).orders);

final walletActivitiesProvider =
    StreamProvider.family<List<WalletActivitiesModel>, String>((ref, userId) {
  return PaymentMethodDatabaseServices(userId: userId).walletActivities;
});

final subscriptionDataProvider =
    StreamProvider.family<SubscriptionModel, String>(
        (ref, userID) => SubscriptionServices(uid: userID).subscriptionData);
