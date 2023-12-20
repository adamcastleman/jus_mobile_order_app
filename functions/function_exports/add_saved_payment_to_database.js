const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

// Initialize the Firebase app if it hasn't been already
if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.addSavedPaymentToDatabase = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!isAuthenticated(context)) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const {
    cardId,
    brand,
    last4,
    expirationMonth,
    expirationYear,
    isWallet,
    firstName,
    gan,
    balance,
  } = data;

  const userID = context.auth.uid;
  const collectionReference = admin.firestore().collection("users").doc(userID).collection("squarePaymentMethods");

  try {
    // Check if a card with the same last four digits already exists
    const savedCard = await collectionReference.where("last4", "==", last4).get();

    if (savedCard.empty) {
      // Add new payment method and set it as the default
      const docID = collectionReference.doc().id;
      await setNewDefaultPayment(collectionReference, {
        uid: docID,
        userID,
        cardId,
        brand,
        last4,
        expirationMonth,
        expirationYear,
        defaultPayment: true,
        gan,
        balance,
        isWallet,
        cardNickname: isWallet ? `${firstName}'s Wallet` : firstName,
      });
    }
  } catch (error) {
    console.error('Error adding payment method to database:', error);
    throw new functions.https.HttpsError('unknown', 'Failed to add payment method.');
  }

  return {};
});

async function setNewDefaultPayment(collectionReference, newPaymentData) {
  const batch = admin.firestore().batch();

  // Unset the old default payment
  const oldDefaultPayment = await collectionReference.where("defaultPayment", "==", true).get();
  oldDefaultPayment.docs.forEach((doc) => {
    batch.update(doc.ref, { defaultPayment: false });
  });

  // Add the new default payment
  const newPaymentRef = collectionReference.doc(newPaymentData.uid);
  batch.set(newPaymentRef, newPaymentData);

  // Commit the batch operation
  await batch.commit();
}
