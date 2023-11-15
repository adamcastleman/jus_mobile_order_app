const admin = require("firebase-admin");
const { customAlphabet } = require("nanoid");
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendGiftCardConfirmationEmail = require("../emails/send_gift_card_confirmation_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addGiftCardActivityToDatabase = async (db, giftCardMap, userID) => {
  const alphabet = "0123456789ABCDEF";
  const nanoid = customAlphabet(alphabet, 10);

  console.log("I have entered gift card activity");

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

    console.log("Before set condition");

    console.log(giftCardMap.cardDetails.activity);

    await giftCardActivitiesRef.set(giftCardMap);
    if (
      giftCardMap.cardDetails.activity == "LOAD" ||
      giftCardMap.cardDetails.activity == "TRANSFER"
    ) {
      await sendGiftCardConfirmationEmail(giftCardMap);
    }

    return giftCardMap;
  } catch (error) {
    console.log("Error adding order to database:", error.message);
    await addFailedOrderToDatabase(db, giftCardMap);
    await sendEmailToAdminOnFailedOrder(giftCardMap);

    throw error;
  }
};

module.exports = addGiftCardActivityToDatabase;
