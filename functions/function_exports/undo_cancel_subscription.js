const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");
const { undoCancelSquareSubscription } = require("../subscriptions/undo_cancel_square_subscription");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.undoCancelSubscription = functions.https.onCall(async (data, context) => {


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
    const subscriptionId = subscriptionDoc.data().subscriptionId;

    await undoCancelSquareSubscription(subscriptionId);

    await db.collection("users").doc(userId).update({
      subscriptionStatus: 'ACTIVE'
    });

    return { status: 200, message: 'Successfully resumed subscription' };
  } catch (error) {
    console.error(error);
    return { status: 400, message: 'Failed to resume subscription.' };
  }
});