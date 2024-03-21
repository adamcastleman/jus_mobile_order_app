const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

const createSquareGiftCardOrder = async (orderMap, activityType) => {
  const client = await createSquareClient();
  const currency = orderMap.paymentDetails.currency;
  const totalAmount = orderMap.paymentDetails.amount;
  const locationID = await getSquareLocationID();

  try {
    const response = await client.ordersApi.createOrder({
      order: {
        locationId: locationID,
        customerId: orderMap.userDetails.squareCustomerId,
        lineItems: [
          {
            name: activityType,
            quantity: "1",
            itemType: "GIFT_CARD",
            basePriceMoney: {
              amount: orderMap.paymentDetails.amount,
              currency: orderMap.paymentDetails.currency,
            },
          },
        ],
      },
      idempotencyKey: uuidv4(),
    });

    return JSON.parse(response.body);
  } catch (error) {
    throw error;
    console.log(error);
  }
};

module.exports = createSquareGiftCardOrder;
