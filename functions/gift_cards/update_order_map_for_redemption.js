const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");

const updateOrderMapForRedemption = (orderMap) => {
  // Initialize userDetails, paymentDetails, orderDetails and cardDetails if they don't exist
  orderMap.cardDetails = orderMap.cardDetails || {};
  orderMap.orderDetails = orderMap.orderDetails || {};

  orderMap.cardDetails.activityId = uuidv4();
  orderMap.cardDetails.activity = "REDEEM";
  orderMap.paymentDetails.paymentId = null;
  orderMap.paymentDetails.currency = "USD";
  orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
    new Date(),
  );

  return orderMap;
};

module.exports = updateOrderMapForRedemption;
