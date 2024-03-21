import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/app_store_ids_model.dart';

class AppServices {
  Stream<AppStoreIdsModel> get appStoreIds {
    return FirebaseFirestore.instance
        .collection('appStoreIds')
        .snapshots()
        .map(getAppStoreIdsFromDatabase);
  }

  AppStoreIdsModel getAppStoreIdsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return AppStoreIdsModel(
        appStoreIdiOS: data['appStoreIdiOS'] ?? '',
        appStoreIdMacOS: data['appStoreIdMacOS'] ?? '',
        appStoreIdGooglePlay: data['appStoreIdGooglePlay'] ?? '',
        appStoreIdWindows: data['appStoreIdWindows'] ?? '',
      );
    }).first;
  }
}
