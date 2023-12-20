const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");
const getSquareLocationID = require("../gift_cards/get_square_location_id");

const createSquareGiftCardOrder = async (giftCardMap) => {
  const client = await createSquareClient();
  const currency = giftCardMap.paymentDetails.currency;
  const totalAmount = giftCardMap.paymentDetails.amount;
  const locationID = await getSquareLocationID();

 try {
   const response = await client.ordersApi.createOrder({
     order: {
       locationId: locationID,
       customerId: giftCardMap.userDetails.squareCustomerId,
       lineItems: [
         {
           name: 'Wallet Load',
           quantity: '1',
           itemType: 'GIFT_CARD',
           basePriceMoney: {
             amount: giftCardMap.paymentDetails.amount,
             currency: giftCardMap.paymentDetails.currency
           }
         }
       ]
     },
     idempotencyKey: uuidv4()
   });

   return JSON.parse(response.body);
 } catch(error) {
   console.log(error);
 }
};

module.exports = createSquareGiftCardOrder;
