const admin = require("firebase-admin");

const extractScheduledItems = (orderMap) => {
  const scheduledData = {
    firstName: orderMap.userDetails.firstName,
    lastName: orderMap.userDetails.lastName,
    phone: orderMap.userDetails.phone,
    locationID: parseInt(orderMap.locationDetails.locationId, 10),
    items: orderMap.orderDetails.items,
    orderSource: orderMap.orderDetails.orderSource,
    pickupDate: orderMap.orderDetails.pickupDateMillis,
    scheduleAllItems: orderMap.orderDetails.scheduleAllItems,
  };

  const {
    firstName,
    lastName,
    phone,
    locationID,
    items,
    orderSource,
    pickupDate,
    scheduleAllItems,
  } = scheduledData;

  const scheduledItems = items.filter((item) => item.isScheduled);

  const scheduledObjects = scheduledItems.map((item, index) => {
    const scheduledObject = {
      cleanseDayAmount: item.scheduledQuantity
        ? item.scheduledQuantity.toString()
        : "1",
      cleanseDayProduction: item.scheduledQuantity ? item.scheduledQuantity : 1,
      cleanseOrCustom: "Cleanse",
      cleanseQuantityAmount: item.itemQuantity
        ? item.itemQuantity.toString()
        : "1",
      cleanseQuantityProduction: item.itemQuantity ? item.itemQuantity : 1,
      cleanseType: item.name === "Full-Day Cleanse" ? "Full" : "Half",
      customerName: `${firstName} ${lastName}`,
      customerPhoneNumber: phone,
      delivered: false,
      didCustomerPay: "Yes",
      employeeName: orderSource,
      employeeUID: null,
      locationID: locationID,
      manualEmployeeName: null,
      notes:
        index === 0 && scheduleAllItems
          ? items
              .filter((item) => !item.isScheduled)
              .map(
                (item) =>
                  `+${item.itemQuantity} x ${
                    item.name
                  } - ${item.modifications.join(", ")} ${item.allergies.join(
                    ", ",
                  )}`,
              )
              .join(", ")
          : "",
      orderMethod: orderSource,
      pickedUp: "No",
      pickupDate: orderMap.orderDetails.pickupDateMillis,
      preferredLocationPickup: orderMap.locationDetails.locationName,
      totalDays: item.scheduledQuantity * item.itemQuantity,
      uid: null,
    };
    return scheduledObject;
  });

  return scheduledObjects;
};

module.exports = extractScheduledItems;
