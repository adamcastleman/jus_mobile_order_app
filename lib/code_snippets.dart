//MODIFY INGREDIENTS COLLECTION
// for (var doc in data) {
//   FirebaseFirestore.instance
//       .collection('ingredients')
//       .doc(doc.uid)
//       .update({
//     'isBlended': false,
//     'isTopping': false,
//   });
// }

//MODIFY PRODUCT COLLECTION
// for (var doc in data) {
//   FirebaseFirestore.instance
//       .collection('products')
//       .doc(doc.uid)
//       .update({
//     'isBlended': false,
//   });
// }

//DUPLICATE DOCUMENT
// // Get a reference to the source and target collections
// final sourceCollectionRef =
// FirebaseFirestore.instance.collection('products');
// final targetCollectionRef =
// FirebaseFirestore.instance.collection('products');
//
// // Read the data from the source document
// final sourceDocumentSnapshot =
//     await sourceCollectionRef.doc(products[index].uid).get();
//
// if (sourceDocumentSnapshot.exists) {
// final sourceData =
// sourceDocumentSnapshot.data() as Map<String, dynamic>;
//
// // Create a new document in the target collection with the same data
// await targetCollectionRef.add(sourceData);
// } else {
// print('Source document not found');
// }

// .when(error: (e,_) => ShowError(error: e.toString()), loading: () => const Loading(), data: (data) => );


