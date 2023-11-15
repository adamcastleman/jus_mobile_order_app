import 'package:cloud_functions/cloud_functions.dart';

class SubscriptionServices {
  Future isRegisteringUserLegacyMember({required email}) async {
    return await FirebaseFunctions.instance
        .httpsCallable('fetchWooSubscriptionData')
        .call({
      'email': email,
    });
  }

  Future migrateToSquareSubscription({
    required firstName,
    required lastName,
    required email,
    required phone,
    required membershipId,
    required billingPeriod,
    required startDate,
    required nonce,
  }) async {
    HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('migrateToSquareSubscription')
        .call({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'membershipId': membershipId,
      'billingPeriod': billingPeriod,
      'startDate': startDate,
      'nonce': nonce,
    });

    // Extract the data from the HttpsCallableResult and cast it to a Map
    return result.data as Map;
  }
}
