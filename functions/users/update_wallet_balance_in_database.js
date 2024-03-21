const admin = require("firebase-admin");
const getGiftCardBalance = require("../gift_cards/get_gift_card_balance");

const updateWalletBalanceInDatabase = async (db, orderMap) => {
  const savedPaymentsSnapshot = await db
    .collection("users")
    .doc(orderMap.userDetails.userId)
    .collection("squarePaymentMethods")
    .where("gan", "==", orderMap.paymentDetails.gan)
    .get();

  if (savedPaymentsSnapshot.empty) {
    console.log("No matching wallet found");
    return { error: "No matching wallet found" };
  }

  const savedPaymentDoc = savedPaymentsSnapshot.docs[0];

  const balance = await getGiftCardBalance(orderMap.paymentDetails.gan);

  try {
    // Use the document reference to update the balance field
    await savedPaymentDoc.ref.update({ balance: balance });
    return 200;
  } catch (error) {
    console.error("Error updating card balance:", error);
    return { error: "Error updating card balance" };
  }
};

module.exports = updateWalletBalanceInDatabase;
