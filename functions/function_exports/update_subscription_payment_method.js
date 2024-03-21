const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");
const isAuthenticated = require("../users/is_authenticated");
const { createSquareClient } = require("../payments/square_client");
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.updateSubscriptionPaymentMethod = functions.https.onCall(async (data, context) => {
  const client = await createSquareClient();
    const { squareCustomerId, cardId } = data;

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

           const subscriptionResponse = await client.subscriptionsApi.updateSubscription(subscriptionId,
            {
              subscription: {
                cardId: cardId
              }
            });

          await  querySnapshot.docs[0].ref.update({cardId: cardId});


    return { status: 200, message: 'Successfully updated subscription payment method' };
  } catch (error) {
    console.error(error);
    return { status: 400, message: 'Failed to update payment method.' };
  }
});