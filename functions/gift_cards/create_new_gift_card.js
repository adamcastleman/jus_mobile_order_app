const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

const createNewGiftCard = async (orderMap) => {
  const client = await createSquareClient();
  const locationID = await getSquareLocationID();

  try {
    // Create the gift card
    const createResponse = await client.giftCardsApi.createGiftCard({
      idempotencyKey: uuidv4(),
      locationId: locationID,
      orderId: orderMap.paymentDetails.orderId,
      giftCard: {
        type: "DIGITAL",
      },
    });

    const response = JSON.parse(createResponse.body);

    const giftCardID = response.gift_card.id;

    const loadResponse =
      await client.giftCardActivitiesApi.createGiftCardActivity({
        idempotencyKey: uuidv4(),
        giftCardActivity: {
          type: "ACTIVATE",
          locationId: locationID,
          giftCardId: giftCardID,
          activateActivityDetails: {
            orderId: orderMap.orderDetails.orderNumber,
            lineItemUid: orderMap.orderDetails.lineItemUid,
          },
        },
      });
    // Return the gift card creation result and the gift card activity result

    return JSON.parse(loadResponse.body);
  } catch (error) {
    throw error;
    console.log(error);
  }
};

module.exports = createNewGiftCard;
