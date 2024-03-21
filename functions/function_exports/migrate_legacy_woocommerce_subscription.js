const functions = require("firebase-functions");
const admin = require("firebase-admin");
const WooCommerceRestApi = require("@woocommerce/woocommerce-rest-api").default;
const { getSecret } = require("../secrets");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");
const { createSquareCustomer } = require("../users/create_square_customer");
const { createSquareSubscription } = require("../subscriptions/create_square_subscription");
const { cancelWooMembership } = require("../subscriptions/cancel_woo_membership");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.migrateLegacyWooCommerceSubscription = functions.https.onCall(
  async (data, context) => {
    const client = await createSquareClient();
    const {
      firstName,
      lastName,
      email,
      phone,
      membershipId,
      billingPeriod,
      startDate,
      nonce,
      sourceId,
    } = data;
    let subscription = {};

    try {
      // Try to find or create a Square customer
      squareCustomerId = await createSquareCustomer(
        firstName,
        lastName,
        email,
        phone,
      );
    } catch (error) {
      console.error("Error with Square Customer API:", error);
      throw new functions.https.HttpsError(
        "aborted",
        "Failed to create or retrieve Square customer.",
      );
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

      await cancelWooMembership(email);

     const subscriptionResponse = await createSquareSubscription({
        squareCustomerId: squareCustomerId,
        billingPeriod: billingPeriod,
        startDate: startDate,
        cardId: subscription.cardDetails.cardId,
        sourceId, sourceId,
      });

      subscription.subscriptionId = subscriptionResponse.result.subscription.id;

      return subscription;
    } catch (error) {
      console.error("Error in createSquareSubscription:", error);
      throw error; // Or return a custom error object
    }
  },
);
