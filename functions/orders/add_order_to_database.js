const admin = require("firebase-admin");
const { customAlphabet } = require('nanoid');
const convertDatesToTimestamps = require("../orders/convert_dates_to_timestamps");
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendScheduledItems = require("../orders/send_scheduled_items");
const extractScheduledItems = require("../orders/extract_scheduled_items");
const sendOrderConfirmationEmail = require("../emails/send_order_confirmation_email");
const sendCleanseInstructionsEmail = require("../emails/send_cleanse_instructions_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addOrderToDatabase = async (db, orderMap, userID) => {
  const orderWithoutNonce = { ...orderMap };
  const alphabet = '0123456789ABCDEF';
  const nanoid = customAlphabet(alphabet, 10);

  try {
    delete orderWithoutNonce.paymentDetails.nonce;
    delete orderWithoutNonce.paymentDetails.gan;
    delete orderWithoutNonce.paymentDetails.giftCardID;

    convertDatesToTimestamps(orderWithoutNonce);

    const newOrderRef = db.collection("orders").doc();
    orderWithoutNonce.uid = newOrderRef.id;
    orderWithoutNonce.orderDetails.orderStatus = "RECEIVED";
    orderWithoutNonce.orderDetails.orderNumber = nanoid();

    await newOrderRef.set(orderWithoutNonce);

    const scheduledItems = extractScheduledItems(orderMap);
    sendScheduledItems(scheduledItems);

    await sendOrderConfirmationEmail(orderWithoutNonce);

    for (let j = 0; j < orderWithoutNonce.orderDetails.items.length; j++) {
      const item = orderWithoutNonce.orderDetails.items[j];

      if (item.name === 'Full Day Cleanse' || item.name === 'Juice \'til Dinner') {
        await sendCleanseInstructionsEmail(orderMap);
        break;
      }
    }

    return orderWithoutNonce;
  } catch (error) {
    await addFailedOrderToDatabase(db, orderWithoutNonce);
    await sendEmailToAdminOnFailedOrder(orderWithoutNonce);
    console.error("Error adding order to database:", error);
    return 400;
  }
};

module.exports = addOrderToDatabase;