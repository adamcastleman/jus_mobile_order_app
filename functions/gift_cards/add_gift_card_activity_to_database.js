const admin = require("firebase-admin");
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendGiftCardConfirmationEmail = require("../emails/send_gift_card_confirmation_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addGiftCardActivityToDatabase = async (db, orderMap) => {
  if (!orderMap.orderDetails) {
    orderMap.orderDetails = {};
  }

  try {
    delete orderMap.paymentDetails.cardId;
    delete orderMap.metadata;

    const giftCardActivitiesRef = db.collection("walletActivities").doc();

    orderMap.uid = giftCardActivitiesRef.id;
    orderMap.orderDetails.orderStatus = "SUCCESS";

    await giftCardActivitiesRef.set(orderMap);
    if (
      orderMap.cardDetails.activity == "LOAD" ||
      orderMap.cardDetails.activity == "TRANSFER"
    ) {
      await sendGiftCardConfirmationEmail(orderMap);
    }

    return orderMap;
  } catch (error) {
    console.log("Error adding order to database:", error.message);
    await addFailedOrderToDatabase(db, orderMap);
    await sendEmailToAdminOnFailedOrder(orderMap);

    throw error;
  }
};

module.exports = addGiftCardActivityToDatabase;
