const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

exports.addToFavorites = functions.https.onCall(async (data, context) => {
  if (!isAuthenticated(context)) {
    return {
      status: 401,
      message: "You must be logged in to add a favorite.",
    };
  }

  const userId = context.auth.uid;

  const { ingredients, toppings, productId, name, size, allergies } = data;

  try {
    const favoritesCollection = admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("favorites");

    const docRef = favoritesCollection.doc();
    const docID = docRef.id;

    await docRef.set({
      productId: productId,
      uid: docID,
      userId: userId,
      name: name,
      ingredients: ingredients,
      toppings: toppings,
      size: size,
      allergies: allergies,
    });

    return {
      status: 200,
    };
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }
});
