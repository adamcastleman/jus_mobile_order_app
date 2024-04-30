const admin = require("firebase-admin");
const convertDatesToTimestamps = require("../orders/convert_dates_to_timestamps");
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendScheduledItems = require("../orders/send_scheduled_items");
const extractScheduledItems = require("../orders/extract_scheduled_items");
const sendOrderConfirmationEmail = require("../emails/send_order_confirmation_email");
const sendCleanseInstructionsEmail = require("../emails/send_cleanse_instructions_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addOrderToDatabase = async (db, orderMap) => {
  const orderWithoutCardSource = { ...orderMap };

  try {
    delete orderWithoutCardSource.paymentDetails.cardId;
    delete orderWithoutCardSource.paymentDetails.gan;

    convertDatesToTimestamps(orderWithoutCardSource);

    const newOrderRef = db.collection("orders").doc();
    orderWithoutCardSource.uid = newOrderRef.id;
    orderWithoutCardSource.orderDetails.orderStatus = "RECEIVED";

    await newOrderRef.set(orderWithoutCardSource);

    const scheduledItems = extractScheduledItems(orderWithoutCardSource);
    if (scheduledItems.length > 0) {
      sendScheduledItems(scheduledItems);
    }

    await sendOrderConfirmationEmail(orderWithoutCardSource);

    for (let i = 0; i < orderWithoutCardSource.orderDetails.items.length; i++) {
      const item = orderWithoutCardSource.orderDetails.items[i];
      if (item.name === "Full-Day Cleanse" || item.name === "Half-Day Cleanse") {
        await sendCleanseInstructionsEmail(orderWithoutCardSource);
        break;
      }
    }

    return orderWithoutCardSource;
  } catch (error) {
    await addFailedOrderToDatabase(db, orderWithoutCardSource);
    await sendEmailToAdminOnFailedOrder(orderWithoutCardSource);
    console.error("Error adding order to database:", error);
    return 400;
  }
};

module.exports = addOrderToDatabase;
