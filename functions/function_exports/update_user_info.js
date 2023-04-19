const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.updateUserInfo = functions.https.onCall(async (data, context) => {
  const userCollection = db.collection("users");
  const uid = context.auth?.uid ?? null;

  if (!uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated."
    );
  }

  const { firstName, lastName, phone, email } = data;

  try {
    await userCollection.doc(uid).update({
      firstName,
      lastName,
      phone,
      email,
    });
    return { status: "success", message: "User updated successfully." };
  } catch (error) {
    console.error("Error updating user:", error);
    throw new functions.https.HttpsError(
      "unknown",
      "An error occurred while updating the user."
    );
  }
});
