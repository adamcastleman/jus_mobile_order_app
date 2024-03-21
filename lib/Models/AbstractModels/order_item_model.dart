class OrderItem {
  String productName;
  String image;
  String category;
  String productId;
  int itemDiscount;
  String discountName;
  int itemQuantity;
  int scheduledQuantity;
  String size;
  String squareVariationId;
  bool isScheduled;
  String scheduledDescriptor;
  List modifications;
  List allergies;
  int price;
  int modifierPrice;

  OrderItem({
    required this.productName,
    required this.image,
    required this.category,
    required this.productId,
    required this.itemDiscount,
    required this.discountName,
    required this.itemQuantity,
    required this.scheduledQuantity,
    required this.size,
    required this.squareVariationId,
    required this.isScheduled,
    required this.scheduledDescriptor,
    required this.modifications,
    required this.allergies,
    required this.price,
    required this.modifierPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': productName,
      'image': image,
      'category': category,
      'id': productId,
      'itemDiscount': itemDiscount,
      'discountName': discountName,
      'itemQuantity': itemQuantity,
      'scheduledQuantity': scheduledQuantity,
      'size': size,
      'isScheduled': isScheduled,
      'squareVariationId': squareVariationId,
      'scheduledDescriptor': scheduledDescriptor,
      'modifications': modifications,
      'allergies': allergies,
      'price': price,
      'modifierPrice': modifierPrice
    };
  }
}
