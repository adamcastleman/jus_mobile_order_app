const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const retrieveCardDetails = async (cardId) => {
  const client = await createSquareClient();

  try {
    const response = await client.cardsApi.retrieveCard(cardId);

    console.log(response.result);
    return JSON.parse(response.body);
  } catch(error) {
    console.log(error);
    throw(error);
  }
};

module.exports = { retrieveCardDetails };