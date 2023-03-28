import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class PaymentsHelper {
  void updatePaymentMethod(
      {required SelectedPaymentMethodNotifier reference,
      String? cardNickname,
      required bool isGiftCard,
      required String nonce,
      required String lastFourDigits,
      required String brand}) {
    reference.updateSelectedPaymentMethod(
      card: {
        'cardNickname': cardNickname,
        'nonce': nonce,
        'lastFourDigits': lastFourDigits,
        'brand': brand,
        'isGiftCard': isGiftCard,
      },
    );
  }

  String displaySelectedCardTextFromMap(Map selectedPayment) {
    final cardNickname = selectedPayment['cardNickname'] == null
        ? ''
        : '${selectedPayment['cardNickname']} - ';
    final brandName = selectedPayment['isGiftCard']
        ? 'jüs card'
        : getBrandName(selectedPayment['brand']);
    final lastFourDigits = ' ending in ${selectedPayment['lastFourDigits']}';

    return [cardNickname, brandName, lastFourDigits].join().trim();
  }

  String displaySelectedCardTextFromPaymentModel(PaymentsModel card) {
    final cardNickname =
        card.cardNickname.isEmpty ? '' : '${card.cardNickname} ';
    final brandName = card.isGiftCard ? '' : '- ${getBrandName(card.brand)} ';
    final lastFourDigits = 'ending in ${card.lastFourDigits}';

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
        return brand;
    }
  }
}
