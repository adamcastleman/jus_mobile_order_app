const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { createSquareClient } = require("../payments/square_client");
const { v4: uuidv4 } = require("uuid");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

exports.loadGiftCard = functions.https.onCall(async (data, context) => {
  const client = await createSquareClient();
  const locationID = await getSquareLocationID();
 try {
   const response = await client.giftCardActivitiesApi.createGiftCardActivity({
     idempotencyKey: uuidv4(),
     giftCardActivity: {
       type: 'LOAD',
       locationId: locationID,
       giftCardGan: data.gan,
        load_activity_details: {
             "amount_money": {
               "amount": 1000,
               "currency": "USD"
             },
             buyer_payment_instrument_ids: [
               "credit card"
             ]
           }

     }
   });

    return 200;
  } catch (error) {
    console.log(error.message);
    return error.message
  }
});
