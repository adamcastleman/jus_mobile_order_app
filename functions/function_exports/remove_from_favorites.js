const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.removeFromFavorites = functions.https.onCall(async (data, context) => {
  const { docID } = data;
  const userID = context.auth.uid;

  if (!isAuthenticated(context)) {
    return  {
        status: 400, error: "Make sure you are logged in before trying to delete a favorite."
    };
  }

  try {
    const favoritesDocRef = admin
      .firestore()
      .collection("users")
      .doc(userID)
      .collection("favorites")
      .doc(docID);

    await favoritesDocRef.delete();
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }

  return 200;
});