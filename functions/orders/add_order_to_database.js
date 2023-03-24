const convertDatesToTimestamps = require('../orders/convert_dates_to_timestamps');
const addFailedOrderToDatabase = require('../orders/add_failed_order_to_database');
const sendEmailToAdminOnFailedOrder = require('../orders/send_email_to_admin_on_failed_order');

const addOrderToDatabase = async (db, orderMap, userID) => {

  try {
    const orderWithoutNonce = { ...orderMap };
    delete orderWithoutNonce.nonce;

    convertDatesToTimestamps(orderWithoutNonce);

    const newOrderRef = db.collection("orders").doc();
    orderWithoutNonce.uid = newOrderRef.id;
    orderWithoutNonce.orderID = newOrderRef.id;
    orderWithoutNonce.userID = userID;
    orderWithoutNonce.orderStatus = "SUCCESS";

    await newOrderRef.set(orderWithoutNonce);

    return orderWithoutNonce;
  } catch (error) {
    await addFailedOrderToDatabase(db, orderWithoutNonce);
    await sendEmailToAdminOnFailedOrder(orderWithoutNonce);
    console.error("Error adding order to database:", error);
    throw error;
  }
};

module.exports = addOrderToDatabase;