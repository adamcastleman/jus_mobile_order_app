const functions = require('firebase-functions');
const admin = require('firebase-admin');
const clearPhysicalGiftCardBalance = require("../gift_cards/clear_physical_gift_card");
const addBalanceToWallet = require("../gift_cards/add_balance_to_wallet");
const updateWalletBalanceInDatabase = require("../gift_cards/load_wallet_balance_in_database");
const updateGiftCardMapForBalanceTransfer = require("../gift_cards/update_gift_card_map_for_balance_transfer");
const addGiftCardActivityToDatabase = require('../gift_cards/add_gift_card_activity_to_database');

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.transferGiftCardBalance = functions.https.onCall(async (data, context) => {

    const db = admin.firestore();
    const userID = context.auth.uid;
   const giftCardMap = data;
    giftCardMap.userDetails.userID = userID;

  try {

    const wallet = await addBalanceToWallet(giftCardMap.cardDetails.gan, giftCardMap.paymentDetails.amount);
    await clearPhysicalGiftCardBalance(giftCardMap.metadata.physicalCardGan, giftCardMap.paymentDetails.amount);
    await loadWalletBalanceInDatabase(giftCardMap.paymentDetails.amount, userID, giftCardMap.metadata.walletUID);
    updateGiftCardMapForBalanceTransfer(giftCardMap, wallet);
    await addGiftCardActivityToDatabase(db, giftCardMap, userID);
    return 200;
  } catch (error) {
    console.log(error.message);
    return 400;
  }
});