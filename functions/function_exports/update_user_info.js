const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { updateSquareCustomer } = require('../users/update_square_customer');

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

exports.updateUserInfo = functions.https.onCall(async (data, context) => {

  const { uid, firstName, lastName, phone, email, squareCustomerId } = data;


  const userCollection = db.collection("users");

  try {
     // Check if the email already exists in the system excluding the current user
         const emailSnapshot = await userCollection.where('email', '==', email).get();
         if (!emailSnapshot.empty) {
           const emailDoc = emailSnapshot.docs[0];
           if (emailDoc.id !== uid) {
             return { status: "error", message: "The email address is already in use by another account." };
           }
         }

     // Check if the phone number already exists in the system excluding the current user
         const phoneSnapshot = await userCollection.where('phone', '==', phone).get();
         if (!phoneSnapshot.empty) {
           const phoneDoc = phoneSnapshot.docs[0];
           if (phoneDoc.id !== uid) {
             return { status: "error", message: "The phone number is already in use by another account." };
           }
         }

    // Call the Square API to keep the square customer info synced
    await updateSquareCustomer(firstName, lastName, email, phone, squareCustomerId);

    // Update the email in Firebase Authentication for login
    await admin.auth().updateUser(uid, {
      email: email,
    });

    // Update the user document
    await userCollection.doc(uid).update({
      firstName,
      lastName,
      phone,
      email,
    });

    return { status: "success", message: "User updated successfully." };
  } catch (error) {
    console.error("Error updating user:", error);
    return { status: "error", message: "An error occurred while updating the user." };
  }
});