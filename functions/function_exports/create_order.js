const functions = require("firebase-functions");
const admin = require("firebase-admin");
const processPayment = require("../payments/process_payment");
const updateOrderMapWithPaymentData = require("../payments/update_order_map_with_payment_data");
const addOrderToDatabase = require("../orders/add_order_to_database");
const updatePoints = require("../users/update_user_points");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.createOrder = functions.https.onCall(async (data, context) => {

  const db = admin.firestore();
  const orderMap = data.orderMap;
  const userID = context.auth?.uid ?? null;
  orderMap.userDetails.userID = userID;

   try {
      const paymentResult = await processPayment(orderMap);
      updateOrderMapWithPaymentData(orderMap, paymentResult);
      await addOrderToDatabase(db, orderMap, userID);
      userID === null ? null : await updatePoints(db, orderMap);


      return 200;
    } catch (error) {
    console.log(error);
      return {
        status: 'ERROR',
        message: error.message
      };
    }

});