const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processGiftCardPayment = require("../payments/process_gift_card_payment");
const createNewGiftCard = require("../gift_cards/create_new_gift_card");
const updateGiftCardMapWithCardData = require("../gift_cards/update_gift_card_map_with_card_data");
const updateGiftCardMapWithPaymentData = require("../gift_cards/update_gift_card_map_with_payment_data");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");
const addGiftCardAsSavedPayment = require("../gift_cards/add_gift_card_as_saved_payment");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.createDigitalGiftCard = functions.https.onCall(async (data, context) => {

  const db = admin.firestore();
  const giftCardMap = data.giftCardMap;
  const userID = context.auth?.uid ?? null;
  giftCardMap.userDetails.userID = userID;
  const nonce = giftCardMap.paymentDetails.nonce;

   try {
      const paymentResult = await processGiftCardPayment(giftCardMap);
      updateGiftCardMapWithPaymentData(giftCardMap, paymentResult);
      const createdGiftCard = await createNewGiftCard(giftCardMap);
      updateGiftCardMapWithCardData(giftCardMap, createdGiftCard);
      await addGiftCardActivityToDatabase(db, giftCardMap, userID);
      await addGiftCardAsSavedPayment(db, giftCardMap, userID);

      return 200;
    } catch (error) {
    console.log(error);
      return {
        status: 'ERROR',
        message: error.message
      };
    }

});