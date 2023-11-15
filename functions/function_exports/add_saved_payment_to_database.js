const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.addSavedPaymentToDatabase = functions.https.onCall(
  async (data, context) => {
    if (!isAuthenticated(context)) {
      return {};
    }

    const {
      nonce,
      brand,
      lastFourDigits,
      expirationMonth,
      expirationYear,
      isWallet,
      firstName,
      gan,
      balance,
    } = data;

    const userID = context.auth.uid;
    const collectionReference = admin
      .firestore()
      .collection("users")
      .doc(userID)
      .collection("squarePaymentMethods");

    const savedCard = await collectionReference
      .where("lastFourDigits", "==", lastFourDigits)
      .get();

    if (savedCard.empty) {
      const docID = collectionReference.doc().id;
      await removeOldDefaultPayment(collectionReference);
      await collectionReference.doc(docID).set({
        uid: docID,
        userID: userID,
        nonce: nonce,
        brand: brand,
        lastFourDigits: lastFourDigits,
        expirationMonth: expirationMonth,
        expirationYear: expirationYear,
        defaultPayment: true,
        gan: gan,
        balance: balance,
        isWallet: isWallet,
        cardNickname: isWallet === true ? `${firstName}\'s Wallet` : firstName,
      });
    }

    return {};
  },
);

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
