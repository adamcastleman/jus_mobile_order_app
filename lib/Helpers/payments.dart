import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/order_confirmation_sheet.dart';

class PaymentsHelper {
  final WidgetRef? ref;
  final BuildContext? context;

  PaymentsHelper({this.ref, this.context});

  Map setSelectedPaymentMap({
    String? cardNickname,
    required String last4,
    required String brand,
    required bool isWallet,
    String? cardId,
    String? gan,
    int? balance,
  }) {
    return {
      'cardNickname': cardNickname,
      'cardId': cardId,
      'gan': gan,
      'balance': balance,
      'last4': last4,
      'brand': brand,
      'isWallet': isWallet,
    };
  }

  setSelectedPaymentToValidPaymentMethod(List<PaymentsModel> creditCards) {
    if (creditCards.isEmpty) {
      ref!
          .read(selectedPaymentMethodProvider.notifier)
          .updateSelectedPaymentMethod(card: {});
    } else {
      final eligibleCard =
          creditCards.firstWhere((element) => !element.isWallet);
      ref!
          .read(selectedPaymentMethodProvider.notifier)
          .updateSelectedPaymentMethod(
            card: PaymentsHelper().setSelectedPaymentMap(
              cardNickname: eligibleCard.cardNickname,
              isWallet: eligibleCard.isWallet,
              cardId: eligibleCard.cardId,
              gan: eligibleCard.gan,
              brand: eligibleCard.brand,
              balance: eligibleCard.balance,
              last4: eligibleCard.last4,
            ),
          );
    }
  }

  String displaySelectedCardTextFromMap(Map selectedPayment) {
    final cardNickname = selectedPayment['cardNickname'] == null
        ? ''
        : '${selectedPayment['cardNickname']} - ';
    final brandName = selectedPayment['isWallet'] == null
        ? ''
        : selectedPayment['isWallet']
            ? 'Wallet'
            : displayBrandName(selectedPayment['brand']);
    final last4 = ' x${selectedPayment['last4']}';

    return [cardNickname, brandName, last4].join().trim();
  }

  String displaySelectedCardTextFromPaymentModel(PaymentsModel card) {
    final cardNickname =
        card.cardNickname.isEmpty ? '' : '${card.cardNickname} ';
    final brandName = card.isWallet ? '' : '- ${displayBrandName(card.brand)} ';
    final last4 = 'x${card.last4}';

    return [cardNickname, brandName, last4].join().trim();
  }

  String displayBrandName(String brand) {
    var normalizedBrand =
        brand.toLowerCase().replaceAll('_', '').replaceAll(' ', '');

    switch (normalizedBrand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'AmEx';
      case 'americanexpress':
        return 'AmEx';
      case 'discover':
        return 'Discover';
      case 'jcb':
        return 'JCB';
      case 'chinaunionpay':
        return 'China UnionPay';
      case 'interac':
        return 'Interac';
      case 'dinersclub':
        return 'Diners Club';
      case 'discoverdiners':
        return 'Diners Club';
      default:
        return 'My Card';
    }
  }

  Map<String, int> calculatePricingAndTotals(UserModel user) {
    final pricing = Pricing(ref: ref);
    final isMember = user.uid != null && user.isActiveMember == true;
    final originalSubtotal = isMember
        ? pricing.originalSubtotalForMembers()
        : pricing.originalSubtotalForNonMembers();
    final discountedSubtotal = isMember
        ? pricing.discountedSubtotalForMembers()
        : pricing.discountedSubtotalForNonMembers();
    final tax = isMember
        ? pricing.totalTaxForMembers()
        : pricing.totalTaxForNonMembers();
    final discountTotal = isMember
        ? pricing.discountTotalForMembers()
        : pricing.discountTotalForNonMembers();
    final tipTotal = isMember
        ? pricing.tipAmountForMembers()
        : pricing.tipAmountForNonMembers();

    final totalSaved = isMember ? pricing.totalOrderSavings() : 0;

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

  Map<String, dynamic> generateOrderMap(
      UserModel user, Map<String, int?> totals) {
    final selectedLocation = ref!.watch(selectedLocationProvider);
    final selectedCard = ref!.watch(selectedPaymentMethodProvider);
    final pickupTime = ref!.watch(selectedPickupTimeProvider);
    final pickupDate = ref!.watch(selectedPickupDateProvider);
    final scheduleAllItems = ref!.watch(scheduleAllItemsProvider);

    final firstName = ref!.watch(firstNameProvider);
    final lastName = ref!.watch(lastNameProvider);
    final email = ref!.watch(emailProvider);
    final phone = ref!.watch(phoneProvider);

    final List items = ProductHelpers(ref: ref!).generateProductList();
    final points = PointsHelper(ref: ref!).totalEarnedPoints();
    final pointsMultiple = PointsHelper(ref: ref!).determinePointsMultiple();
    final pointsInUse = ref!.watch(pointsInUseProvider);

    final int totalInCents = totals['totalInCents'] ?? 0;
    final int tipTotalInCents = totals['tipTotalInCents'] ?? 0;

    final cardId =
        totalInCents + tipTotalInCents == 0 ? null : selectedCard['cardId'];
    final gan = selectedCard['gan'];
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
        'locationID': selectedLocation.locationID,
        'squareLocationId': selectedLocation.squareLocationId,
        'locationTaxRate': selectedLocation.salesTaxRate,
        'locationName': selectedLocation.locationName,
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
        'orderSource': (Platform.isIOS || Platform.isAndroid)
            ? 'Mobile Order'
            : (Platform.isMacOS || Platform.isWindows)
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
        'bonusPoints': user.uid == null || !user.isActiveMember!
            ? 0
            : (points / pointsMultiple).floor(),
      }
    };
  }

  void showPaymentSuccessModal(BuildContext context) {
    ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => const OrderConfirmationSheet(),
    );
  }

  void showPaymentErrorModal(BuildContext context, String error) {
    ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => InvalidSheetSinglePop(error: error),
    );
  }
}
