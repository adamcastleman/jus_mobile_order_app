const admin = require("firebase-admin");

const updateOrderMapWithCardData = (orderMap, createdGiftCard) => {
  if (!orderMap.cardDetails) {
    orderMap.cardDetails = {};
  }

  orderMap.cardDetails.id = createdGiftCard.gift_card_activity.gift_card_id;
  orderMap.cardDetails.activityID = createdGiftCard.gift_card_activity.id;
  orderMap.cardDetails.activity = createdGiftCard.gift_card_activity.type;
  orderMap.cardDetails.gan = createdGiftCard.gift_card_activity.gift_card_gan;
};

module.exports = updateOrderMapWithCardData;
