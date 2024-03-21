const functions = require("firebase-functions");
const admin = require("firebase-admin");
const createSquareGiftCardOrder = require("../orders/create_square_gift_card_order");
const processGiftCardPayment = require("../payments/process_gift_card_payment");
const createNewGiftCard = require("../gift_cards/create_new_gift_card");
const updateOrderMapWithCardData = require("../gift_cards/update_order_map_with_card_data");
const updateOrderMapWithPaymentData = require("../gift_cards/update_order_map_with_payment_data");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");
const addGiftCardAsSavedPayment = require("../gift_cards/add_gift_card_as_saved_payment");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.createDigitalGiftCard = functions.https.onCall(
  async (data, context) => {
    const db = admin.firestore();
    const orderMap = data.orderMap;
    const userId = context.auth?.uid ?? null;
    orderMap.userDetails.userId = userId;
    const cardId = orderMap.paymentDetails.cardId;
    orderMap.orderDetails = {};
    const amount = parseInt(orderMap.paymentDetails.amount, 10);

    if (amount > 50000) {
      return {
        status: "ERROR",
        message:
          "There was a serious error when attempting this request. Please try again later.",
      };
    }

    try {
      const giftCardOrder = await createSquareGiftCardOrder(
        orderMap,
        "New Wallet",
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

      updateOrderMapWithPaymentData(orderMap, paymentResult);

      const createdGiftCard = await createNewGiftCard(orderMap);

      updateOrderMapWithCardData(orderMap, createdGiftCard);

      await addGiftCardActivityToDatabase(db, orderMap);

      await addGiftCardAsSavedPayment(db, orderMap);

      return 200;
    } catch (error) {
      console.log(error);
      return {
        status: "ERROR",
        message: error.message,
      };
    }
  },
);
