const admin = require("firebase-admin");
const fetchUserData = require("../users/fetch_user_data");

const updateMemberSavings = async (db, orderMap) => {
  const userData = await fetchUserData(db, orderMap.userDetails.userId);
  if (!userData) {
    console.log("User document does not exist");
    return { error: "User not found" };
  }

  const isMember = userData.isActiveMember;

  if (isMember) {
    const savedThisOrder = orderMap.userDetails.memberSavings;
    const bonusPoints = orderMap.pointsDetails.bonusPoints;

    try {
      // Query the subscriptions collection for the document with the matching userId
      const subscriptionsQuery = await db.collection("subscriptions")
                                        .where("userId", "==", orderMap.userDetails.userId)
                                        .get();

      if (subscriptionsQuery.empty) {
        console.log("Subscription document does not exist for user:", orderMap.userDetails.userId);
        return { error: "Subscription not found" };
      }

      // Assuming there is only one subscription per user, take the first document
      const subscriptionDoc = subscriptionsQuery.docs[0];

      // Update the document with new values
      await subscriptionDoc.ref.update({
        totalSaved: admin.firestore.FieldValue.increment(savedThisOrder),
        bonusPoints: admin.firestore.FieldValue.increment(bonusPoints),
      });

      return { status: 200, message: "Member savings updated successfully" };
    } catch (error) {
      console.error("Error updating member savings:", error);
      return { error: "Error adding member stats" };
    }
  } else {
    return { status: 200, message: "User is not an active member" };
  }
};

module.exports = updateMemberSavings;
