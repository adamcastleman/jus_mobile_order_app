const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.squareCreditCardIdFromNonce = functions.https.onCall(async (data, context) => {
  const client = await createSquareClient();
  const { squareCustomerId, nonce } = data;

  let card = {};

  try {
    const cardResponse = await client.cardsApi.createCard({
      idempotencyKey: uuidv4(),
      sourceId: nonce,
      card: {
        customerId: squareCustomerId
      }
    });

     const cardDetails = cardResponse.result.card;

    card = {
       cardId: cardDetails.id,
       last4: cardDetails.last4,
       cardBrand: cardDetails.cardBrand,
       expMonth: cardDetails.expMonth.toString(),
       expYear: cardDetails.expYear.toString(),
    };

    return card;
  } catch (error) {
      console.error('Error creating card with Square:', error);
      throw new functions.https.HttpsError('unknown', 'Error creating card.');
    } // End of try-catch block
     });
