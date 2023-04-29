const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const loadWalletBalanceInDatabase = async (amount, userID, walletUID) => {

    const db = admin.firestore();
    const userData = await fetchUserData(db, userID);
     if (!userData) {
        console.log("User document does not exist");
        return { error: "User not found" };
      }
      try {
          const walletDoc = await db.collection("users").doc(userID).collection("squarePaymentMethods").doc(walletUID).get();
             const currentBalance = walletDoc.data().balance;
             const newBalance = currentBalance + amount;
             await db.collection("users").doc(userID).collection("squarePaymentMethods").doc(walletUID).update({ balance: newBalance });
          return 200
        } catch (error) {
        console.log(error);
          return { error: "Error adding balance to wallet" };
        }
}

module.exports = loadWalletBalanceInDatabase;
