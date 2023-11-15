const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { createSquareClient } = require("../payments/square_client");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.getGiftCardBalanceFromNonce = functions.https.onCall(
  async (data, context) => {
    const client = await createSquareClient();

    try {
      const response = await client.giftCardsApi.retrieveGiftCardFromNonce({
        nonce: data.nonce,
      });

      const result = JSON.parse(response.body);

      return {
        gan: result.gift_card.gan,
        amount: result.gift_card.balance_money.amount,
      };
    } catch (error) {
      console.log("Failed");
      console.log(error);
      return error.message;
    }
  },
);
