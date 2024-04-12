
 const functions = require("firebase-functions");
 const admin = require("firebase-admin");

 if (admin.apps.length === 0) {
   admin.initializeApp();
 }

 exports.isPhoneNumberInUse = functions.https.onCall(async (data, context) => {


     try {
         const phoneNumber = data.phone;
         if (!phoneNumber) {
             throw new functions.https.HttpsError('invalid-argument', 'The function must be called with one argument "phone".');
         }

         const usersRef = admin.firestore().collection('users');
         const snapshot = await usersRef.where('phone', '==', phoneNumber).get();

         // Return consistent structure
         return { exists: !snapshot.empty };
     } catch (error) {
         console.error('Error checking phone number:', error);
         throw new functions.https.HttpsError('unknown', 'Failed to check the phone number');
     }
 });