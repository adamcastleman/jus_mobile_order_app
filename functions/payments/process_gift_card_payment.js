const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const processGiftCardPayment = async (giftCardMap) => {
  const client = await createSquareClient();

  try {
    const response = await client.paymentsApi.createPayment({
      sourceId: giftCardMap.paymentDetails.cardId,
      orderId: giftCardMap.orderDetails.orderNumber,
      customerId: giftCardMap.userDetails.squareCustomerId,
      idempotencyKey: uuidv4(),
      amountMoney: {
        amount: giftCardMap.paymentDetails.amount.toString(),
        currency: giftCardMap.paymentDetails.currency,
      },
    });

    if (!response || !response.body) {
      throw new Error("Invalid response from payment gateway");
    }

    return JSON.parse(response.body);
  } catch (error) {
    throw error;
    console.log(error.message);
    console.log("Error processing gift card transaction:", error);
    return null;
  }
};

module.exports = processGiftCardPayment;
