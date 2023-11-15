const { createSquareClient } = require("../payments/square_client");
const { v4: uuidv4 } = require("uuid");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

const loadMoneyToWallet = async (gan, amount) => {
  const client = await createSquareClient();
  const locationID = await getSquareLocationID();
  try {
    const response = await client.giftCardActivitiesApi.createGiftCardActivity({
      idempotencyKey: uuidv4(),
      giftCardActivity: {
        type: "LOAD",
        locationId: locationID,
        giftCardGan: gan,
        loadActivityDetails: {
          amountMoney: {
            amount: amount,
            currency: "USD",
          },
          buyerPaymentInstrumentIds: ["credit-card"],
        },
      },
    });

    return JSON.parse(response.body);
  } catch (error) {
    console.log(error);
    return error.message;
  }
};

module.exports = loadMoneyToWallet;
