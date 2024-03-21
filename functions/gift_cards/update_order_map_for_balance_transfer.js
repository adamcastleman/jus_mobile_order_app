const admin = require("firebase-admin");

const updateOrderMapForBalanceTransfer = (orderMap, wallet) => {
  if (!orderMap.cardDetails) {
    orderMap.cardDetails = {};
  }

  orderMap.cardDetails.id = wallet.gift_card_activity.gift_card_id;
  orderMap.cardDetails.activityId = wallet.gift_card_activity.id;
  orderMap.cardDetails.activity = "TRANSFER";
  orderMap.paymentDetails.paymentId = null;
  orderMap.paymentDetails.currency = "USD";
  orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
    new Date(),
  );
};

module.exports = updateOrderMapForBalanceTransfer;
