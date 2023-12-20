const admin = require("firebase-admin");

const addFailedOrderToDatabase = async (db, orderMap) => {
  console.log("Inside addFailedOrderToDatabase function");

  const orderWithoutCardSource = { ...orderMap };

  console.log(`Order Map: ${orderMap}`);
  delete orderWithoutCardSource.cardId;

  const newOrderRef = db.collection("failedOrders").doc();

  orderWithoutCardSource.uid = newOrderRef.id;
  orderWithoutCardSource.orderID = newOrderRef.id;
  orderWithoutCardSource.orderStatus = "failed";

  await newOrderRef.set(orderWithoutCardSource);
  console.log("Failed Order added to database successfully");

  return true;
};

module.exports = addFailedOrderToDatabase;
