const admin = require("firebase-admin");
const  convertDatesToTimestamps  = require("../orders/convert_dates_to_timestamps");
const  addFailedOrderToDatabase  = require("../orders/add_failed_order_to_database");
const  sendEmailToAdminOnFailedOrder  = require("../orders/send_email_to_admin_on_failed_order");
const { customAlphabet } = require('nanoid');


const addOrderToDatabase = async (db, orderMap, userID) => {
    const orderWithoutNonce = { ...orderMap };
    const alphabet = '0123456789ABCDEF';
    const nanoid = customAlphabet(alphabet, 10);

  try {
    delete orderWithoutNonce.nonce;

    convertDatesToTimestamps(orderWithoutNonce);

    const randomNumber = Math.floor(Math.random() * 10000);
    const paddedNumber = randomNumber.toString().padStart(4, '0');

    const newOrderRef = db.collection("orders").doc();
    orderWithoutNonce.uid = newOrderRef.id;
    orderWithoutNonce.userID = userID;
    orderWithoutNonce.orderStatus = "SUCCESS";
    orderWithoutNonce.orderNumber = nanoid();

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
