const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Client, Environment } = require('square');
const { createSquareClient } = require("../payments/square_client");


if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.getSquareInvoices = functions.https.onCall(async (data, context) => {
  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

    const customerId = data.customerId;
    if (!customerId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with a customer ID.');
    }

   const client = await createSquareClient();

  try {
    const response = await client.invoicesApi.searchInvoices({
      query: {
        filter: {
          locationIds: ['LPRZ3G3PWZBKF'],
          customerIds: [customerId]
        },
        sort: {
          field: 'INVOICE_SORT_DATE',
          order: 'DESC'
        }
      },
      limit: 10
    });

    const invoices = response.result.invoices;
    const invoiceDetails = invoices.map(invoice => {
      const paymentDate = invoice.updatedAt;
      const itemName = invoice.title;
      const firstPaymentRequest = invoice.paymentRequests[0];

     const priceCharged = Number(firstPaymentRequest.computedAmountMoney.amount);

      return { paymentDate, itemName, priceCharged };
    });

    return invoiceDetails;
  } catch (error) {
    console.error('Error fetching invoices:', error);
    throw new functions.https.HttpsError('internal', 'Unable to fetch invoices');
  }
});
