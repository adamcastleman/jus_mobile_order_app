import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Wallets/load_money_and_pay_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/large_apple_pay_button.dart';

class PaymentsHelper {
  final WidgetRef? ref;
  final BuildContext? context;

  PaymentsHelper({this.ref, this.context});

  Map setSelectedPaymentMap({
    String? cardNickname,
    required String lastFourDigits,
    required String brand,
    required bool isWallet,
    String? nonce,
    String? gan,
    int? balance,
  }) {
    return {
      'cardNickname': cardNickname,
      'nonce': nonce,
      'gan': gan,
      'balance': balance,
      'lastFourDigits': lastFourDigits,
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
                nonce: eligibleCard.nonce,
                gan: eligibleCard.gan,
                brand: eligibleCard.brand,
                balance: eligibleCard.balance,
                lastFourDigits: eligibleCard.lastFourDigits),
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
            : getBrandName(selectedPayment['brand']);
    final lastFourDigits = ' x${selectedPayment['lastFourDigits']}';

    return [cardNickname, brandName, lastFourDigits].join().trim();
  }

  String displaySelectedCardTextFromPaymentModel(PaymentsModel card) {
    final cardNickname =
        card.cardNickname.isEmpty ? '' : '${card.cardNickname} ';
    final brandName = card.isWallet ? '' : '- ${getBrandName(card.brand)} ';
    final lastFourDigits = 'x${card.lastFourDigits}';

    return [cardNickname, brandName, lastFourDigits].join().trim();
  }

  String getBrandName(String brand) {
    switch (brand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'americanExpress':
        return 'AmEx';
      case 'discover':
        return 'Discover';
      case 'jcb':
        return 'JCB';
      case 'china_union_pay':
        return 'China UnionPay';
      case 'interac':
        return 'Interac';
      case 'discoverDiners':
        return 'Diners Club';
      default:
        return 'My Card';
    }
  }

  Widget addPaymentMethodButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    return LargeElevatedButton(
        buttonText: 'Add Payment Method',
        onPressed: () {
          PaymentsServices(
                  context: context,
                  ref: ref,
                  userID: user.uid,
                  firstName: user.firstName)
              .initSquarePayment();
        });
  }

  Widget payWithPaymentMethodButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final loading = ref.watch(loadingProvider);
    var message = OrderHelpers(ref: ref).validateOrder(context);
    final selectedPaymentText =
        'Pay with ${PaymentsHelper().displaySelectedCardTextFromMap(selectedPayment)}';
    final totalPrice = user.uid == null || !user.isActiveMember!
        ? Pricing(ref: ref).orderTotalForNonMembers() * 100
        : Pricing(ref: ref).orderTotalForMembers() * 100;

    if (loading) {
      return const LargeElevatedLoadingButton();
    }

    void handleButtonPress() {
      if (message != null) {
        OrderHelpers(ref: ref).showInvalidOrderModal(context, message);
      } else {
        ref.read(loadingProvider.notifier).state = true;
        PaymentsHelper(ref: ref).processPayment(context, user);
      }
    }

    return selectedPayment['balance'] != null &&
            totalPrice > selectedPayment['balance']
        ? LargeElevatedButton(
            buttonText: 'Load Money and Pay',
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(walletTypeProvider.notifier).state =
                  WalletType.loadAndPay;
              ModalBottomSheet().partScreen(
                enableDrag: true,
                isDismissible: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => const LoadWalletAndPaySheet(),
              );
            },
          )
        : LargeElevatedButton(
            buttonText: selectedPaymentText,
            onPressed: handleButtonPress,
          );
  }

  Widget payWithApplePayButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    final loading = ref.watch(applePayLoadingProvider);

    if (Platform.isIOS) {
      if (loading == true) {
        return const LargeElevatedLoadingButton();
      }
      return LargeApplePayButton(
        onPressed: () {
          ref.read(applePaySelectedProvider.notifier).state = true;
          ref.read(applePayLoadingProvider.notifier).state = true;
          HapticFeedback.mediumImpact();
          final errorMessage = OrderHelpers(ref: ref).validateOrder(context);
          if (errorMessage != null) {
            OrderHelpers(ref: ref).showInvalidOrderModal(context, errorMessage);
          } else {
            PaymentsServices(ref: ref).initApplePayPayment(context, user);
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget noChargeButton(BuildContext context, WidgetRef ref, UserModel user) {
    final loading = ref.watch(loadingProvider);
    if (loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return LargeElevatedButton(
        buttonText: 'No Charge - Finish Checkout',
        onPressed: () {
          ref.read(loadingProvider.notifier).state = true;
          var message = OrderHelpers(ref: ref).validateOrder(context);
          if (message != null) {
            OrderHelpers(ref: ref).showInvalidOrderModal(context, message);
          } else {
            PaymentsHelper(ref: ref).processPayment(context, user);
          }
        },
      );
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

    final nonce =
        totalInCents + tipTotalInCents == 0 ? null : selectedCard['nonce'];
    final gan = selectedCard['gan'];
    final paymentMethod =
        totalInCents + tipTotalInCents == 0 ? 'storeCredit' : 'card';

    return {
      'userDetails': {
        'isGuest': user.uid == null ? true : false,
        'firstName': user.uid == null ? firstName : user.firstName,
        'lastName': user.uid == null ? lastName : user.lastName,
        'email': user.uid == null ? email : user.email,
        'phone': user.uid == null ? phone : user.phone,
        'memberSavings': totals['totalSavedInCents']
      },
      'locationDetails': {
        'locationID': selectedLocation.locationID,
        'locationName': selectedLocation.name,
        'locationTimezone': selectedLocation.timezone,
      },
      'paymentDetails': {
        'nonce': nonce,
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

  void processPayment(BuildContext context, UserModel user) {
    PaymentsServices(ref: ref, context: context)
        .chargeCardAndCreateOrder(user)
        .then(
          (result) =>
              PaymentsServices(ref: ref).handlePaymentResult(context, result),
        );
  }
}
