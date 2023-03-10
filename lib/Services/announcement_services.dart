import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/announcements_model.dart';

class AnnouncementServices {
  CollectionReference announcementCollection =
      FirebaseFirestore.instance.collection('announcements');

  Stream<List<AnnouncementsModel>> get announcements {
    return announcementCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(getAnnouncementsFromDatabase);
  }

  List<AnnouncementsModel> getAnnouncementsFromDatabase(
      QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return AnnouncementsModel(
            uid: data['uid'],
            title: data['title'],
            description: data['description'],
            isActive: data['isActive']);
      },
    ).toList();
  }
}
