const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");

const updateGiftCardMapForRedemption = (orderMap, giftCardMap) => {

  // Initialize userDetails, paymentDetails, and cardDetails if they don't exist
  giftCardMap.userDetails = giftCardMap.userDetails || {};
  giftCardMap.paymentDetails = giftCardMap.paymentDetails || {};
  giftCardMap.cardDetails = giftCardMap.cardDetails || {};

  // Initialize orderDetails if it doesn't exist
  giftCardMap.orderDetails = giftCardMap.orderDetails || {};

  // Update giftCardMap properties
  giftCardMap.userDetails.firstName = orderMap.userDetails.firstName;
  giftCardMap.userDetails.email = orderMap.userDetails.email;
  giftCardMap.userDetails.userID = orderMap.userDetails.userID;
  giftCardMap.cardDetails.id = orderMap.paymentDetails.giftCardID;
  giftCardMap.orderDetails.orderNumber = orderMap.orderDetails.orderNumber;
  giftCardMap.cardDetails.activityID = uuidv4();
  giftCardMap.cardDetails.activity = "REDEEM";
  giftCardMap.cardDetails.gan = orderMap.paymentDetails.gan;
  giftCardMap.paymentDetails.paymentID = null;
  giftCardMap.paymentDetails.amount = orderMap.totals.totalAmount + orderMap.totals.tipAmount;
  giftCardMap.paymentDetails.currency = "USD";
  giftCardMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(new Date());


  return giftCardMap;
};

module.exports = updateGiftCardMapForRedemption;
