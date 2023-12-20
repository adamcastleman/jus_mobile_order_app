import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Models/membership_stats_model.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Services/announcement_services.dart';
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
import 'package:jus_mobile_order_app/Services/user_services.dart';

import '../Models/payments_model.dart';

final authProvider = StreamProvider<UserModel?>((ref) {
  return AuthServices().user;
});

final locationsProvider =
    StreamProvider<List<LocationModel>>((ref) => LocationServices().locations);

final productsProvider =
    StreamProvider<List<ProductModel>>((ref) => ProductServices().products);

final currentUserProvider = StreamProvider<UserModel>((ref) {
  final auth = ref.watch(authProvider);
  return UserServices(
      uid: auth.maybeWhen(
    data: (userModel) => userModel?.uid,
    orElse: () => null,
  )).user;
});

final defaultPaymentMethodProvider = StreamProvider<PaymentsModel>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userID: auth.value?.uid)
      .defaultPaymentCard;
});

final creditCardPaymentMethodsProvider =
    StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userID: auth.value?.uid)
      .squareCreditCards;
});

final walletPaymentMethodsProvider = StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentMethodDatabaseServices(userID: auth.value?.uid).wallets;
});

final ingredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().ingredients);

final modifiableIngredientsProvider = StreamProvider<List<IngredientModel>>(
  (ref) => IngredientServices().modifiableIngredients,
);

final allergenIngredientsProvider = StreamProvider<List<IngredientModel>>(
  (ref) => IngredientServices().allergenIngredients,
);

final blendOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().blendOnlyIngredients);

final toppingsOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().toppingsOnlyIngredients);

final taxableProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().taxableProducts);

final recommendedProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().recommendedProducts);

final newProductsProvider =
    StreamProvider<List<ProductModel>>((ref) => ProductServices().newProducts);

final productQuantityLimitProvider =
    StreamProvider.family<ProductQuantityModel, QuantityLimitParams>(
        (ref, params) {
  final productUID = params.productUID;
  final locationID = params.locationID;
  return ProductServices(locationID: locationID, productUID: productUID)
      .quantityLimits;
});

final membershipDetailsProvider = StreamProvider<MembershipDetailsModel>(
    (ref) => MembershipDetailsServices().membershipDetails);

final favoritesProvider = StreamProvider<List<FavoritesModel>>((ref) {
  final auth = ref.watch(authProvider);
  return FavoritesServices(userID: auth.value?.uid).favorites;
});

final pointsDetailsProvider = StreamProvider<PointsDetailsModel>(
    (ref) => PointsDetailsServices().pointsDetails);

final emptyCartImageProvider =
    StreamProvider((ref) => ImageServices().emptyCartImage);

final signInImageProvider =
    StreamProvider((ref) => ImageServices().signInImage);

final deleteAccountImageProvider =
    StreamProvider((ref) => ImageServices().deleteAccount);

final offersProvider = StreamProvider((ref) => OffersServices().offers);

final announcementsProvider =
    StreamProvider((ref) => AnnouncementServices().announcements);

final ordersProvider = StreamProvider.family<List<OrderModel>, String>(
    (ref, userID) => OrderServices(userID: userID).orders);

final walletActivitiesProvider =
    StreamProvider.family<List<WalletActivitiesModel>, String>((ref, userID) {
  return PaymentMethodDatabaseServices(userID: userID).walletActivities;
});

final memberStatsProvider = StreamProvider.family<MembershipStatsModel, String>(
    (ref, userID) => UserServices(uid: userID).membershipStats);
