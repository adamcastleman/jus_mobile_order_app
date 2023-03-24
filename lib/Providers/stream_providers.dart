import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Services/announcement_services.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/favorites_services.dart';
import 'package:jus_mobile_order_app/Services/image_services.dart';
import 'package:jus_mobile_order_app/Services/ingredient_services.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Services/membership_details_services.dart';
import 'package:jus_mobile_order_app/Services/offers_services.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
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
  return UserServices(uid: auth.value?.uid).user;
});

final defaultPaymentMethodProvider = StreamProvider<PaymentsModel>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentsServices(userID: auth.value?.uid).defaultPaymentCard;
});

final creditCardPaymentMethods = StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentsServices(userID: auth.value?.uid).squareCreditCards;
});

final giftCardPaymentMethods = StreamProvider<List<PaymentsModel>>((ref) {
  final auth = ref.watch(authProvider);
  return PaymentsServices(userID: auth.value?.uid).squareGiftCards;
});

final ingredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().ingredients);

final modifiableIngredientsProvider = StreamProvider<List<IngredientModel>>(
  (ref) => IngredientServices().modifiableIngredients,
);

final blendOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().blendOnlyIngredients);

final toppingsOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().toppingsOnlyIngredients);

final taxableProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().taxableProducts);

final recommendedProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().recommendedProducts);

final membershipDetailsProvider = StreamProvider<MembershipDetailsModel>(
    (ref) => MembershipDetailsServices().membershipDetails);

final favoritesProvider = StreamProvider<List<FavoritesModel>>((ref) {
  final auth = ref.watch(authProvider);
  return FavoritesServices(uid: auth.value?.uid).favorites;
});

final pointsDetailsProvider = StreamProvider<PointsDetailsModel>(
    (ref) => PointsDetailsServices().pointsDetails);

final emptyCartImageProvider =
    StreamProvider((ref) => ImageServices().emptyCartImage);

final signInImageProvider =
    StreamProvider((ref) => ImageServices().signInImage);

final offersProvider = StreamProvider((ref) => OffersServices().offers);

final announcementsProvider =
    StreamProvider((ref) => AnnouncementServices().announcements);
