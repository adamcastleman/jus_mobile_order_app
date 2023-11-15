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
  } catch (error) {
    console.error("Error with Square Customer API:", error);
    throw new functions.https.HttpsError('aborted', "Failed to create or retrieve Square customer.");
  }

  try {
    points = await fetchSquareLoyaltyPoints(squareCustomerId);
  } catch (error) {
    console.error("Error with Square Loyalty API:", error);
    throw new functions.https.HttpsError('aborted', "Failed to retrieve Square loyalty points.");
  }

  const userDocument = {
    uid,
    firstName,
    lastName,
    email,
    phone,
    points,
    squareCustomerId,
    isActiveMember: subscription !== null,
  };

  const docRef = db.collection("users").doc(uid);

  try {
    await docRef.set(userDocument);

    if (subscription !== null) {
      const memberStatsRef = db.collection("users").doc(uid).collection("subscriptionData").doc();
      await memberStatsRef.set({
        uid: memberStatsRef.id,
        totalSaved: 0,
        bonusPoints: 0,
        subscriptionId: subscription.subscriptionId,
        cardId: subscription.cardDetails.cardId,
      });

      const savedCardRef = db.collection("users").doc(uid).collection("squarePaymentMethods").doc();
      await savedCardRef.set({
        uid: savedCardRef.id,
        userID: docRef.id,
        cardId: subscription.cardDetails.cardId,
        last4: subscription.cardDetails.last4,
        cardBrand: subscription.cardDetails.cardBrand,
        expMonth: subscription.cardDetails.expMonth,
        expYear: subscription.cardDetails.expYear,
        isWallet: false,
        defaultPayment: true,
        cardNickname: `${firstName}'s ${subscription.cardDetails.cardBrand}`,
        gan: null,
        balance: null,
      });
    }

    return { status: "User created successfully", uid: docRef.id };
  } catch (error) {
    console.error("Error creating user in Firestore:", error);
    throw new functions.https.HttpsError('unknown', "Error creating user in Firestore.");
  }
});
