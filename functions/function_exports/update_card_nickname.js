const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.updateCardNickname = functions.https.onCall(async (data, context) => {
  const { cardID, cardNickname } = data;
  const userID = context.auth.uid;

  if (!isAuthenticated(context)) {
    return {
      status: 400,
      error:
        "Make sure you are logged in before trying to update a card nickname.",
    };
  }

  try {
    const cardDocRef = admin
      .firestore()
      .collection("users")
      .doc(userID)
      .collection("squarePaymentMethods")
      .doc(cardID);

    await cardDocRef.update({ cardNickname: cardNickname });
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }

  return 200;
});
