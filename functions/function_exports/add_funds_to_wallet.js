const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");
const createSquareGiftCardOrder = require("../orders/create_square_gift_card_order");
const processGiftCardPayment = require("../payments/process_gift_card_payment");
const loadMoneyToWallet = require("../gift_cards/load_money_to_wallet");
const updateOrderMapWithPaymentData = require("../gift_cards/update_order_map_with_payment_data");
const updateWalletBalanceInDatabase = require("../users/update_wallet_balance_in_database");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.addFundsToWallet = functions.https.onCall(async (data, context) => {
  const db = admin.firestore();
  const orderMap = data.orderMap;
  const userID = context.auth?.uid ?? null;
  const cardId = orderMap.paymentDetails.cardId;
  orderMap.orderDetails = {};
  orderMap.cardDetails = {};

  try {
    if (orderMap.paymentDetails.amount > 50000) {
      return {
        status: "ERROR",
        message:
          "There was a serious error when attempting this request. Please try again later.",
      };
    }

    const giftCardOrder = await createSquareGiftCardOrder(
      orderMap,
      "Load Wallet",
    );

    orderMap.orderDetails.orderNumber = giftCardOrder.order.id;
    orderMap.orderDetails.lineItemUid = giftCardOrder.order.line_items[0].uid;

    const paymentResult = await processGiftCardPayment(orderMap);

    //Square payments require a String type for amount, but the database expects an int type.
    //Therefore, we need to convert the String to int after the payment is processed
    orderMap.paymentDetails.amount = parseInt(
      orderMap.paymentDetails.amount,
      10,
    );

    orderMap.paymentDetails.paymentId = paymentResult.payment.id;

    updateOrderMapWithPaymentData(orderMap, paymentResult);

    await loadMoneyToWallet(
      orderMap.paymentDetails.gan,
      orderMap.orderDetails.orderNumber,
      orderMap.orderDetails.lineItemUid,
    );

    orderMap.cardDetails.activityId = uuidv4();
    orderMap.cardDetails.activity = "LOAD";

    await updateWalletBalanceInDatabase(db, orderMap);

    await addGiftCardActivityToDatabase(db, orderMap);

    return 200;
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }
});
