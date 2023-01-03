import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/ingredient_services.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Services/product_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';

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

final ingredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().ingredients);

final modifiableIngredientsProvider = StreamProvider<List<IngredientModel>>(
  (ref) => IngredientServices().modifiableIngredients,
);

final blendOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().blendOnlyIngredients);

final toppingsOnlyIngredientsProvider = StreamProvider<List<IngredientModel>>(
    (ref) => IngredientServices().toppingsOnlyIngredients);
