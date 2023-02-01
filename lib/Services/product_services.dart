import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class ProductServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> get products {
    return firestore
        .collection('products')
        .orderBy('categoryOrder')
        .orderBy('name')
        .snapshots()
        .map(getProductsFromDatabase);
  }

  Stream<List<ProductModel>> get taxableProducts {
    return firestore
        .collection('products')
        .where('taxable', isEqualTo: true)
        .orderBy('productID')
        .orderBy('name')
        .snapshots()
        .map(getProductsFromDatabase);
  }

  Stream<List<ProductModel>> get recommendedProducts {
    return firestore
        .collection('products')
        .where('isRecommended', isEqualTo: true)
        .snapshots()
        .map(getProductsFromDatabase);
  }

  List<ProductModel> getProductsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return ProductModel(
          uid: data['uid'],
          name: data['name'],
          category: data['category'],
          categoryOrder: data['categoryOrder'],
          productID: data['productID'],
          image: data['image'],
          description: data['description'],
          ingredients: data['ingredients'],
          taxable: data['taxable'],
          isRecommended: data['isRecommended'],
          isActive: data['isActive'],
          price: data['price'],
          memberPrice: data['memberPrice'],
          isFeatured: data['isFeatured'],
          isNew: data['isNew'],
          isModifiable: data['isModifiable'],
          isScheduled: data['isScheduled'],
          hoursNotice: data['hoursNotice'],
          hasToppings: data['hasToppings'],
          nutrition: data['nutrition'],
          perks: data['perks'],
          servingsFruit: data['servingsFruit'],
          servingsVeggie: data['servingsVeggie'],
        );
      },
    ).toList();
  }
}
