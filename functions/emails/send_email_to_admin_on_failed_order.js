const nodemailer = require("nodemailer");
const { getSecret } = require("../secrets");

const sendEmailToAdminOnFailedOrder = async (orderMap) => {
  console.log("Inside sendEmailToAdminOnFailedOrder function");
  const email = await getSecret("support-email");
  const password = await getSecret("support-email-password");

  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: email,
      pass: password,
    },
  });

  // send mail with defined transport object
  let info = await transporter.sendMail({
    from: email,
    to: "adam@jusreno.com",
    subject: "Failed Order Notification",
    text: `Order #${orderMap.orderDetails.orderNumber} has failed. It is possible the card was still charged. Please take appropriate action.`,
  });

  console.log("Message sent: %s", info.messageId);
};

module.exports = sendEmailToAdminOnFailedOrder;
