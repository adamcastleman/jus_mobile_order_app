const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processPayment = require("../payments/process_payment");
const recordZeroChargeOrder = require("../payments/record_zero_charge_order");
const updateOrderMapWithPaymentData = require("../payments/update_order_map_with_payment_data");
const createSquareOrder = require("../orders/create_square_order");
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

  try {

  console.log(orderMap);

   var response = await createSquareOrder(orderMap);

    // If a GAN is provided, try to get the associated Gift Card ID.
    if (gan !== null && orderMap.totals.totalAmount !== 0) {
      await getGiftCardIDFromGan(orderMap);
    }

    if(orderMap.totals.totalAmount !== 0) {
      // Process payment and return the result.
        const paymentResult = await processPayment(orderMap);
      // Check if paymentResult is valid and the payment is successful
            if (!paymentResult || !paymentResult.payment || paymentResult.payment.status !== 'COMPLETED') {
              return {
                status: paymentResult.status,
                message: paymentResult.message,
              };
            }
       // Update order with payment details if payment is successful.
         updateOrderMapWithPaymentData(orderMap, paymentResult);
    }

    // If GAN is not null, handle gift card updates and wallet balance.
    if (gan !== null && orderMap.totals.totalAmount !== 0) {
      updateGiftCardMapForRedemption(orderMap, giftCardMap);
      updateWalletBalanceInDatabase(db, orderMap, giftCardMap);
      addGiftCardActivityToDatabase(db, giftCardMap, userID);
    }

    // Add the order to the database.
    await addOrderToDatabase(db, orderMap, userID);

    // If userID is not null, update points and member savings.
    if (userID !== null) {
      await updatePoints(db, orderMap);
      await updateMemberSavings(db, orderMap);
    }

//     Return a 200 status code on successful completion.
  return {
         status: 200,
         message: 'The order was placed successfully',
       };

  } catch (error) {
    console.error(error);
    return {
      status: 400,
      message: error.message
    };
  }
});
