const { Client, Environment } = require("square");
const { createSquareClient } = require("../payments/square_client");

const getGiftCardIDFromGan = async (orderMap) => {
  const client = await createSquareClient();

  try {
    const cardResponse = await client.giftCardsApi.retrieveGiftCardFromGAN({
      gan: orderMap.paymentDetails.gan,
    });

    const response = JSON.parse(cardResponse.body);

    const giftCardId = response.gift_card.id;

    orderMap.paymentDetails.cardId = giftCardId;

    return giftCardId;
  } catch (error) {
    throw error;
    console.log(error);
  }
};

module.exports = getGiftCardIDFromGan;
