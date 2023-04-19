const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { getSecret } = require("../secrets");
const generateOrderConfirmationEmail = require("../emails/generate_order_confirmation_email");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const sendOrderConfirmationEmail = async (orderMap) => {
  const email = await getSecret("support-email");
  const password = await getSecret("support-email-password");

  const emailBody = generateOrderConfirmationEmail(orderMap);

  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: email,
      pass: password,
    },
  });

  let info = await transporter.sendMail({
    from: email,
    to: orderMap.userDetails.email,
    subject: `Order Confirmation - Order #${orderMap.orderDetails.orderNumber}`,
    html: emailBody,
  });

  console.log("Message sent: %s", info.messageId);
};

module.exports = sendOrderConfirmationEmail;
