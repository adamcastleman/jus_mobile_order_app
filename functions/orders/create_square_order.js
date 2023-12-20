const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { customAlphabet } = require("nanoid");
const { createSquareClient } = require("../payments/square_client");
const recordZeroChargeOrder = require("../payments/record_zero_charge_order");

///VARIATION ID IS WHAT WE NEED FROM THE CATALOG. WE DO NOT NEED THE ACTUAL CATALOG ID OF
///THE ITEM. WE WILL NEED TO MAKE SOME CORRECTIONS TO THE PRODUCT MODEL. THE BEST THING TO
///DO WILL BE TO RENAME THE 'PRICE' PARAMATER TO 'VARIATIONS', AND THEN ADD A NEW FIELD IN THAT
///MAP TO BE CATALOG ID. REMEMBER TO REMOVE THE SQUARE CATALOG ID FROM THE PRODUCT MODEL.
//HOPEFULLY, THIS WILL NOT POSE A HUGE PROBLEM IN REFACTORING THE APP. HOWEVER, ONCE THIS IS DONE,
///WE WILL BE IN BUSINESS FULLY SYNCED FROM SQUARE.

const createSquareOrder = async (orderMap) => {
  const client = await createSquareClient();
  const currency = orderMap.paymentDetails.currency;
  const totalAmount = orderMap.totals.totalAmount;
  const alphabet = "0123456789ABCDEF";
  const nanoid = customAlphabet(alphabet, 10);

  // Create an array to hold the discounts
  let discounts = [];

  // Convert orderMap.items to Square lineItems format
  const lineItems = orderMap.orderDetails.items.map((item, index) => {
      // Generate a unique discount UID for each item
      const discountUID = `discount-${index}-${nanoid()}`;
      if (item.itemDiscount > 0) {
        // Add discount details to the discounts array
        discounts.push({
          uid: discountUID,
          name: "Item Discount",
          amountMoney: {
            amount: parseInt(item.itemDiscount),
            currency: currency
          },
          appliedMoney: {
            amount: parseInt(item.itemDiscount),
            currency: 'USD'
          },
          scope: "LINE_ITEM"
        });
      }

      // Process modifiers
      const modifiers = item.modifications.map(mod => {
        try {
          const jsonMod = JSON.parse(mod);
          return {
            name: jsonMod.name,
            quantity: "1",
            basePriceMoney: {
              amount: jsonMod.price.toString(),
              currency: currency
            }
          };
        } catch (e) {
          console.error('Error parsing modification:', mod, e);
          return null; // Return null or some default value in case of error
        }
      }).filter(mod => mod !== null); // Filter out null values

      // Return line item object
      return {
        catalogObjectId: 'CWWLFMBOBTWCRRBPDLWCFYAQ',
        quantity: item.itemQuantity.toString(),
        itemType: 'ITEM',
        basePriceMoney: {
          amount: item.price.toString(),
          currency: currency
        },
        modifiers: modifiers,
        appliedDiscounts: item.itemDiscount > 0 ? [{ discountUid: discountUID }] : []
      };
  });

  try {
    const orderResponse = await client.ordersApi.createOrder({
      order: {
        locationId: 'LPRZ3G3PWZBKF',
        source: {
          name: orderMap.orderDetails.orderSource
        },
        customerId: orderMap.userDetails.squareCustomerId,
        lineItems: lineItems,
        discounts: discounts,
        taxes: [
          {
            name: 'Sales Tax',
            percentage: totalAmount !== 0 ? (orderMap.locationDetails.locationTaxRate * 100).toString() : "0",
            scope: "ORDER"
          }
        ]
      },
      idempotencyKey: uuidv4()
    });

    const orderResponseJson = JSON.parse(orderResponse.body);
    orderMap.orderDetails.orderNumber = orderResponseJson.order.id;

    if (totalAmount === 0 || totalAmount === 0.00) {
      await recordZeroChargeOrder(orderMap);
    }
  } catch(error) {
    console.log(error);
  }
}

module.exports = createSquareOrder;
