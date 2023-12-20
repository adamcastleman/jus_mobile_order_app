const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const recordZeroChargeOrder = async (orderMap) => {
  const client = await createSquareClient();

    try {
      const response = await client.ordersApi.payOrder(orderMap.orderDetails.orderNumber,
      {
        idempotencyKey: uuidv4()
      });

       if (!response || !response.body) {
            throw new Error("Invalid response from payment gateway");
          }

          console.log(`Response: ${response.body}`);

          return JSON.parse(response.body);

    } catch(error) {
      console.log(error);
    }
  };

module.exports = recordZeroChargeOrder;
