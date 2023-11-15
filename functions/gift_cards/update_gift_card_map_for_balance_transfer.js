const admin = require("firebase-admin");

const updateGiftCardMapForBalanceTransfer = (giftCardMap, wallet) => {
  if (!giftCardMap.cardDetails) {
    giftCardMap.cardDetails = {};
  }

  giftCardMap.cardDetails.id = wallet.gift_card_activity.gift_card_id;
  giftCardMap.cardDetails.activityID = wallet.gift_card_activity.id;
  giftCardMap.cardDetails.activity = "TRANSFER";
  giftCardMap.paymentDetails.paymentID = null;
  giftCardMap.paymentDetails.currency = "USD";
  giftCardMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
    new Date(),
  );
};

module.exports = updateGiftCardMapForBalanceTransfer;
