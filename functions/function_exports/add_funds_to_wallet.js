const functions = require("firebase-functions");
const admin = require("firebase-admin");
const createSquareGiftCardOrder = require("../orders/create_square_gift_card_order");
const processGiftCardPayment = require("../payments/process_gift_card_payment");
const loadMoneyToWallet = require("../gift_cards/load_money_to_wallet");
const updateGiftCardMapForLoad = require("../gift_cards/update_gift_card_map_for_load");
const updateGiftCardMapWithPaymentData = require("../gift_cards/update_gift_card_map_with_payment_data");
const loadWalletBalanceInDatabase = require("../gift_cards/load_wallet_balance_in_database");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.addFundsToWallet = functions.https.onCall(async (data, context) => {
  const db = admin.firestore();
  const orderMap = data.orderMap;
  const userID = context.auth?.uid ?? null;
  const giftCardMap = {};
  giftCardMap.userDetails = {};
  giftCardMap.userDetails.userID = userID;
  const cardId = orderMap.paymentDetails.cardId;

  try {
    const giftCardOrder = await createSquareGiftCardOrder(orderMap);

    orderMap.paymentDetails.orderId = giftCardOrder.order.id;
    orderMap.paymentDetails.lineItemUid = giftCardOrder.order.line_items[0].uid;

    const paymentResult = await processGiftCardPayment(orderMap);

    orderMap.paymentDetails.paymentId = paymentResult.payment.id;

    updateGiftCardMapWithPaymentData(giftCardMap, paymentResult);

    await loadMoneyToWallet(
      orderMap.paymentDetails.gan,
      orderMap.paymentDetails.orderId,
      orderMap.paymentDetails.lineItemUid
    );

    updateGiftCardMapForLoad(orderMap, giftCardMap);

    loadWalletBalanceInDatabase(
      orderMap.paymentDetails.amount,
      userID,
      orderMap.metadata.walletUID,
    );

    await addGiftCardActivityToDatabase(db, giftCardMap, userID);

    return 200;
  } catch (error) {
    console.log(error);
    return {
      status: "ERROR",
      message: error.message,
    };
  }
});
