const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.updateDefaultPayment = functions.https.onCall(async (data, context) => {
  if (!isAuthenticated(context)) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must create an account to update a default payment."
    );
  }

  const cardID = data.cardID;
  const userID = context.auth.uid;

  try {
    const collectionReference = admin
      .firestore()
      .collection("users")
      .doc(userID)
      .collection("squarePaymentMethods");

    await removeOldDefaultPayment(collectionReference);
    await collectionReference.doc(cardID).update({ defaultPayment: true });

    return { success: true };
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }
});

async function removeOldDefaultPayment(collectionReference) {
  const oldDefaultPayment = await collectionReference
    .where("defaultPayment", "==", true)
    .get();
  const batch = admin.firestore().batch();

  oldDefaultPayment.docs.forEach((doc) => {
    batch.update(doc.ref, {
      defaultPayment: false,
    });
  });

  await batch.commit();
}
