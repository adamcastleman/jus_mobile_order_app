const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.createUser = functions.https.onCall(async (data, context) => {
  const firstName = data.firstName;
  const lastName = data.lastName;
  const email = data.email;
  const phone = data.phone;
  const points = data.points;
  const uid = data.uid;

  const userDocument = {
    uid: uid,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    points: points,
    isActiveMember: false,
  };

  const docRef = db.collection("users").doc(uid);

  const memberStatsRef = db
    .collection("users")
    .doc(uid)
    .collection("memberStatistics")
    .doc("stats");

  try {
    await docRef.set(userDocument);
    await memberStatsRef.set({
      totalSaved: 0,
      bonusPoints: 0,
    });
    return { status: "User created successfully", uid: docRef.id };
  } catch (error) {
    console.error("Error creating user:", error);
    throw new functions.https.HttpsError("unknown", "Error creating user.");
  }
});
