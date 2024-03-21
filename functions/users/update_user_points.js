const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const updatePoints = async (db, orderMap) => {
  const userData = await fetchUserData(db, orderMap.userDetails.userId);
  if (!userData) {
    console.log("User document does not exist");
    return { error: "User not found" };
  }
  const userId = orderMap.userDetails.userId;
  const pointsEarned = parseInt(orderMap.pointsDetails.pointsEarned) || 0;
  const pointsRedeemed = parseInt(orderMap.pointsDetails.pointsRedeemed) || 0;
  const currentPoints = parseInt(userData.points) || 0;
  const newPoints = currentPoints + (pointsEarned - pointsRedeemed);

  try {
    await db
      .collection("users")
      .doc(userId)
      .update({ points: newPoints });

      const pointsActivitiesRef = db.collection("pointsActivities").doc();

      await pointsActivitiesRef.set({
      userId: userId,
      pointsEarned: pointsEarned,
      pointsRedeemed: pointsRedeemed,
      timestamp: Date.now()
      });
    return { status: 200, message: "Successfully added user points" };
  } catch (error) {
    return { status: 400, message: "Error updating points" };
  }
};

module.exports = updatePoints;
