const functions = require("firebase-functions");
const { getSecret } = require("../secrets");

exports.secrets = functions.https.onCall(async (data, context) => {
  var secret = await getSecret(data.secretKey);
  console.log(secret);
  return secret;
});
