const admin = require("firebase-admin");

const updateOrderMapWithPaymentDataZeroCharge = (orderMap) => {
   const sourceType = "EXTERNAL";
      orderMap.paymentDetails.paymentId = null;
      orderMap.paymentDetails.paymentStatus = "COMPLETED";
      orderMap.paymentDetails.cardBrand =
        sourceType === "EXTERNAL" || sourceType === "CASH" ? null : "NON-CARD";
      orderMap.paymentDetails.last4 =
        sourceType === "EXTERNAL" || sourceType === "CASH" ? null : "";
      orderMap.paymentDetails.createdAt = admin.firestore.Timestamp.fromDate(
        new Date(),
      );
};

module.exports = updateOrderMapWithPaymentDataZeroCharge;
