const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { getSecret } = require("../secrets");
const generateCleanseInstructionsEmail = require("../emails/generate_cleanse_instructions_email");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const sendCleanseInstructionsEmail = async (orderMap) => {
  const email = await getSecret("support-email");
  const password = await getSecret("support-email-password");

  const emailBody = generateCleanseInstructionsEmail();

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
    subject: `${orderMap.userDetails.firstName}, let\'s prepare for your cleanse`,
    html: emailBody,
  });

  console.log("Message sent: %s", info.messageId);
};

module.exports = sendCleanseInstructionsEmail;


