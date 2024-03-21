const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const pauseSquareSubscription = async ({
  subscriptionId
}) => {
  const client = await createSquareClient();

  try {
    const response = await client.subscriptionsApi.pauseSubscription(subscriptionId,
     {});

    return 200;
  } catch (error) {
   console.log(error);
    throw error;
  }
};

module.exports = { pauseSquareSubscription };
