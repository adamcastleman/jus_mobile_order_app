const admin = require("firebase-admin");

const updateGiftCardMapWithCardData = (giftCardMap, createdGiftCard) => {
  if (!giftCardMap.cardDetails) {
    giftCardMap.cardDetails = {};
  }

  giftCardMap.cardDetails.id = createdGiftCard.gift_card_activity.gift_card_id;
  giftCardMap.cardDetails.activityID = createdGiftCard.gift_card_activity.id;
  giftCardMap.cardDetails.activity = createdGiftCard.gift_card_activity.type;
  giftCardMap.cardDetails.gan =
    createdGiftCard.gift_card_activity.gift_card_gan;
};

module.exports = updateGiftCardMapWithCardData;
