const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processPayment = require("../payments/process_payment");
const processGiftCardPayment = require("../payments/process_gift_card_payment");
const updateOrderMapWithPaymentData = require("../payments/update_order_map_with_payment_data");
const addOrderToDatabase = require("../orders/add_order_to_database");
const updatePoints = require("../users/update_user_points");
const updateMemberSavings = require("../users/update_member_savings");
const loadMoneyToWallet = require("../gift_cards/load_money_to_wallet");
const getGiftCardIDFromGan = require("../gift_cards/get_gift_card_id_from_gan");
const updateGiftCardMapForLoad = require("../gift_cards/update_gift_card_map_for_load");
const updateGiftCardMapForRedemption = require("../gift_cards/update_gift_card_map_for_redemption");
const addGiftCardActivityToDatabase = require("../gift_cards/add_gift_card_activity_to_database");
const loadWalletBalanceInDatabase = require('../gift_cards/load_wallet_balance_in_database');
const updateWalletBalanceInDatabase = require('../users/update_wallet_balance_in_database');

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.loadMoneyAndPay = functions.https.onCall(async (data, context) => {

  const db = admin.firestore();
  const orderMap = data.orderMap;
  let giftCardMap = data.metadata;
  const metadata = {};
  metadata.paymentDetails = {
    'walletUID': data.metadata.paymentDetails.walletUID,
    'amount': data.metadata.paymentDetails.amount,
    'currency': data.orderMap.paymentDetails.currency
  };
  metadata.cardDetails = {
   'gan': orderMap.paymentDetails.gan
  };
  const gan = orderMap.paymentDetails.gan ?? null;
  orderMap.paymentDetails.amount = data.metadata.paymentDetails.amount;
  const userID = context.auth?.uid ?? null;
  orderMap.userDetails.userID = userID;

  try {
    await getGiftCardIDFromGan(orderMap);
    await processGiftCardPayment(metadata);
    await loadMoneyToWallet(gan, data.metadata.paymentDetails.amount);
    loadWalletBalanceInDatabase(metadata.paymentDetails.amount, userID, metadata.paymentDetails.walletUID);
    const paymentResult = await processPayment(orderMap);
    updateOrderMapWithPaymentData(orderMap, paymentResult);
    //First, we must log the load event vv
    updateGiftCardMapForLoad(orderMap, giftCardMap);
       const giftCardMapLoad = { ...giftCardMap };
       giftCardMapLoad.paymentDetails = {
         amount: metadata.paymentDetails.amount,
         currency: metadata.paymentDetails.currency,
         walletUID: metadata.paymentDetails.walletUID,
         createdAt: orderMap.paymentDetails.createdAt,
       };
       giftCardMapLoad.userDetails.userID = userID;

       await addGiftCardActivityToDatabase(db, giftCardMapLoad, userID);
    //Next, we update the maps for processing the transaction vv
    updateGiftCardMapForRedemption(orderMap, giftCardMap);
       const giftCardMapRedeem = { ...giftCardMap };
       await updateWalletBalanceInDatabase(db, orderMap, giftCardMapRedeem);
       await addGiftCardActivityToDatabase(db, giftCardMapRedeem, userID);
    await addOrderToDatabase(db, orderMap, userID);
      await updatePoints(db, orderMap);
      await updateMemberSavings(db, orderMap);

    return 200;
  } catch (error) {
    console.log(error);
    return {
      status: 'ERROR',
      message: error.message
    };
  }
  });