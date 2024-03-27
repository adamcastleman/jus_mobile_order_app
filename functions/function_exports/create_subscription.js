const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");
const { createSquareSubscription } = require("../subscriptions/create_square_subscription");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.createSubscription = functions.https.onCall(async (data, context) => {
  const { squareCustomerId, billingPeriod, startDate, cardId, sourceId } = data;
  const userId = context.auth.uid;

  if (!isAuthenticated(context)) {
    return { status: 'error', message: 'Authentication required.' };
  }

  try {
    const { subscription } = await createSquareSubscription({
      squareCustomerId,
      billingPeriod,
      startDate,
      cardId,
      sourceId
    });


    if (subscription) {
      const subscriptionsRef = db.collection("subscriptions");
      const userSubscriptionSnapshot = await subscriptionsRef.where("userId", "==", userId).limit(1).get();

      if (!userSubscriptionSnapshot.empty) {
        const userSubscriptionDoc = userSubscriptionSnapshot.docs[0];
        try {
          await userSubscriptionDoc.ref.update({
            cardId: cardId,
            subscriptionId: subscription.id
          });
        } catch (updateError) {
          console.error(`Error updating subscription for user ${userId}:`, updateError);
          return { status: 500, message: 'Failed to update subscription.' };
        }
      } else {
        const subscriptionDocRef = subscriptionsRef.doc(subscription.id);
        await subscriptionDocRef.set({
          userId: userId,
          totalSaved: 0,
          bonusPoints: 0,
          subscriptionId: subscription.id,
          cardId: cardId
        });
      }

      await db.collection("users").doc(userId).update({
        subscriptionStatus: 'ACTIVE'
      });

      return { status: 200, message: 'Successfully created or updated subscription' };
    } else {
      return { status: 400, message: 'Subscription creation failed.' };
    }
  } catch (error) {
    console.error(error);
    return { status: 500, message: 'Failed to create subscription.' };
  }
});