const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { createSquareClient } = require("../payments/square_client");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.getUnpaidSquareInvoiceId = functions.https.onCall(async (data, context) => {
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
          customerIds: [customerId],
          invoiceStatus: ['UNPAID']
        },
        sort: {
          field: 'INVOICE_SORT_DATE',
          order: 'DESC'
        }
      },
      limit: 1
    });

    // Check if any invoices were found
    if (response.result.invoices && response.result.invoices.length > 0) {
      const invoiceId = response.result.invoices[0].id;
      return invoiceId;
    } else {
      throw new functions.https.HttpsError('not-found', 'No unpaid invoices found for this customer.');
    }
  } catch (error) {
    console.error('Error fetching invoices:', error);
    throw new functions.https.HttpsError('internal', 'Unable to fetch invoices', {
      details: error.message
    });
  }
});