const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const processPayment = async (orderMap) => {
  const client = await createSquareClient();

  try {
    const response = await client.paymentsApi.createPayment({
      sourceId: 'cnon:card-nonce-ok',
      idempotencyKey: uuidv4(),
      externalDetails: {
        source: orderMap.paymentMethod,
        type: orderMap.externalPaymentType,
      },
      amountMoney: {
        amount: orderMap.totalAmount,
        currency: "USD",
      },
      tipMoney: {
        amount: orderMap.tipAmount,
        currency: "USD",
      },
    });

    if (!response || !response.body) {
      throw new Error("Invalid response from payment gateway");
    }

    return JSON.parse(response.body);
  } catch (error) {
    console.log("Error processing payment:", error.message);
    return null;
  }
};

module.exports = processPayment;