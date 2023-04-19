const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { getSecret } = require("../secrets");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const sendEmailToAdminOnAccountDeleteRequest = async (
  userInfoMap,
  imageURL
) => {
  console.log("Inside sendEmailToAdminOnAccountDeleteRequest function");
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
    to: email,
    subject: "Account Deletion Request",
    html: `
      <div>
        <p>User with UID ${userInfoMap.uid} has requested account deletion.</p>
        <p>User's address:</p>
<p>
  ${userInfoMap.addressLine1} ${userInfoMap.addressLine2}
  <br>
  <span style="white-space: nowrap">
    ${userInfoMap.city}, ${userInfoMap.state} ${userInfoMap.zipCode}
  </span>
</p>

        <p>Please take appropriate action.</p>
      </div>
      <div>
        <img src="${imageURL}" alt="Jus Reno logo" style="max-width: 100%; height: auto;">
      </div>
    `,
  });

  console.log("Message sent: %s", info.messageId);
};

exports.deleteAccountRequest = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must be logged in to perform this function."
    );
  }

  const userInfoMap = {
    uid: context.auth.uid,
    addressLine1: data.addressLine1,
    addressLine2: data.addressLine2,
    city: data.city,
    state: data.state,
    zipCode: data.zipCode,
  };

  // Get the signed URL of the Jus logo stored in Firebase Storage
  const [url] = await admin
    .storage()
    .bucket()
    .file("jusLogo.png")
    .getSignedUrl({ action: "read", expires: "03-09-2491" });
  const imageURL = url.toString();

  try {
    // Call the sendEmailToAdminOnAccountDeleteRequest function with the userInfoMap and imageURL
    await sendEmailToAdminOnAccountDeleteRequest(userInfoMap, imageURL);
    return { success: true };
  } catch (error) {
    console.error("Error sending email:", error);
    throw new functions.https.HttpsError(
      "internal",
      "An error occurred. Please email support@jusreno.com to complete this request."
    );
  }
});
