const admin = require("firebase-admin");

const convertDatesToTimestamps = (orderMap) => {

  const pickupTimeMillis = orderMap.pickupTime;
  const pickupDateMillis = orderMap.pickupDate;

  const pickupTime = pickupTimeMillis
    ? admin.firestore.Timestamp.fromMillis(pickupTimeMillis)
    : null;
  const pickupDate = pickupDateMillis
    ? admin.firestore.Timestamp.fromMillis(pickupDateMillis)
    : null;

  orderMap.pickupTime = pickupTime;
  orderMap.pickupDate = pickupDate;
  console.log('Made it to the end');
};

module.exports = convertDatesToTimestamps;