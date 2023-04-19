const admin = require("firebase-admin");

const addFailedOrderToDatabase = async (db, orderMap) => {
  console.log("Inside addFailedOrderToDatabase function");

  const orderWithoutNonce = { ...orderMap };
  delete orderWithoutNonce.nonce;

  const newOrderRef = db.collection("failedOrders").doc();

  orderWithoutNonce.uid = newOrderRef.id;
  orderWithoutNonce.orderID = newOrderRef.id;
  orderWithoutNonce.orderStatus = "failed";

  await newOrderRef.set(orderWithoutNonce);
  console.log("Failed Order added to database successfully");

  return true;
};

module.exports = addFailedOrderToDatabase;