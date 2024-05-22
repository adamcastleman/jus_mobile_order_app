const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processPayment = require("../payments/process_payment");
const recordZeroChargeOrder = require("../payments/record_zero_charge_order");
const updateOrderMapWithPaymentData = require("../payments/update_order_map_with_payment_data");
const updateOrderMapWithPaymentDataZeroCharge = require("../payments/update_order_map_with_payment_data_zero_charge");
const createSquareOrder = require("../orders/create_square_order");
const addOrderToDatabase = require("../orders/add_order_to_database");
const updatePoints = require("../users/update_user_points");
const updateMemberSavings = require("../users/update_member_savings");
const getGiftCardIDFromGan = require("../gift_cards/get_gift_card_id_from_gan");
const updateOrderMapForRedemption = require("../gift_cards/update_order_map_for_redemption");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");
const updateWalletBalanceInDatabase = require("../users/update_wallet_balance_in_database");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.createOrder = functions.https.onCall(async (data, context) => {
  const db = admin.firestore();
  const orderMap = data.orderMap;
  const gan =
    orderMap.paymentDetails.gan === null ||
    orderMap.paymentDetails.gan === undefined ||
    orderMap.paymentDetails.gan === ""
      ? null
      : orderMap.paymentDetails.gan;

  const userId = context.auth?.uid ?? null;
  orderMap.userDetails.userId = userId;

  try {

  console.log(orderMap.totals.totalAmount);
    var response = await createSquareOrder(orderMap);

    // If a GAN is provided, get the associated Gift Card ID.
    if (gan !== null && orderMap.totals.totalAmount !== 0) {
      await getGiftCardIDFromGan(orderMap);
    }


    if (orderMap.totals.totalAmount !== 0) {
      // Process payment and return the result.
      const paymentResult = await processPayment(orderMap);


      // Check if paymentResult is valid and the payment is successful
      if (
        !paymentResult ||
        !paymentResult.payment ||
        paymentResult.payment.status !== "COMPLETED"
      ) {
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
      updateOrderMapForRedemption(orderMap);
      await updateWalletBalanceInDatabase(db, orderMap);
      await addGiftCardActivityToDatabase(db, orderMap);
    }

    if(orderMap.totals.totalAmount === 0) {
     updateOrderMapWithPaymentDataZeroCharge(orderMap);
     }

    // Add the order to the database.
    await addOrderToDatabase(db, orderMap);


    // If userId is not null, update points and member savings.
    if (userId !== null) {
      await updatePoints(db, orderMap);
      await updateMemberSavings(db, orderMap);
    }


    //     Return a 200 status code on successful completion.
    return {
      status: 200,
      message: "The order was placed successfully",
    };
  } catch (error) {
    console.error(error);
    return {
      status: 400,
      message: error.message,
    };
  }
});
