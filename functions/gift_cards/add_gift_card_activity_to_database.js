const admin = require("firebase-admin");
const { customAlphabet } = require('nanoid');
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendGiftCardConfirmationEmail = require("../emails/send_gift_card_confirmation_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addGiftCardActivityToDatabase = async (db, giftCardMap, userID) => {

  const alphabet = '0123456789ABCDEF';
  const nanoid = customAlphabet(alphabet, 10);

  if (!giftCardMap.orderDetails) {
    giftCardMap.orderDetails = {};
  }

  try {

  delete giftCardMap.paymentDetails.nonce;
  delete giftCardMap.metadata;

    const giftCardActivitiesRef = db.collection("walletActivities").doc();

    giftCardMap.uid = giftCardActivitiesRef.id;
    giftCardMap.orderDetails.orderStatus = "SUCCESS";
    giftCardMap.orderDetails.orderNumber = nanoid();

    await giftCardActivitiesRef.set(giftCardMap);

    await sendGiftCardConfirmationEmail(giftCardMap);

    return giftCardMap;
  } catch (error) {
    console.log("Error adding order to database:", error.message);
    await addFailedOrderToDatabase(db, giftCardMap);
    await sendEmailToAdminOnFailedOrder(giftCardMap);

    throw error;
  }
};

module.exports = addGiftCardActivityToDatabase;