const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { customAlphabet } = require("nanoid");
const { createSquareClient } = require("../payments/square_client");
const recordZeroChargeOrder = require("../payments/record_zero_charge_order");

const idMapping = {
    // Mapping each production ID to its corresponding sandbox ID, including member options
    '7FNCX5HFHQZFFEEFXXBZ2GKF': 'Q4WIFUARW5YSUH67YMS6M66M', // Whey -> Whey
    'MLECSZ7HFNFP4KAQU4KW466N': 'TYG4VOCY7BISP2AIX34PD42D', // Whey (Members) -> Whey (Members)
    'MXD3CGC3D4KYAJU7KGLJ65PC': 'QAIZQ3XVB57E6QGRNJADFVAW', // Hemp -> Hemp
    'RVLHRWIJESOOFYEVSIFPM6FL': 'KJMWG2XV25DOERIW4MHJA7XL', // Hemp (Members) -> Hemp (Members)
    'Y5FC5YWKFSWLTQSIHB7DM7QW': '53K3TALGZM2FR4QRNMTGH5GO', // Chia -> Chia Seeds
    'V4B6WBLN64HM4AZLCAAGZMCC': 'BT3UCZMLMHSXON3HIFNOWHKH', // Chia (Members) -> Chia Seeds (Members)
    'CY63E4I7N7KBPNRLWCCEFZGH': 'TLUSGQ7G6IPHWX7TGDPR4SWF', // Almond Butter -> Almond Button
    'RI3XUO3NKOH7L66KDNWUKQHF': 'L2Y5TPQY7LFLM6YQSETDOL4A', // Almond Butter (Members) -> Almond Butter (Members)
    'R4L5JRZAOFCZ76BUW27YDWQF': 'YKLB2LVSSZI4NVYDQKTDFPDU', // PB -> Peanut Butter
    'KBJZFKTVLLF67PNFX7MGPUTX': 'CGP7XCW3LONULATXN3D5YUEE', // PB (Members) -> Peanut Butter (Members)
    'NZCMQY6RGCCDCM4ISH6XFZJQ': 'OO3ZAH4ACXAMBSXIVOXA6DZW', // Flax -> Flax Seeds
    'CYDQYLTLDPMBTM27IFONVFT6': 'T72LTPSUC7RGGOOTBIG52TLB', // Flax (Members) -> Flax Seeds (Members)
    '6JWHWF2TGDMJBPW2XI4A4ZUA': 'QS2XPUIJ6K33NDY4TGKPFTFN', // Guarana -> Guarana
    'MD7YNZR23RHPPOUCEWGOLLYI': 'Z5ZLWW3QEGDHDTVDYRZXWKAH'  // Guarana (Members) -> Guarana (Members)
};

function processModifications(modifications, currency) {
  return modifications.map(mod => {
    try {
      const jsonMod = JSON.parse(mod);

      return jsonMod.catalogObjectId ?
        {
          // If catalogObjectId is present, set it and do not include name or basePriceMoney
          catalogObjectId: jsonMod.catalogObjectId,
          quantity: (jsonMod.quantity || '1').toString(),
        } :
        {
          // If catalogObjectId is not present, include name and basePriceMoney
          name: jsonMod.name,
          basePriceMoney: {
            amount: (jsonMod.price || '0').toString(),
            currency: currency,
          },
          quantity: (jsonMod.quantity || '1').toString(),
        };
    } catch (e) {
      console.error("Error parsing modification:", mod, e);
      return null;  // Return null in case of parsing errors
    }
  }).filter(mod => mod !== null);  // Filter out any null entries resulting from parsing errors
}


const createSquareOrder = async (orderMap) => {
  const client = await createSquareClient();
  const currency = orderMap.paymentDetails.currency;
  const totalAmount = orderMap.totals.totalAmount;
  const alphabet = "0123456789ABCDEF";
  const nanoid = customAlphabet(alphabet, 10);

  let discounts = []; // Array to hold the discounts

  const lineItems = orderMap.orderDetails.items.map((item, index) => {
    const discountUID = `discount-${index}-${nanoid()}`;
    if (item.itemDiscount > 0) {
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

   const modifiers = processModifications(item.modifications || [], currency);


    return {
  //TODO replace catelogObjectId with production id
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
      //catalogObjectId: item.catalogObjectId,
      quantity: item.itemQuantity.toString(),
      itemType: "ITEM",
      basePriceMoney: {
        amount: item.price.toString(),
        currency: currency,
      },
      modifiers: modifiers,
      appliedDiscounts: item.itemDiscount > 0 ? [{ discountUid }] : [],
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
        taxes: [{
          name: "Sales Tax",
          percentage: totalAmount !== 0 ? (orderMap.locationDetails.locationTaxRate * 100).toString() : "0",
          scope: "ORDER",
        }],
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

