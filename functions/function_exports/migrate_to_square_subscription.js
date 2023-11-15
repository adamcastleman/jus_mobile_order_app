const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { getSecret } = require("../secrets");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");
const { createSquareCustomer } = require("../users/create_square_customer");
const { cancelWooMembership } = require("../users/cancel_woo_membership");



if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.migrateToSquareSubscription = functions.https.onCall(async (data, context) => {
  const client = await createSquareClient();
  const { firstName, lastName, email, phone, membershipId, billingPeriod, startDate, nonce, } = data;
  let subscription = {};

   try {
      // Try to create or find a Square customer
      squareCustomerId = await createSquareCustomer(firstName, lastName, email, phone);
    } catch (error) {
      console.error("Error with Square Customer API:", error);
      throw new functions.https.HttpsError('aborted', "Failed to create or retrieve Square customer.");
    }

  try {
    const cardResponse = await client.cardsApi.createCard({
      idempotencyKey: uuidv4(),
      sourceId: nonce,
      card: {
      customerId: squareCustomerId,
       },
    });

        const card = cardResponse.result.card;
             subscription.cardDetails = {
               cardId: card.id,
               last4: card.last4,
               cardBrand: card.cardBrand,
               expMonth: card.expMonth.toString(),
               expYear: card.expYear.toString(),
             };


    await cancelWooMembership(membershipId);

    const subscriptionResponse = await client.subscriptionsApi.createSubscription({
      idempotencyKey: uuidv4(),
      locationId: 'LPRZ3G3PWZBKF',
      planId: billingPeriod === 'month' ? '6EBSHQ6KWAKHYRRLKVT6OEXX' : 'TEQZXLQPYGVZLYAHPD6NNDBY',
      customerId: squareCustomerId,
      startDate: startDate, // Format: yyyy-MM-dd
      cardId: card.id,
      sourceId: 'Mobile',
      timezone: 'UTC'
    });

    subscription.subscriptionId = subscriptionResponse.result.subscription.id;
    return subscription;
  } catch (error) {
    console.error('Error in createSquareSubscription:', error);
    throw error; // Or return a custom error object
  }
});