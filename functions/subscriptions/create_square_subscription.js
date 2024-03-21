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

  try {
    const subscription =
      await client.subscriptionsApi.createSubscription({
        idempotencyKey: uuidv4(),
        //TODO update location Id to new subscription location
        locationId: "LPRZ3G3PWZBKF",
        planId:
          billingPeriod === "month"
            ? "6EBSHQ6KWAKHYRRLKVT6OEXX"
            : "TEQZXLQPYGVZLYAHPD6NNDBY",
        customerId: squareCustomerId,
        startDate: startDate ?? null, // Format: yyyy-MM-dd
        cardId: cardId,
        sourceId: sourceId,
        timezone: "UTC",
      });

    return subscription;
  } catch (error) {
    throw error;
    console.log(error);
  }
};

module.exports = { createSquareSubscription };
