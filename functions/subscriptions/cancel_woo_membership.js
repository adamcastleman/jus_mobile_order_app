const WooCommerceRestApi = require("@woocommerce/woocommerce-rest-api").default;
const { getSecret } = require("../secrets");

const cancelWooMembership = async (email) => {
  try {
    const consumerKey = await getSecret("woo-consumer-key");
    const consumerSecret = await getSecret("woo-consumer-secret");
    const wooCommerce = new WooCommerceRestApi({
      url: 'https://www.jusreno.com',
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
      version: 'wc/v3',
      queryStringAuth: true // Force Basic Authentication as query string true and using under HTTPS
    });

    const membershipResponse = await wooCommerce.get('memberships/members', { customer: email, status: 'active' });

    // Iterate over memberships and cancel each one
    for (const membership of membershipResponse.data) {
      const customerId = membership.customer_id;
      await wooCommerce.put(`memberships/members/${membership.id}`, { status: 'cancelled' });

      // Get active subscriptions for the customer and cancel them
      const subscriptionResponse = await wooCommerce.get('subscriptions', { customer: customerId, status: 'active' });
      for (const subscription of subscriptionResponse.data) {
        await wooCommerce.put(`subscriptions/${subscription.id}`, { status: 'cancelled' });
      }
    }

    // Check response from WooCommerce API for successful cancellation
    if (membershipResponse.status === 200) {
      return 200; // Return 200 if the operation was successful
    } else {
      return 400; // Return 400 if there was an issue with the cancellation
    }
  } catch (error) {
    console.error("Error cancelling membership:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Error cancelling membership.",
    );
  }
};

module.exports = { cancelWooMembership };
