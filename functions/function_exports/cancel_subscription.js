const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");
const { createSquareClient } = require("../payments/square_client");
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.cancelSubscription = functions.https.onCall(async (data, context) => {
  const client = await createSquareClient();

  if (!isAuthenticated(context)) {
    return { status: 'error', message: 'Authentication required.' };
  }

  const userId = context.auth.uid;
  const subscriptionCollection = db.collection("subscriptions");

  try {
    const querySnapshot = await subscriptionCollection.where('userId', '==', userId).get();

    if (querySnapshot.empty) {
      console.log('No subscription found for user:', userId);
      return { status: 400, message: 'Subscription not found.' };
    }

    const subscriptionDoc = querySnapshot.docs[0];
    const subscriptionId = subscriptionDoc.data().subscriptionId; // Ensure this is the correct field

    await client.subscriptionsApi.cancelSubscription(subscriptionId);


    await db.collection("users").doc(userId).update({
      subscriptionStatus: 'CANCELED'
    });

    return { status: 200, message: 'Successfully canceled subscription' };
  } catch (error) {
    console.error(error);
    return { status: 400, message: 'Failed to cancel subscription.' };
  }
});