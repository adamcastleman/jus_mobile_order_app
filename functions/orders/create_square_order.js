const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { customAlphabet } = require("nanoid");
const { createSquareClient } = require("../payments/square_client");
const recordZeroChargeOrder = require("../payments/record_zero_charge_order");

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
        name: item.discountName,
        amountMoney: {
          amount: parseInt(item.itemDiscount),
          currency: currency,
        },
        appliedMoney: {
          amount: parseInt(item.itemDiscount),
          currency: "USD",
        },
        scope: "LINE_ITEM",
      });
    }

const modifiers = item.modifications
  .map((mod) => {
    try {
      const jsonMod = JSON.parse(mod);
      // Determine if catalogObjectId is provided and valid
      const hasCatalogObjectId = jsonMod.squareVariationId && jsonMod.squareVariationId.trim() !== '';

      console.log(jsonMod);


      // Return object conditionally based on presence of catalogObjectId
      return hasCatalogObjectId ? {
      catalogObjectId: jsonMod.price === null || jsonMod.price === 0 ? 'TYG4VOCY7BISP2AIX34PD42D' : jsonMod.price === 25 ? '53K3TALGZM2FR4QRNMTGH5GO' : jsonMod.price === 100 ? 'QAIZQ3XVB57E6QGRNJADFVAW' : 'Q4WIFUARW5YSUH67YMS6M66M',
      //TODO remove hardcoded value for catalogObjectId
//        catalogObjectId: jsonMod.squareVariationId,
        quantity: (jsonMod.quantity || '1').toString(),
      } : {
        name: jsonMod.name,
        quantity: (jsonMod.quantity || '1').toString(),
        basePriceMoney: {
          amount: (jsonMod.price || '0').toString(),
          currency: currency,
        },
      };
    } catch (e) {
      console.error("Error parsing modification:", mod, e);
      return null; // Return null or some default value in case of error
    }
  })
  .filter(mod => mod && (mod.name || mod.catalogObjectId)); // Ensure filtered items have either a name or a catalogObjectId



      const itemBasePrice = item.price;
      const totalModifiersPrice = item.modifications.reduce((acc, mod) => {
        const jsonMod = JSON.parse(mod);
        return acc + (jsonMod.price * jsonMod.quantity);
      }, 0);
      const finalPrice = itemBasePrice + totalModifiersPrice - item.itemDiscount;

    // Return line item object
    return {
      //Test Refresh: BCEVYZEZO7UE5YQCOQHVT3S7
      //Test Small PineBowl: CWWLFMBOBTWCRRBPDLWCFYAQ
      //Test Full Day: INYCAWPKX7HQXQH7RIUQ2X5I
      catalogObjectId:
        item.name === "Refresh"
          ? "BCEVYZEZO7UE5YQCOQHVT3S7"
          : item.name === "Pineapple Bowl"
          ? "CWWLFMBOBTWCRRBPDLWCFYAQ"
          : item.name === "Full-Day Cleanse"
          ? "INYCAWPKX7HQXQH7RIUQ2X5I"
          : "CWWLFMBOBTWCRRBPDLWCFYAQ",
      quantity: item.isScheduled
        ? (item.itemQuantity * item.scheduledQuantity).toString()
        : item.itemQuantity.toString(),
      itemType: "ITEM",
      basePriceMoney: {
        amount: item.price.toString(),
        currency: currency,
      },
      modifiers: modifiers,
      appliedDiscounts:
        item.itemDiscount > 0 ? [{ discountUid: discountUID }] : [],
    };
  });

  try {
    const orderResponse = await client.ordersApi.createOrder({
      order: {
        locationId: "LPRZ3G3PWZBKF",
        source: {
          name: orderMap.orderDetails.orderSource,
        },
        customerId: orderMap.userDetails.squareCustomerId || null,
        lineItems: lineItems,
        discounts: discounts,
        taxes: [
          {
            name: "Sales Tax",
            percentage:
              totalAmount !== 0
                ? (orderMap.locationDetails.locationTaxRate * 100).toString()
                : "0",
            scope: "ORDER",
          },
        ],
      },
      idempotencyKey: uuidv4(),
    });

    const orderResponseJson = JSON.parse(orderResponse.body);
    orderMap.orderDetails.orderNumber = orderResponseJson.order.id;

    if (totalAmount === 0 || totalAmount === 0.0) {
      await recordZeroChargeOrder(orderMap);
    }
  } catch (error) {
    console.log(error);
    throw error.body.errors[0].detail;
  }
};

module.exports = createSquareOrder;
