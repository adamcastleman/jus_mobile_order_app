const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const updatePoints = async (db, orderMap) => {
  console.log(orderMap);

  const userData = await fetchUserData(db, orderMap.userID);
  if (!userData) {
    console.log("User document does not exist");
    return { error: "User not found" };
  }

  const pointsEarned = parseInt(orderMap.pointsEarned) || 0;
  const pointsRedeemed = parseInt(orderMap.pointsRedeemed) || 0;
  const currentPoints = parseInt(userData.points) || 0;
  const newPoints = currentPoints + pointsEarned - pointsRedeemed;
  console.log("New Points:", newPoints);

  try {
    await db.collection("users").doc(orderMap.userID).update({ points: newPoints });
    return { success: true, userData: { ...userData, points: newPoints } };
  } catch (error) {
    return { error: "Error updating points" };
  }
};

module.exports = updatePoints;