const admin = require("firebase-admin");

const updateWalletBalanceInDatabase = async (db, orderMap, giftCardMap) => {

  const savedPaymentsSnapshot = await db.collection("users").doc(orderMap.userDetails.userID)
    .collection("squarePaymentMethods")
    .where("gan", "==", giftCardMap.cardDetails.gan)
    .get();

  if (savedPaymentsSnapshot.empty) {
    console.log("No matching wallet found");
    return { error: "No matching wallet found" };
  }

  const savedPayment = savedPaymentsSnapshot.docs[0];
  const orderAmount = parseInt(orderMap.totals.totalAmount + orderMap.totals.tipAmount) || 0;
  const originalBalance = parseInt(savedPayment.data().balance) || 0;

  try {
    await savedPayment.ref.update({ balance: originalBalance - orderAmount });
    return 200;
  } catch (error) {
    return { error: "Error updating card balance" };
  }
};

module.exports = updateWalletBalanceInDatabase;
