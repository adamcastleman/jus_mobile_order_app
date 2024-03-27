const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize the Firebase app if it hasn't been already
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const secrets = require('./function_exports/get_secret');
const handleSquareWebhooks = require('./function_exports/handle_square_webhooks');

const createUser = require('./function_exports/create_user');
const updateUserInfo = require('./function_exports/update_user_info');
const updatePassword = require('./function_exports/update_password');
const deleteAccountRequest = require('./function_exports/delete_account_request');

const createOrder = require('./function_exports/create_order');
const addToFavorites = require('./function_exports/add_to_favorites');
const removeFromFavorites = require('./function_exports/remove_from_favorites');

const fetchWooSubscriptionData = require('./function_exports/fetch_woo_subscription_data');
const migrateLegacyWooCommerceSubscription = require('./function_exports/migrate_legacy_woocommerce_subscription');
const createSubscription = require('./function_exports/create_subscription');
const cancelSubscription = require('./function_exports/cancel_subscription');
const getSubscription = require('./function_exports/get_subscription');
const getSquareInvoices = require('./function_exports/get_square_invoices');
const resumeSubscription = require('./function_exports/resume_subscription');
const updateSubscriptionPaymentMethod = require('./function_exports/update_subscription_payment_method');

const createDigitalGiftCard = require('./function_exports/create_digital_gift_card');
const addFundsToWallet = require('./function_exports/add_funds_to_wallet');
const getGiftCardBalanceFromNonce = require('./function_exports/get_gift_card_balance_from_nonce');
const transferGiftCardBalance = require('./function_exports/transfer_gift_card_balance');

const squareCreditCardIdFromNonce = require('./function_exports/square_credit_card_id_from_nonce');
const deletePaymentMethod = require('./function_exports/delete_payment_method');
const updateCardNickname = require('./function_exports/update_card_nickname');
const updateDefaultPayment = require('./function_exports/update_default_payment');
const addSavedPaymentToDatabase = require('./function_exports/add_saved_payment_to_database');

const encryptText = require('./function_exports/encryption');
const decryptText = require('./function_exports/decryption');

exports.addFundsToWallet = addFundsToWallet.addFundsToWallet;
exports.addSavedPaymentToDatabase = addSavedPaymentToDatabase.addSavedPaymentToDatabase;
exports.addToFavorites = addToFavorites.addToFavorites;
exports.cancelSubscription = cancelSubscription.cancelSubscription;
exports.createDigitalGiftCard = createDigitalGiftCard.createDigitalGiftCard;
exports.createOrder = createOrder.createOrder;
exports.createSubscription = createSubscription.createSubscription;
exports.createUser = createUser.createUser;
exports.deleteAccountRequest = deleteAccountRequest.deleteAccountRequest;
exports.deletePaymentMethod = deletePaymentMethod.deletePaymentMethod;
exports.fetchWooSubscriptionData = fetchWooSubscriptionData.fetchWooSubscriptionData;
exports.getGiftCardBalanceFromNonce = getGiftCardBalanceFromNonce.getGiftCardBalanceFromNonce;
exports.secrets = secrets.secrets;
exports.getSquareInvoices = getSquareInvoices.getSquareInvoices;
exports.getSubscription = getSubscription.getSubscription;
exports.handleSquareWebhooks = handleSquareWebhooks.handleSquareWebhooks;
exports.migrateLegacyWooCommerceSubscription = migrateLegacyWooCommerceSubscription.migrateLegacyWooCommerceSubscription;
exports.removeFromFavorites = removeFromFavorites.removeFromFavorites;
exports.resumeSubscription = resumeSubscription.resumeSubscription;
exports.squareCreditCardIdFromNonce = squareCreditCardIdFromNonce.squareCreditCardIdFromNonce;
exports.transferGiftCardBalance = transferGiftCardBalance.transferGiftCardBalance;
exports.updateCardNickname = updateCardNickname.updateCardNickname;
exports.updateDefaultPayment = updateDefaultPayment.updateDefaultPayment;
exports.updatePassword = updatePassword.updatePassword;
exports.updateSubscriptionPaymentMethod = updateSubscriptionPaymentMethod.updateSubscriptionPaymentMethod;
exports.updateUserInfo = updateUserInfo.updateUserInfo;
exports.encryptText = encryptText.encryptText;
exports.decryptText = decryptText.decryptText;



