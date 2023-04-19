const { createSquareClient } = require("../payments/square_client");
const { v4: uuidv4 } = require("uuid");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

const clearPhysicalGiftCardBalance = async (gan, amount) => {
  const client = await createSquareClient();
  const locationID = await getSquareLocationID();
  try {
    const response = await client.giftCardActivitiesApi.createGiftCardActivity({
      idempotencyKey: uuidv4(),
      giftCardActivity: {
        type: 'ADJUST_DECREMENT',
        locationId: locationID,
        giftCardGan: gan,
        adjustDecrementActivityDetails: {
          amountMoney: {
            amount: amount,
            currency: 'USD'
          },
          reason: 'SUPPORT_ISSUE'
        }
      }
    });

    return 200;
  } catch (error) {
    console.log('We failed here');
    console.log(error);
    return error.message;
  }
};

module.exports = clearPhysicalGiftCardBalance;
