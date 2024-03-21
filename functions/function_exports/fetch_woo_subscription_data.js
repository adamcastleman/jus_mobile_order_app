const functions = require("firebase-functions");
const admin = require("firebase-admin");
const WooCommerceRestApi = require("@woocommerce/woocommerce-rest-api").default;
const { getSecret } = require("../secrets");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.fetchWooSubscriptionData = functions.https.onCall(
  async (data, context) => {
    const email = data.email;
    let membershipMap = {
      membershipId: null,
      status: null,
      billingPeriod: null,
      nextPaymentDate: null,
    };

    if (!email) {
      throw new functions.https.HttpsError(
        "invalid-email",
        "This email address is not valid."
      );
    }

    try {
      const consumerKey = await getSecret("woo-consumer-key");
      const consumerSecret = await getSecret("woo-consumer-secret");
      const wooCommerce = new WooCommerceRestApi({
        url: 'https://www.jusreno.com',
        consumerKey: consumerKey,
        consumerSecret: consumerSecret,
        version: 'wc/v3',
        queryStringAuth: true
      });

      const membershipResponse = await wooCommerce.get('memberships/members', { customer: email, status: 'active' });

      if (membershipResponse.data.length === 0) {
        console.log('No active memberships found for:', email);
        return membershipMap; // Return early with the default membershipMap values
      }

      let activeMembership = membershipResponse.data[0];

      if (activeMembership) {
        const customerId = activeMembership.customer_id;
        const subscriptionResponse = await wooCommerce.get('subscriptions', { customer: customerId, status: 'active' });

        if (subscriptionResponse.data.length > 0) {
          let activeSubscription = subscriptionResponse.data[0];

          membershipMap.membershipId = activeMembership.id;
          membershipMap.status = activeMembership.status;
          membershipMap.billingPeriod = activeSubscription.billing_period;
          membershipMap.nextPaymentDate = activeSubscription.next_payment_date_gmt;
        }
      }

      return membershipMap;
    } catch (error) {
      console.error("Error fetching subscription data:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Error fetching subscription data."
      );
    }
  }
);
