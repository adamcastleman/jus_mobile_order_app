const axios = require("axios");
const { getSecret } = require("../secrets");

const cancelWooMembership = async (membershipId) => {

  try {
    const consumerKey = await getSecret("woo-consumer-key");
    const consumerSecret = await getSecret("woo-consumer-secret");


    const membershipUrl = `https://www.jusreno.com/wp-json/wc/v3/memberships/members/${membershipId}`;

    // Data for membership cancellation (if needed in request body)
    const cancellationData = { status: 'cancelled' };

    const membershipResponse = await axios.put(membershipUrl, cancellationData, {
      headers: { 'Content-Type': 'application/json' },
      params: {
        'consumer_key': consumerKey,
        'consumer_secret': consumerSecret
      }
    });

    // Check response from WooCommerce API for successful cancellation
    if (membershipResponse.status === 200) {
      return 200;
    } else {
      return 400;
    }
  } catch (error) {
    console.error('Error cancelling membership:', error);
    throw new functions.https.HttpsError('internal', 'Error cancelling membership.');
  }
};

module.exports = { cancelWooMembership };
