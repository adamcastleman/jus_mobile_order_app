const  convertDatesToTimestamps  = require("../orders/convert_dates_to_timestamps");

const addFailedOrderToDatabase = async (db, orderMap) => {
  console.log("Inside addFailedOrderToDatabase function");

  convertDatesToTimestamps(orderMap);
  const newOrderRef = db.collection("failed_orders").doc();

  orderMap.uid = newOrderRef.id;
  orderMap.orderID = newOrderRef.id;
  orderMap.orderStatus = "failed";

  await newOrderRef.set(orderMap);
  console.log("Failed Order added to database successfully");

  return true;
};

module.exports = addFailedOrderToDatabase;
