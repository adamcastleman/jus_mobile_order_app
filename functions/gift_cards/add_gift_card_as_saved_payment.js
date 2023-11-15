const admin = require("firebase-admin");
const functions = require("firebase-functions");
const addSavedPaymentToDatabase =
  require("../function_exports/add_saved_payment_to_database").addSavedPaymentToDatabase;

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const addGiftCardAsSavedPayment = async (db, giftCardMap, userID) => {
  const data = {
    nonce: null,
    brand: "wallet",
    lastFourDigits: giftCardMap.cardDetails.gan.slice(-4),
    expirationMonth: null,
    expirationYear: null,
    postalCode: null,
    isWallet: true,
    firstName: giftCardMap.userDetails.firstName,
    gan: giftCardMap.cardDetails.gan,
    balance: giftCardMap.paymentDetails.amount,
  };

  const context = { auth: { uid: userID } };

  try {
    const result = await addSavedPaymentToDatabase.run(data, context);
    console.log("Function result:", result);
    return result;
  } catch (error) {
    console.error("Error calling function:", error);
    throw error;
  }
};

module.exports = addGiftCardAsSavedPayment;
