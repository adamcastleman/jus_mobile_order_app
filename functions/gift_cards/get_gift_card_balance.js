const { Client, Environment } = require("square");
const { createSquareClient } = require("../payments/square_client");

const getGiftCardBalance = async (gan) => {
  const client = await createSquareClient();

  try {
    const cardResponse = await client.giftCardsApi.retrieveGiftCardFromGAN({
      gan: gan,
    });

    const response = JSON.parse(cardResponse.body);

    const balance = response.gift_card.balance_money.amount;

    return balance;
  } catch (error) {
    console.log(error);
    throw error;
  }
};

module.exports = getGiftCardBalance;
