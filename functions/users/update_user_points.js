const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const updatePoints = async (db, orderMap) => {

  const userData = await fetchUserData(db, orderMap.userDetails.userID);
  if (!userData) {
    console.log("User document does not exist");
    return { error: "User not found" };
  }

  const pointsEarned = parseInt(orderMap.pointsDetails.pointsEarned) || 0;
  const pointsRedeemed = parseInt(orderMap.pointsDetails.pointsRedeemed) || 0;
  const currentPoints = parseInt(userData.points) || 0;
  const newPoints = currentPoints + pointsEarned - pointsRedeemed;

  try {
    await db.collection("users").doc(orderMap.userDetails.userID).update({ points: newPoints });
    return { success: true, userData: { ...userData, points: newPoints } };
  } catch (error) {
    return { error: "Error updating points" };
  }
};

module.exports = updatePoints;
