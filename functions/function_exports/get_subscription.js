const functions = require("firebase-functions");
const admin = require("firebase-admin");
const isAuthenticated = require("../users/is_authenticated");
const { createSquareClient } = require("../payments/square_client");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.getSubscription = functions.https.onCall(async (data, context) => {
  const { subscriptionId } = data;
  const userId = context.auth.uid;  // Make sure this is used if necessary, otherwise, it can be removed
  const client = await createSquareClient();

  if (!isAuthenticated(context)) {
    return { status: 'error', message: 'Authentication required.' };
  }

  try {
    const subscription = await client.subscriptionsApi.retrieveSubscription(subscriptionId);
    return JSON.parse(subscription.body);
  } catch (error) {
    console.error(error);
    return { status: 400, message: 'Failed to retrieve subscription.' };
  }
});
