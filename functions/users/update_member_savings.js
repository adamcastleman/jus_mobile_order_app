const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const updateMemberSavings = async (db, orderMap) => {
  const userData = await fetchUserData(db, orderMap.userDetails.userID);
  if (!userData) {
    console.log("User document does not exist");
    return { error: "User not found" };
  }

  const isMember = userData.isActiveMember;

  if (isMember) {
    const savedThisOrder = orderMap.userDetails.memberSavings;
    const bonusPoints = orderMap.pointsDetails.bonusPoints;

    try {
      const memberStatsRef = db
        .collection("users")
        .doc(orderMap.userDetails.userID)
        .collection("memberStatistics")
        .doc("stats");

      await memberStatsRef.set(
        {
          totalSaved: admin.firestore.FieldValue.increment(savedThisOrder),
          bonusPoints: admin.firestore.FieldValue.increment(bonusPoints),
        },
        { merge: true }
      );

      return 200;
    } catch (error) {
      return { error: "Error adding member stats" };
    }
  } else {
    return 200;
  }
};

module.exports = updateMemberSavings;
