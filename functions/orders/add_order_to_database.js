const admin = require("firebase-admin");
const convertDatesToTimestamps = require("../orders/convert_dates_to_timestamps");
const addFailedOrderToDatabase = require("../orders/add_failed_order_to_database");
const sendScheduledItems = require("../orders/send_scheduled_items");
const extractScheduledItems = require("../orders/extract_scheduled_items");
const sendOrderConfirmationEmail = require("../emails/send_order_confirmation_email");
const sendCleanseInstructionsEmail = require("../emails/send_cleanse_instructions_email");
const sendEmailToAdminOnFailedOrder = require("../emails/send_email_to_admin_on_failed_order");

const addOrderToDatabase = async (db, orderMap, userID) => {
  const orderWithoutCardSource = { ...orderMap };

  try {
    delete orderWithoutCardSource.paymentDetails.cardId;
    delete orderWithoutCardSource.paymentDetails.gan;
    delete orderWithoutCardSource.paymentDetails.giftCardID;
    orderWithoutCardSource.orderDetails

    convertDatesToTimestamps(orderWithoutCardSource);

    const newOrderRef = db.collection("orders").doc();
    orderWithoutCardSource.uid = newOrderRef.id;
    orderWithoutCardSource.orderDetails.orderStatus = "RECEIVED";

    await newOrderRef.set(orderWithoutCardSource);

    const scheduledItems = extractScheduledItems(orderMap);

   if(scheduledItems.length > 0) {
       sendScheduledItems(scheduledItems);
   }

    await sendOrderConfirmationEmail(orderWithoutCardSource);

    for (let j = 0; j < orderWithoutCardSource.orderDetails.items.length; j++) {
      const item = orderWithoutCardSource.orderDetails.items[j];

      if (
        item.name === "Full Day Cleanse" ||
        item.name === "Juice 'til Dinner"
      ) {
        await sendCleanseInstructionsEmail(orderMap);
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
