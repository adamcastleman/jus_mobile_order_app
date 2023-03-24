const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.updateCardNickname = functions.https.onCall(async (data, context) => {
  const { cardID, userID, cardNickname } = data;

  if (!isAuthenticated(context)) {
       throw new functions.https.HttpsError(
            "unauthenticated",
            "You must create an account to update a card nickname."
          );
    }

  const cardDocRef = admin
    .firestore()
    .collection("users")
    .doc(userID)
    .collection("squarePaymentMethods")
    .doc(cardID);

  await cardDocRef.update({ cardNickname: cardNickname });

  return 200;
});
