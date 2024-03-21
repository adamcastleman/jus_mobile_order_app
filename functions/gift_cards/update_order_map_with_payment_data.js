const admin = require("firebase-admin");

const updateOrderMapWithPaymentData = (orderMap, paymentResult) => {
  if (!orderMap.paymentDetails) {
    orderMap.paymentDetails = {};
  }

  if (paymentResult) {
    orderMap.paymentDetails.paymentId = paymentResult.payment.id;
    orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
      new Date(paymentResult.payment.created_at),
    );
  } else {
    orderMap.paymentDetails.paymentId = null;
    orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
      new Date(),
    );
  }
};

module.exports = updateOrderMapWithPaymentData;
