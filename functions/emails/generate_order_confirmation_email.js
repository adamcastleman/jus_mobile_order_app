const moment = require("moment-timezone");
require("dotenv").config();

module.exports = (orderMap) => {
  const {
    userDetails, // Not used currently
    locationDetails,
    paymentDetails,
    orderDetails,
    totals,
    pointsDetails, // Not used currently
  } = orderMap;

  const { items } = orderDetails;
  const scheduledItems = items.filter((item) => item.isScheduled);
  const nonScheduledItems = items.filter((item) => !item.isScheduled);
  const showScheduledItems = scheduledItems.length > 0;
  const showNonScheduledItems = nonScheduledItems.length > 0;
  const showBothLists = showScheduledItems && showNonScheduledItems;

  const formatDate = (timestamp, timezone) => moment(timestamp.toDate()).tz(timezone).format("MM/DD/YYYY");
  const formatTime = (timestamp, timezone) => {
    const date = moment(timestamp.toDate()).tz(timezone);
    return `${date.format("MM/DD/YYYY")} at ${date.format("h:mm a")}`;
  };

  const renderScheduledItems = () => {
    return scheduledItems.map((item) => `
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 10px;">
        <tr>
        <td style="width: 90px; text-align: center; vertical-align: middle; padding-right: 15px;">
            <img src="${item.image}" alt="${item.name}" style="width: 90px; height: 90px; max-width: 100%; height: auto; object-fit: contain;">
          </td>
          <td style="font-size: 0.75rem; line-height: 1.2; vertical-align: middle;">
            <p style="margin: 0 0 5px 0; font-weight: bold;">${item.name}</p>
            <p style="margin: 0;">Quantity: <span>${item.itemQuantity}</span></p>
            ${item.scheduledDescriptor ? `<p style="margin: 0;">${item.scheduledDescriptor}: <span>${item.scheduledQuantity}</span></p>` : ""}
          </td>
          <td style="text-align: right; vertical-align: middle;">
            $${((item.price * item.itemQuantity * item.scheduledQuantity) / 100).toFixed(2)}
          </td>
        </tr>
      </table>
    `).join("");
  };

  const renderUnscheduledItems = (unscheduledItems) => {
    return unscheduledItems.map((item, index) => {
      let totalModifierPrice = 0;
      const formattedModifications = item.modifications.map((modString) => {
        try {
          const mod = JSON.parse(modString);
          const modPrice = parseInt(mod.price) * parseInt(mod.quantity);
          totalModifierPrice += isNaN(modPrice) ? 0 : modPrice;
          return modPrice > 0 ? `${mod.name} +\$${(modPrice / 100).toFixed(2)}` : mod.name;
        } catch (e) {
          console.error("Error parsing modification:", e);
          return "";
        }
      }).join("<br>");

      const itemPrice = parseFloat(item.price);
      const itemQuantity = parseInt(item.itemQuantity);
      const totalPrice = isNaN(itemPrice) || isNaN(itemQuantity) ? "Error" : ((itemPrice * itemQuantity + totalModifierPrice) / 100).toFixed(2);

      return `
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 10px;">
          <tr>
        <td style="width: 60px; text-align: center; vertical-align: middle; padding-right: 15px;">
              <img src="${item.image}" alt="${item.name}" style="width: 60px; height: 70px; max-width: 100%; height: auto; object-fit: contain;">
            </td>
            <td style="font-size: 0.75rem; line-height: 1.2; vertical-align: middle;">
              <p style="margin: 0 0 5px 0; font-weight: bold;">${item.name}</p>
              ${item.itemQuantity > 1 ? `<p style="margin: 2px 0 0 0;">Quantity: ${item.itemQuantity}</p>` : ""}
              ${item.size !== 'Non-Member' && item.size !== 'Member' ? `<p style="margin: 2px 0 0 0;">${item.size}</p>` : ""}
              ${formattedModifications ? `<p style="margin: 2px 0 0 0;">${formattedModifications}</p>` : ""}
              ${item.allergies.length > 0 ? `<p style="margin: 2px 0 0 0;"><strong>Allergies: </strong>${item.allergies.join("<br>")}</p>` : ""}
            </td>
            <td style="text-align: right; vertical-align: middle;">
              \$${totalPrice}
            </td>
          </tr>
          ${index !== unscheduledItems.length - 1 ? '<tr><td colspan="3" style="border-bottom: 1px solid #ddd; margin-bottom: 10px;"></td></tr>' : ""}
        </table>
      `;
    }).join("");
  };

  // Here's where the final assembly happens. Make sure all parts are defined before this point.
  const footer = `
    <table style="width: 100%; border-collapse: collapse; text-align: center;">
      <tr>
        <td style="padding: 20px;">
          <h4>We're here to help</h4>
          <p>Email us at <a href="mailto:support@jusreno.com">support@jusreno.com</a> for any questions or concerns regarding this order. We will respond within 24 hours.</p>
        </td>
      </tr>
      <tr>
        <td style="font-size: 12px;">
          You are receiving this email because you have made a purchase from jüs. You will always receive emails regarding transactions.
        </td>
      </tr>
    </table>
  `;

  const totalAmounts = `
    <table style="width: 100%; border-collapse: collapse; text-align:right;">
      <tr>
        ${totals.discountAmount > 0 ? `<td>Original: $${(totals.originalSubtotalAmount / 100).toFixed(2)}</td>` : ""}
      </tr>
      <tr>
        ${totals.discountAmount > 0 ? `<td>Discounts: -$${(totals.discountAmount / 100).toFixed(2)}</td>` : ""}
      </tr>
      <tr><td>Subtotal: $${(totals.discountedSubtotalAmount / 100).toFixed(2)}</td></tr>
      <tr><td>Taxes: $${(totals.taxAmount / 100).toFixed(2)}</td></tr>
      ${totals.tipAmount > 0 ? `<tr><td>Tip: $${(totals.tipAmount / 100).toFixed(2)}</td></tr>` : ""}
      <tr><td style="font-weight: bold;">Total: $${((totals.totalAmount + totals.tipAmount) / 100).toFixed(2)}</td></tr>
    </table>
  `;

  const renderScheduledItemsWithHeader = () => {
    if (!showScheduledItems) return '';

    const scheduledItemsList = renderScheduledItems();

    return `
      <h4>Scheduled for: ${formatDate(orderDetails.pickupDate, locationDetails.locationTimezone)}</h4>
      ${scheduledItemsList}
      ${showBothLists ? '<div class="divider"></div>' : ""}
    `;
  };
 const renderUnscheduledItemsWithHeader = () => {
   if (!showNonScheduledItems) return '';

   const unscheduledItemsList = renderUnscheduledItems(nonScheduledItems);

   return `
     <h4>Pickup Time: ${formatTime(orderDetails.pickupTime, locationDetails.locationTimezone)}</h4>
     ${unscheduledItemsList}
   `;
 };

const emailBody = `
<html lang="en">
<head>
  <!-- ... Other head elements ... -->
</head>
<body>
<div class="email-container">
  <!-- ... Other email content ... -->

  <!-- Render the scheduled items with header -->
  ${renderScheduledItemsWithHeader()}

  <!-- Render the unscheduled items with header -->
  ${renderUnscheduledItemsWithHeader()}

  <!-- Divider before the Totals -->
  <div class="divider"></div>

  <!-- Totals and Footer -->
  ${totalAmounts}
  <div class="divider"></div>
  ${footer}
</div>
</body>
</html>
`;

return emailBody;


};
