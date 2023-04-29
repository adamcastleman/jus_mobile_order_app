const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");

const updateGiftCardMapForLoad = (orderMap, giftCardMap) => {

  if(!giftCardMap.userDetails) {
  giftCardMap.userDetails = {};
  }
  if(!giftCardMap.paymentDetails) {
  giftCardMap.paymentDetails = {};
  }
  if (!giftCardMap.cardDetails) {
    giftCardMap.cardDetails = {};
  }

  giftCardMap.userDetails.firstName = orderMap.userDetails.firstName;
  giftCardMap.userDetails.email = orderMap.userDetails.email;
  giftCardMap.cardDetails.activityID = uuidv4();
  giftCardMap.cardDetails.activity = "LOAD";
  giftCardMap.cardDetails.gan = orderMap.paymentDetails.gan;
  giftCardMap.paymentDetails.amount = orderMap.paymentDetails.amount;
  giftCardMap.paymentDetails.paymentID = orderMap.paymentDetails.paymentID;
  giftCardMap.paymentDetails.currency = "USD";

  return giftCardMap;
};

module.exports = updateGiftCardMapForLoad;
