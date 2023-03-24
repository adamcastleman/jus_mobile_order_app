const admin = require('firebase-admin');

const updateOrderMapWithPaymentData = (orderMap, paymentResult) => {
  if (paymentResult) {
    const sourceType = paymentResult.payment.source_type;
    orderMap.paymentID = paymentResult.payment.id;
    orderMap.paymentStatus = paymentResult.payment.status;
    orderMap.cardBrand = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.card_brand;
    orderMap.lastFourDigits = sourceType === 'EXTERNAL' || sourceType === 'CASH' ? null : paymentResult.payment.card_details.card.last_4;
    orderMap.created_at = admin.firestore.Timestamp.fromDate(
      new Date(paymentResult.payment.created_at)
    );
  }
};

module.exports = updateOrderMapWithPaymentData;