const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const processPayment = async (orderMap) => {
  const client = await createSquareClient();

  try {
    const response = await client.paymentsApi.createPayment({
      sourceId: orderMap.paymentDetails.cardId,
      customerId: orderMap.userDetails.squareCustomerId,
      idempotencyKey: uuidv4(),
      orderId: orderMap.orderDetails.orderNumber,
      externalDetails: {
        source: orderMap.paymentDetails.paymentMethod,
        type: orderMap.paymentDetails.externalPaymentType,
      },
      amountMoney: {
        amount: orderMap.totals.totalAmount,
        currency: orderMap.paymentDetails.currency,
      },
      tipMoney: {
        amount: orderMap.totals.tipAmount,
        currency: orderMap.paymentDetails.currency,
      },
    });

    if (!response || !response.body) {
      throw new Error("Invalid response from payment gateway");
    }

    return JSON.parse(response.body);
  } catch (error) {
    return { status: 500, message: error.errors[0].detail };
  }
};

module.exports = processPayment;
