const admin = require('firebase-admin');

const updateGiftCardMapWithPaymentData = (giftCardMap, paymentResult) => {

  if (paymentResult) {
    giftCardMap.paymentDetails.paymentID = paymentResult.payment.id;
    giftCardMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
      new Date(paymentResult.payment.created_at)
    );

  } else {
      giftCardMap.paymentDetails.paymentID = null;
      giftCardMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
        new Date()
      );
      }

};

module.exports = updateGiftCardMapWithPaymentData;
