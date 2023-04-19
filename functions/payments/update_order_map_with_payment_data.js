const admin = require('firebase-admin');

const updateOrderMapWithPaymentData = (orderMap, paymentResult) => {
  if (paymentResult) {
    const sourceType = paymentResult.payment.source_type;
    orderMap.paymentDetails.paymentID = paymentResult.payment.id;
    orderMap.paymentDetails.paymentStatus = paymentResult.payment.status;
    orderMap.paymentDetails.cardBrand = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.card_brand.toUpperCase();
    orderMap.paymentDetails.lastFourDigits = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.last_4;
    orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
      new Date(paymentResult.payment.created_at)
    );

  } else {
     const sourceType = 'EXTERNAL';
      orderMap.paymentDetails.paymentID = null;
      orderMap.paymentDetails.paymentStatus = 'COMPLETED';
      orderMap.paymentDetails.cardBrand = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : 'NON-CARD';
      orderMap.paymentDetails.lastFourDigits = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : '';
      orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
        new Date()
      );
      }

};

module.exports = updateOrderMapWithPaymentData;
