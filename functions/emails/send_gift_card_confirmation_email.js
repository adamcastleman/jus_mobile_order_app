const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { getSecret } = require("../secrets");
const generateGiftCardEmail = require("../emails/generate_gift_card_email");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const sendGiftCardConfirmationEmail = async (giftCardMap) => {
  const email = await getSecret("support-email");
  const password = await getSecret("support-email-password");

  const emailBody = generateGiftCardEmail(giftCardMap);

  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: email,
      pass: password,
    },
  });

  let info = await transporter.sendMail({
    from: email,
    to: giftCardMap.userDetails.email,
    subject: `New Wallet Event - Confirmation# ${giftCardMap.orderDetails.orderNumber}`,
    html: emailBody,
  });

  console.log("Message sent: %s", info.messageId);
};

module.exports = sendGiftCardConfirmationEmail;
