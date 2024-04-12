const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const createSquareSubscription = async ({
  squareCustomerId,
  billingPeriod,
  startDate,
  cardId,
  sourceId,
}) => {
  const client = await createSquareClient();
  const today = new Date().toISOString().substring(0, 10);
  startDate = startDate >= today ? startDate : today;

  try {
    const subscriptionResponse =
      await client.subscriptionsApi.createSubscription({
        idempotencyKey: uuidv4(),
        //TODO update location Id to new subscription location
        locationId: "LPRZ3G3PWZBKF",
        planVariationId:
          billingPeriod === "day"
            ? "ZQGEFSIIKUWSBSWIBXSYNFUP"
            : billingPeriod === "month"
            ? "6EBSHQ6KWAKHYRRLKVT6OEXX"
            : "TEQZXLQPYGVZLYAHPD6NNDBY",
        customerId: squareCustomerId,
        startDate: startDate,
        cardId: cardId,
        sourceId: sourceId,
        timezone: "UTC",
      });

     const subscription = JSON.parse(subscriptionResponse.body);

    return subscription;
  } catch (error) {
    console.error('Error creating subscription:', error);
    throw error;
  }
};

module.exports = { createSquareSubscription };