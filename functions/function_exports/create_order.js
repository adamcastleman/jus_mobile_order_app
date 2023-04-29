const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processPayment = require("../payments/process_payment");
const updateOrderMapWithPaymentData = require("../payments/update_order_map_with_payment_data");
const addOrderToDatabase = require("../orders/add_order_to_database");
const updatePoints = require("../users/update_user_points");
const updateMemberSavings = require("../users/update_member_savings");
const getGiftCardIDFromGan = require("../gift_cards/get_gift_card_id_from_gan");
const updateGiftCardMapForRedemption = require("../gift_cards/update_gift_card_map_for_redemption");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");
const updateWalletBalanceInDatabase = require('../users/update_wallet_balance_in_database');

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.createOrder = functions.https.onCall(async (data, context) => {

  const db = admin.firestore();
  const orderMap = data.orderMap;
  const giftCardMap = {};
  const gan = orderMap.paymentDetails.gan ?? null;
  const userID = context.auth?.uid ?? null;
  orderMap.userDetails.userID = userID;

  console.log(gan);

   try {

      if (gan !== null) {
      await getGiftCardIDFromGan(orderMap);
      }
      const paymentResult = await processPayment(orderMap);
      updateOrderMapWithPaymentData(orderMap, paymentResult);
      if(gan !== null) {
      console.log('Gan is not null');
      updateGiftCardMapForRedemption(orderMap, giftCardMap);
      updateWalletBalanceInDatabase(db, orderMap, giftCardMap);
      addGiftCardActivityToDatabase(db, giftCardMap, userID);
      }
      await addOrderToDatabase(db, orderMap, userID);
      if(userID !== null) {
       await updatePoints(db, orderMap);
       await updateMemberSavings(db, orderMap);
       }

      return 200;
    } catch (error) {
    console.log(error);
      return {
        status: 'ERROR',
        message: error.message
      };
    }

});