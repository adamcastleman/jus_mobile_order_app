const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.updatePassword = functions.https.onCall(async (data, context) => {
  const newPassword = data.password;
  const uid = context.auth?.uid;

  if (!uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated to update password.",
    );
  }

  try {
    const userRecord = await admin.auth().updateUser(uid, {
      password: newPassword,
    });
    return {
      status: "SUCCESS",
      message: "Password updated successfully.",
    };
  } catch (error) {
    console.error("Error updating password:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Error updating password.",
      error,
    );
  }
});
