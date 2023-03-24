const admin = require("firebase-admin");

const fetchUserData = async (db, userID) => {
  const userRef = db.collection("users").doc(userID);
  const userDoc = await userRef.get();

  if (userDoc.exists) {
    return userDoc.data();
  } else {
    console.log("User document does not exist");
    return null;
  }
};

module.exports = fetchUserData;
