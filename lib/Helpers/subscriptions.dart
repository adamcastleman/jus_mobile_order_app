import 'package:cloud_functions/cloud_functions.dart';

class SubscriptionHelpers {
  Future<String> getUnpaidInvoiceId(String customerId) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('getUnpaidSquareInvoiceId')
          .call({'customerId': customerId});

      return result.data as String;
    } catch (e) {
      throw Exception('Failed to retrieve invoice ID');
    }
  }
}
