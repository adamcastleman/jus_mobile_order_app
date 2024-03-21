const functions = require("firebase-functions");
const admin = require("firebase-admin");
const clearPhysicalGiftCardBalance = require("../gift_cards/clear_physical_gift_card");
const addBalanceToWallet = require("../gift_cards/add_balance_to_wallet");
const updateWalletBalanceInDatabase = require("../users/update_wallet_balance_in_database");
const updateOrderMapForBalanceTransfer = require("../gift_cards/update_order_map_for_balance_transfer");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.transferGiftCardBalance = functions.https.onCall(
  async (data, context) => {
    const db = admin.firestore();
    const userID = context.auth.uid;
    const orderMap = data;
    orderMap.userDetails.userID = userId;

    try {
      const wallet = await addBalanceToWallet(
        orderMap.cardDetails.gan,
        orderMap.paymentDetails.amount,
      );
      await clearPhysicalGiftCardBalance(
        orderMap.metadata.physicalCardGan,
        orderMap.paymentDetails.amount,
      );
      //      await updateWalletBalanceInDatabase(
      //        db,
      //        orderMap
      //        {},
      //      );
      updateGiftCardMapForBalanceTransfer(orderMap, wallet);
      await addGiftCardActivityToDatabase(db, orderMap);
      return 200;
    } catch (error) {
      console.log(error.message);
      return 400;
    }
  },
);
