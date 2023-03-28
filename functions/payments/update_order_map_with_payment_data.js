const admin = require('firebase-admin');

const updateOrderMapWithPaymentData = (orderMap, paymentResult) => {
  if (paymentResult) {
    const sourceType = paymentResult.payment.source_type;
    orderMap.paymentID = paymentResult.payment.id;
    orderMap.paymentStatus = paymentResult.payment.status;
    orderMap.cardBrand = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.card_brand.toUpperCase();
    orderMap.lastFourDigits = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.last_4;
    orderMap.createdAt = admin.firestore.Timestamp.fromDate(
      new Date(paymentResult.payment.created_at)
    );

  } else {
     const sourceType = 'EXTERNAL';
      orderMap.paymentID = null;
      orderMap.paymentStatus = 'COMPLETED';
      orderMap.cardBrand = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : 'NON-CARD';
      orderMap.lastFourDigits = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : '';
      orderMap.createdAt = admin.firestore.Timestamp.fromDate(
        new Date()
      );
      }

};

module.exports = updateOrderMapWithPaymentData;