const admin = require("firebase-admin");

const convertDatesToTimestamps = (orderMap) => {

  const pickupTimeMillis = orderMap.orderDetails.pickupTime;
  const pickupDateMillis = orderMap.orderDetails.pickupDate;

  const pickupTime = pickupTimeMillis
    ? admin.firestore.Timestamp.fromMillis(pickupTimeMillis)
    : null;
  const pickupDate = pickupDateMillis
    ? admin.firestore.Timestamp.fromMillis(pickupDateMillis)
    : null;

  orderMap.orderDetails.pickupTime = pickupTime;
  orderMap.orderDetails.pickupDate = pickupDate;
  orderMap.orderDetails.pickupDateMillis = pickupDateMillis;


};


module.exports = convertDatesToTimestamps;
