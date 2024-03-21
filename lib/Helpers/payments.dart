import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/order_item_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Sheets/order_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/toast.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsHelpers {
  static setCreditCardAsSelectedPaymentMethodWithSquareCardDetails(
      WidgetRef ref, UserModel user, CardDetails cardDetails) {
    var reference = ref.read(selectedPaymentMethodProvider.notifier);
    reference.updateSelectedPaymentMethod(
      cardNickname: user.firstName ?? '',
      cardId: cardDetails.nonce,
      brand: cardDetails.card.brand.name,
      isWallet: false,
      last4: cardDetails.card.lastFourDigits,
    );
  }

  static void onWalletActivitySuccess(BuildContext context, WidgetRef ref,
      {required String message}) {
    invalidateLoadingProviders(ref);
    ToastHelper.showToast(message: message);
    Navigator.pop(context);
  }

  static void onOrderSuccess(BuildContext context, WidgetRef ref) {
    invalidateLoadingProviders(ref);
    showPaymentSuccessModal(context);
  }

  static void showPaymentSuccessModal(BuildContext context) {
    ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => const OrderConfirmationSheet(),
    );
  }

  static void showPaymentErrorModal(
      BuildContext context, WidgetRef ref, String error) {
    invalidateLoadingProviders(ref);
    ErrorHelpers.showSinglePopError(context, error: error);
  }

  static Map<String, int> generateOrderPricingDetails(
      WidgetRef ref, UserModel user) {
    final pricing = PricingHelpers();
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final originalSubtotal = isMember
        ? pricing.originalSubtotalForMembers(ref)
        : pricing.originalSubtotalForNonMembers(ref);
    final discountedSubtotal = isMember
        ? pricing.discountedSubtotalForMembers(ref)
        : pricing.discountedSubtotalForNonMembers(ref);
    final tax = isMember
        ? pricing.totalTaxForMembers(ref)
        : pricing.totalTaxForNonMembers(ref);
    final discountTotal = isMember
        ? pricing.discountTotalForMembers(ref)
        : pricing.discountTotalForNonMembers(ref);
    final tipTotal = isMember
        ? pricing.tipAmountForMembers(ref)
        : pricing.tipAmountForNonMembers(ref);

    final totalSaved = isMember ? pricing.totalOrderSavings(ref) : 0;

    final totalInCents = ((discountedSubtotal + tax) * 100).round();
    final originalSubtotalInCents = (originalSubtotal * 100).round();
    final discountedSubtotalInCents = (discountedSubtotal * 100).round();
    final taxTotalInCents = (tax * 100).round();
    final tipTotalInCents = (tipTotal * 100).round();
    final discountTotalInCents = (discountTotal * 100).round();
    final totalSavedInCents = (totalSaved * 100).round();

    return {
      'originalSubtotalInCents': originalSubtotalInCents,
      'totalInCents': totalInCents,
      'discountedSubtotalInCents': discountedSubtotalInCents,
      'taxTotalInCents': taxTotalInCents,
      'tipTotalInCents': tipTotalInCents,
      'discountTotalInCents': discountTotalInCents,
      'totalSavedInCents': totalSavedInCents,
    };
  }

  static Map<String, dynamic> generateCreateWalletOrderDetails({
    required UserModel user,
    required String cardId,
    required String loadAmount,
  }) {
    return {
      'paymentDetails': {
        'cardId': cardId,
        'amount': loadAmount,
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'email': user.email,
        'squareCustomerId': user.squareCustomerId,
      },
      'cardDetails': {
        'type': 'DIGITAL',
      },
    };
  }

  static Map<String, dynamic> generateAddFundsToWalletOrderDetails(
      {required UserModel user,
      required String cardId,
      required String gan,
      required String walletUid,
      required String loadAmount}) {
    return {
      'paymentDetails': {
        'cardId': cardId,
        'gan': gan,
        'amount': loadAmount,
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'userId': user.uid,
        'email': user.email,
        'squareCustomerId': user.squareCustomerId,
      },
      'metadata': {
        'walletUID': walletUid,
      }
    };
  }

  Map<String, dynamic> generateOrderDetails(
      WidgetRef ref, UserModel user, Map<String, int?> totals) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final pointsInformation = ref.watch(pointsInformationProvider);
    final selectedCard = ref.watch(selectedPaymentMethodProvider);
    final pickupTime = ref.watch(selectedPickupTimeProvider);
    final pickupDate = ref.watch(selectedPickupDateProvider);
    final scheduleAllItems = ref.watch(scheduleAllItemsProvider);

    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final email = ref.watch(emailProvider);
    final phone = ref.watch(phoneProvider);
    final PointsHelper pointsHelper = PointsHelper();

    final List items = _generateProductList(ref, user);
    final points = pointsHelper.totalEarnedPoints(ref, user, pointsInformation);
    final pointsMultiple =
        pointsHelper.determinePointsMultiple(ref, user, pointsInformation);
    final pointsInUse = ref.watch(pointsInUseProvider);

    final int totalInCents = totals['totalInCents'] ?? 0;
    final int tipTotalInCents = totals['tipTotalInCents'] ?? 0;

    final cardId =
        totalInCents + tipTotalInCents == 0 ? null : selectedCard.cardId;
    final gan = selectedCard.gan;
    final paymentMethod =
        totalInCents + tipTotalInCents == 0 ? 'storeCredit' : 'card';

    return {
      'userDetails': {
        'isGuest': user.uid == null ? true : false,
        'firstName': user.uid == null ? firstName : user.firstName,
        'lastName': user.uid == null ? lastName : user.lastName,
        'email': user.uid == null ? email : user.email,
        'squareCustomerId': user.uid == null ? '' : user.squareCustomerId,
        'phone': user.uid == null ? phone : user.phone,
        'memberSavings': totals['totalSavedInCents']
      },
      'locationDetails': {
        'locationId': selectedLocation.locationId,
        'squareLocationId': selectedLocation.squareLocationId,
        'locationTaxRate': selectedLocation.salesTaxRate,
        'locationName': selectedLocation.name,
        'locationTimezone': selectedLocation.timezone,
      },
      'paymentDetails': {
        'cardId': cardId,
        'gan': gan,
        'paymentMethod': paymentMethod,
        'externalPaymentType':
            paymentMethod == 'storeCredit' ? 'STORED_BALANCE' : '',
        'currency': selectedLocation.currency,
      },
      'orderDetails': {
        'orderSource': (PlatformUtils.isIOS() || PlatformUtils.isAndroid())
            ? 'Mobile Order'
            : (PlatformUtils.isWeb())
                ? 'Web Order'
                : 'In-Store',
        'scheduleAllItems': scheduleAllItems,
        'pickupTime':
            items.every((element) => element['isScheduled']) || scheduleAllItems
                ? null
                : pickupTime?.millisecondsSinceEpoch,
        'pickupDate': pickupDate?.millisecondsSinceEpoch,
        'items': items,
      },
      'totals': {
        'totalAmount': totals['totalInCents'],
        'originalSubtotalAmount': totals['originalSubtotalInCents'],
        'discountedSubtotalAmount': totals['discountedSubtotalInCents'],
        'discountAmount': totals['discountTotalInCents'],
        'taxAmount': totals['taxTotalInCents'],
        'tipAmount': totals['tipTotalInCents'],
      },
      'pointsDetails': {
        'pointsEarned': points,
        'pointsRedeemed': pointsInUse,
        'bonusPoints': user.uid == null ||
                user.subscriptionStatus != SubscriptionStatus.active
            ? 0
            : (points / pointsMultiple).floor(),
      }
    };
  }

  List _generateProductList(WidgetRef ref, UserModel user) {
    final currentOrderItems = ref.watch(currentOrderItemsProvider);
    final currentOrderCosts = ref.watch(currentOrderCostProvider);
    final listOfDiscounts = ref.watch(discountTotalProvider);
    final products = ref.watch(allProductsProvider);
    final ingredients = ref.watch(allIngredientsProvider);

    List listOfProducts = [];

    for (var index = 0; index < currentOrderItems.length; index++) {
      final productId = currentOrderItems[index]['productId'];
      final currentProduct =
          products.firstWhere((element) => element.productId == productId);

      final itemMap = _generateItemsMap(
        ref,
        user,
        currentOrderItems,
        currentOrderCosts,
        listOfDiscounts,
        index,
        currentProduct,
        products,
        ingredients,
      );
      listOfProducts.add(itemMap);
    }

    return listOfProducts;
  }

  Map _generateItemsMap(
    WidgetRef ref,
    UserModel user,
    List currentOrderItems,
    List currentOrderCosts,
    List listOfDiscounts,
    int index,
    ProductModel currentProduct,
    List<ProductModel> product,
    List<IngredientModel> ingredients,
  ) {
    String itemKey = currentOrderItems[index]['itemKey'];

    OrderItem orderItem = OrderItem(
      productName: currentProduct.name,
      image: currentProduct.image,
      category: currentProduct.category,
      productId: currentProduct.productId,
      itemDiscount:
          _determineItemDiscountAmount(user, itemKey, listOfDiscounts),
      discountName:
          _determineItemDiscountName(itemKey, listOfDiscounts).isNotEmpty
              ? _determineItemDiscountName(itemKey, listOfDiscounts).capitalize
              : '',
      itemQuantity: currentOrderItems[index]['itemQuantity'],
      scheduledQuantity: currentOrderItems[index]['scheduledQuantity'],
      size: currentProduct.variations[currentOrderItems[index]['itemSize']]
          ['name'],
      squareVariationId:
          currentProduct.variations[currentOrderItems[index]['itemSize']]
              ['squareVariationId'],
      isScheduled: currentProduct.isScheduled,
      scheduledDescriptor: currentProduct.isScheduled
          ? currentOrderItems[index]['scheduledDescriptor']
          : '',
      modifications: _buildIngredientModificationsList(
          ref, index, user, currentOrderItems, ingredients),
      allergies: _buildAllergiesList(currentOrderItems[index], ingredients),
      price: _determineItemPrice(user, itemKey, currentOrderCosts),
      modifierPrice: _determineModifierPrice(user, itemKey, currentOrderCosts),
    );

    //Return OrderItem as a map for submit
    return orderItem.toMap();
  }

  int _determineItemPrice(
      UserModel user, String itemKey, List currentOrderCosts) {
    int itemPriceNonMember = currentOrderCosts
        .firstWhere((element) => element['itemKey'] == itemKey,
            orElse: () => <String, dynamic>{})['itemPriceNonMember']
        .toInt();
    int itemPriceMember = currentOrderCosts
        .firstWhere((element) => element['itemKey'] == itemKey,
            orElse: () => <String, dynamic>{})['itemPriceMember']
        .toInt();
    if (user.uid == null ||
        user.subscriptionStatus != SubscriptionStatus.active) {
      return itemPriceNonMember;
    } else {
      return itemPriceMember;
    }
  }

  int _determineModifierPrice(
      UserModel user, String itemKey, List currentOrderCosts) {
    int modifierPriceNonMember = currentOrderCosts
        .firstWhere((element) => element['itemKey'] == itemKey,
            orElse: () => <String, dynamic>{})['modifierPriceNonMember']
        .toInt();
    int modifierPriceMember = currentOrderCosts
        .firstWhere((element) => element['itemKey'] == itemKey,
            orElse: () => <String, dynamic>{})['modifierPriceMember']
        .toInt();
    if (user.uid == null ||
        user.subscriptionStatus != SubscriptionStatus.active) {
      return modifierPriceNonMember;
    } else {
      return modifierPriceMember;
    }
  }

  int _determineItemDiscountAmount(
      UserModel user, String itemKey, List listOfDiscounts) {
    //beginning discounts at $0
    int itemDiscount = 0;
    double itemDiscountNonMember = 0;
    double itemDiscountMember = 0;

    if (listOfDiscounts.isNotEmpty) {
      var discountElement = listOfDiscounts.firstWhere(
          (element) => element['itemKey'] == itemKey,
          orElse: () => null);

      if (discountElement != null) {
        itemDiscountNonMember = discountElement['price'] ?? 0;
        itemDiscountMember = discountElement['memberPrice'] ?? 0;
      }
    }

    itemDiscount = (user.uid == null ||
            user.subscriptionStatus != SubscriptionStatus.active)
        ? itemDiscountNonMember.toInt()
        : itemDiscountMember.toInt();

    return itemDiscount;
  }

  String _determineItemDiscountName(String itemKey, List listOfDiscounts) {
    // Initialize discountName with a default value of an empty string
    String discountName = '';

    if (listOfDiscounts.isNotEmpty) {
      var discountElement = listOfDiscounts.firstWhere(
        (element) => element['itemKey'] == itemKey,
        orElse: () => null,
      );

      if (discountElement != null && discountElement['source'] != null) {
        // Update discountName only if discountElement is found
        // and ensure that discountElement['source'] is not null before calling capitalize()
        discountName = discountElement['source'];
      }
    }

    // Return the determined discount name or an empty string if no discount is applicable
    return discountName;
  }

  List _buildIngredientModificationsList(
      WidgetRef ref,
      int index,
      UserModel user,
      List currentOrderItems,
      List<IngredientModel> ingredients) {
    List selectedToppingsList =
        _buildSelectedToppingsList(ref, currentOrderItems[index], ingredients);
    List addedList = _buildAddedList(
        ref, currentOrderItems[index], ingredients, user, index);
    List adjustedList =
        _buildAdjustedList(ref, currentOrderItems[index], ingredients, index);
    List removedList =
        _buildRemovedList(ref, currentOrderItems[index], ingredients, index);

    List ingredientModificationList = [
      ...selectedToppingsList,
      ...removedList,
      ...adjustedList,
      ...addedList
    ];
    return ingredientModificationList;
  }

  List<String> _buildSelectedToppingsList(
      WidgetRef ref, Map order, List<IngredientModel> ingredients) {
    List<String> selectedToppingsList = [];
    List selectedToppings = order['selectedToppings'];

    for (var id in selectedToppings) {
      final ingredient = ingredients.firstWhere((element) => element.id == id);
      selectedToppingsList.add('{"name": "+${ingredient.name}", "price": "0"}');
    }

    return selectedToppingsList;
  }

  List<String> _buildAddedList(WidgetRef ref, Map order,
      List<IngredientModel> ingredients, UserModel user, int index) {
    final ProductHelpers productHelpers = ProductHelpers();
    List<String> addedList = [];
    List added = productHelpers.addedItems(ref, index);

    for (var addedIngredient in added) {
      final ingredient = ingredients
          .firstWhere((element) => element.id == addedIngredient['id']);
      final selectedIngredient = order['selectedIngredients']
          .firstWhere((element) => element['id'] == ingredient.id);

      int premiumIngredientPrice = double.parse(user.uid == null ||
                  user.subscriptionStatus != SubscriptionStatus.active
              ? (selectedIngredient['price'])
              : (selectedIngredient['memberPrice']))
          .toInt();
      String blendedOrTopping = productHelpers.blendedOrToppingDescription(
          ref, added, ingredient, index, added.indexOf(addedIngredient));
      var amount = productHelpers.modifiedIngredientAmount(
          added, ingredient, added.indexOf(addedIngredient));
      var extraChargeIngredientAmount = productHelpers
          .extraChargeIngredientQuantity(added, added.indexOf(addedIngredient));

      addedList.add(
          '{"name": "$blendedOrTopping ${ingredient.name}$amount$extraChargeIngredientAmount", "price": "$premiumIngredientPrice"}');
    }

    return addedList;
  }

  List<String> _buildAdjustedList(
      WidgetRef ref, Map order, List<IngredientModel> ingredients, int index) {
    List<String> adjustedList = [];
    final ProductHelpers productHelpers = ProductHelpers();
    List adjusted = productHelpers.modifiedStandardItems(ref, index);

    for (var adjustedIngredient in adjusted) {
      final ingredient = ingredients
          .firstWhere((element) => element.id == adjustedIngredient['id']);
      String adjustedDescriptor =
          productHelpers.getBlendedAndToppedStandardIngredientAmount(
              adjusted, ingredient, adjusted.indexOf(adjustedIngredient));
      adjustedList.add('{"name": "$adjustedDescriptor", "price": "0"}');
    }

    return adjustedList;
  }

  List<String> _buildRemovedList(
      WidgetRef ref, Map order, List<IngredientModel> ingredients, int index) {
    List<String> removedList = [];
    List removed = ProductHelpers().removedItems(ref, index);

    for (var removedIngredient in removed) {
      final ingredient =
          ingredients.firstWhere((element) => element.id == removedIngredient);

      removedList.add('{"name": "No ${ingredient.name}",  "price": "0"}');
    }

    return removedList;
  }

  List<String> _buildAllergiesList(
      Map order, List<IngredientModel> ingredients) {
    List<String> allergiesList = [];
    List allergies = order['allergies'];

    for (var allergy in allergies) {
      final ingredient =
          ingredients.firstWhere((element) => element.id == allergy);
      allergiesList.add(ingredient.name);
    }

    return allergiesList;
  }
}
