const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { createSquareCustomer } = require("../users/create_square_customer");
const { fetchSquareLoyaltyPoints } = require("../users/fetch_square_loyalty_points");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.createUser = functions.https.onCall(async (data, context) => {
  const { firstName, lastName, email, phone, uid, subscription } = data;

  let squareCustomerId;
  let points;

  try {
    squareCustomerId = await createSquareCustomer(firstName, lastName, email, phone);
    points = await fetchSquareLoyaltyPoints(squareCustomerId);
  } catch (error) {
    console.error("Error with Square Customer API:", error);
    throw new functions.https.HttpsError(
      "aborted",
      "Failed to create or retrieve Square customer."
    );
  }

  const userDocument = {
    uid,
    firstName,
    lastName,
    email,
    phone,
    points,
    squareCustomerId,
    subscriptionStatus: subscription ? 'ACTIVE' : 'NONE',
  };

  try {
    await db.collection("users").doc(uid).set(userDocument);

    if (subscription) {
      // Create a new document in the subscriptions collection
      const subscriptionDocRef = db.collection("subscriptions").doc();
      await subscriptionDocRef.set({
        userId: uid,
        totalSaved: 0,
        bonusPoints: 0,
        subscriptionId: subscription.subscriptionId,
        cardId: subscription.cardDetails.cardId
      });

      // Create a payment method in the squarePaymentMethods subcollection of the user
      const savedCardRef = db.collection("users").doc(uid).collection("squarePaymentMethods").doc();
      await savedCardRef.set({
        cardId: subscription.cardDetails.cardId,
        last4: subscription.cardDetails.last4,
        cardBrand: subscription.cardDetails.cardBrand,
        expMonth: subscription.cardDetails.expMonth,
        expYear: subscription.cardDetails.expYear,
        isWallet: false,
        defaultPayment: true,
        cardNickname: `${firstName}'s ${subscription.cardDetails.cardBrand}`
      });
    }

    return { status: "success", message: "User created successfully", uid };
  } catch (error) {
    console.error("Error creating user in Firestore:", error);
    throw new functions.https.HttpsError(
      "unknown",
      "Error creating user in Firestore."
    );
  }
});
