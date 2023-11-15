const moment = require("moment-timezone");
require("dotenv").config();

module.exports = (orderMap) => {
  const {
    userDetails,
    locationDetails,
    paymentDetails,
    orderDetails,
    totals,
    pointsDetails,
  } = orderMap;
  const { items } = orderDetails;
  const scheduledItems = items.filter((item) => item.isScheduled);
  const nonScheduledItems = items.filter((item) => !item.isScheduled);
  const showScheduledItems = scheduledItems.length > 0;
  const showNonScheduledItems = nonScheduledItems.length > 0;
  const showBothLists = showScheduledItems && showNonScheduledItems;

  const formatDate = (timestamp, timezone) => {
    const date = moment(timestamp.toDate()).tz(timezone);
    return date.format("MM/DD/YYYY");
  };

  const formatTime = (timestamp, timezone) => {
    const date = moment(timestamp.toDate());
    const formattedDate = date.tz(timezone).format("MM/DD/YYYY");
    const formattedTime = date.tz(timezone).format("h:mm a");
    return `${formattedDate} at ${formattedTime}`;
  };

  const renderScheduledItems = () => {
    return scheduledItems
      .map(
        (item) => `

    <div style="display: flex; align-items: center; margin-bottom: 10px;">
      <div style="width: 70px; height: 70px; display: flex; justify-content: center; align-items: center; margin-right: 10px; text-align: center;">
        <img src="${item.image}" alt="${item.name}" style="max-width: ${
          item.imageWidth
        }px; max-height: 100%; ${
          item.imageWidth === 70 ? "" : "object-fit: contain"
        }; width: 70px;" />
      </div>
      <div style="flex: 1; font-size: 0.75rem; line-height: 1; max-width: 200px; text-align: left;">
        <p class="item-name" style="margin: 0 0 5px 0;">${item.name}</p>
        <p style="margin: 0; padding-top: 2px;">Quantity: <span style="margin-left: 5px;">${
          item.itemQuantity
        }</span></p>
        ${
          item.scheduledDescriptor
            ? `<p style="margin: 0; padding-top: 2px;">${item.scheduledDescriptor}: <span style="margin-left: 2px;">${item.scheduledQuantity}</span></p>`
            : ""
        }
      </div>
      <div style="margin-left: auto; text-align: right;">
        $${(
          (item.price * item.itemQuantity * item.scheduledQuantity) /
          100
        ).toFixed(2)}
      </div>
    </div>

  `,
      )
      .join("");
  };

  const renderUnscheduledItems = (unscheduledItems) => {
    return unscheduledItems
      .map(
        (item, index) => `
    <div style="display: flex; align-items: center; margin-bottom: 10px;">
      <div style="width: 70px; height: 70px; display: flex; justify-content: center; align-items: center; margin-right: 10px; text-align: center;">
        <img src="${item.image}" alt="${item.name}" style="max-width: ${
          item.imageWidth
        }px; max-height: 100%; ${
          item.imageWidth === 70 ? "" : "object-fit: contain"
        }; margin: 0 auto;" />
      </div>
      <div style="flex: 1; font-size: 0.75rem; line-height: 1; max-width: 200px; text-align: left;">
        <p class="item-name" style="margin: 0 0 5px 0;">${item.name}</p>
        ${
          item.itemQuantity > 1
            ? `<p style="margin: 2px 0 0 0;">Quantity: ${item.itemQuantity}</p>`
            : ""
        }
        ${item.size ? `<p style="margin: 2px 0 0 0;">${item.size}</p>` : ""}
        ${
          item.modifications.length > 0
            ? `<p class="item-modifications" style="margin: 2px 0 0 0;">${item.modifications.join(
                "<br>",
              )}</p>`
            : ""
        }
        ${
          item.allergies.length > 0
            ? `<p style="margin: 2px 0 0 0;"><strong>Allergies: </strong>${item.allergies.join(
                "<br>",
              )}</p>`
            : ""
        }
      </div>
      <div style="margin-left: auto;">
        $${((item.price * item.itemQuantity) / 100).toFixed(2)}
      </div>
    </div>
    ${
      index !== unscheduledItems.length - 1
        ? '<div style="border-bottom: 1px solid #ddd; margin-bottom: 10px;"></div>'
        : ""
    }
    <style>
      @media screen and (min-width: 600px) {
        .item-image-container {
          width: 120px;
        }
      }
    </style>
  `,
      )
      .join("");
  };

  const emailBody = `
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Order Confirmation</title>
  <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500&display=swap" rel="stylesheet">
 <style>
   body { font-family: 'Quicksand', sans-serif; }
   .center { text-align: center; }
   .divider { border-top: 1px solid #ddd; margin: 20px 0; }
   @media (min-width: 600px) {
      .email-container {
        margin: 0 auto;
        max-width: 600px;
      }
    }
   .item-image-container {
     width: 70px;
     height: 70px;
     display: flex;
     justify-content: center;
     align-items: center;
     overflow: hidden;
     margin-right: 10px;
   }
   .item-image {
     max-width: 100%;
     max-height: 100%;
   }
   .item-details {
     max-width: 300px; /* Add max-width property */
     width: 60%;
     display: flex;
     flex-direction: column;
   }
   .item-name {
     font-size: 1rem;
     font-weight: bold;
     margin: 0;
   }
   .item-modifications, .item-allergies {
     margin: 5px 0 0 0;
     font-size: 0.75rem;
   }
   .item-allergies:before {
     content: "Allergies: ";
     font-weight: bold;
   }
   .totals-container {
     text-align: right;
   }

 </style>
</head>
<body>
<div class="email-container">
  <div class="center">
    <img src="${process.env.JUS_LOGO}" alt="jusLogo" width="100" />
    <h2>Your order is confirmed.</h2>
    <p>${formatTime(
      paymentDetails.createdAt,
      locationDetails.locationTimezone,
    )}</p>
    <p>We've received your order #${
      orderDetails.orderNumber
    }. Thank you for shopping with us today.</p>
  </div>
  <div class="divider"></div>
  <h4>Location: ${locationDetails.locationName}</h4>`;

  const nonScheduledSection = showNonScheduledItems
    ? `
  <h4 class="item-text">Pickup Time: ${formatTime(
    orderDetails.pickupTime,
    locationDetails.locationTimezone,
  )}</h4>
  ${renderUnscheduledItems(nonScheduledItems)}
  ${showBothLists ? '<div class="divider"></div>' : ""}
`
    : "";

  const scheduledSection = showScheduledItems
    ? `
  <h4 class="item-text">Scheduled: ${formatDate(
    orderDetails.pickupDate,
    locationDetails.locationTimezone,
  )}</h4>
  ${renderScheduledItems(scheduledItems)}
  ${showBothLists ? '<div class="divider"></div>' : ""}
`
    : "";

  const footer = `
<div class="email-container">
 <div class="divider"></div>
  <div class="center">
    <h4>We're here to help</h4>
    <p>Email us at <a href="mailto:support@jusreno.com">support@jusreno.com</a> for any questions or concerns regarding this order. We will respond within 24 hours.</p>
  </div>
  <div class="divider"></div>
   <p style="text-align: center; font-size: 12px;">
     You are receiving this email because you have made a purchase from jüs. You can manage notifications for marketing emails in the jüs app or at <a href="https://www.jusreno.com" style="color: blue;">www.jusreno.com</a>, but you will always receive emails regarding transactions.
   </p>
  </div>
 </div>`;

  const totalAmounts = `
<div style="text-align: right;">
<div class="divider"></div>
  ${
    totals.discountAmount > 0
      ? `<p>Original: $${(totals.originalSubtotalAmount / 100).toFixed(2)}</p>`
      : ""
  }
  ${
    totals.discountAmount > 0
      ? `<p>Discounts: -$${(totals.discountAmount / 100).toFixed(2)}</p>`
      : ""
  }
  <p>Subtotal: $${(totals.discountedSubtotalAmount / 100).toFixed(2)}</p>
  <p>Taxes: $${(totals.taxAmount / 100).toFixed(2)}</p>
  ${
    totals.tipAmount > 0
      ? `<p>Tip: $${(totals.tipAmount / 100).toFixed(2)}</p>`
      : ""
  }
  <p style="font-weight: bold;">Total: $${(
    (totals.totalAmount + totals.tipAmount) /
    100
  ).toFixed(2)}</p>
</div>
</div>

</body>
</html>
`;

  return (
    emailBody + nonScheduledSection + scheduledSection + totalAmounts + footer
  );
};
