const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { getSecret } = require("../secrets");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.fetchWooSubscriptionData = functions.https.onCall(
  async (data, context) => {
    const email = data.email;

    if (!email) {
      throw new functions.https.HttpsError(
        "invalid-email",
        "This email address is not valid."
      );
    }

    try {
      const consumerKey = await getSecret("woo-consumer-key");
      const consumerSecret = await getSecret("woo-consumer-secret");
      const encodedEmail = encodeURIComponent(email);

      const customerUrl = `https://www.jusreno.com/wp-json/wc/v3/customers?role=all&email=${encodedEmail}&consumer_key=${consumerKey}&consumer_secret=${consumerSecret}`;
      const customerResponse = await axios.get(customerUrl);

      if (!customerResponse.data || customerResponse.data.length === 0) {
        return {
          membershipId: null,
          status: null,
          billingPeriod: null,
          nextPaymentDate: null,
        };
      }

      const customerId = customerResponse.data[0].id;
      const membershipUrl = `https://www.jusreno.com/wp-json/wc/v3/memberships/members?customer=${customerId}&consumer_key=${consumerKey}&consumer_secret=${consumerSecret}`;
      const subscriptionUrl = `https://www.jusreno.com/wp-json/wc/v3/subscriptions?customer=${customerId}&consumer_key=${consumerKey}&consumer_secret=${consumerSecret}`;

      const membershipResponse = await axios.get(membershipUrl);
      const subscriptionResponse = await axios.get(subscriptionUrl);

      const result = {
        membershipId: null,
        status: null,
        billingPeriod: null,
        nextPaymentDate: null,
      };

      if (membershipResponse.data && membershipResponse.data.length > 0) {
        result.membershipId = membershipResponse.data[0].id;
        result.status = membershipResponse.data[0].status;
      }

      if (subscriptionResponse.data && subscriptionResponse.data.length > 0) {
        result.billingPeriod = subscriptionResponse.data[0].billing_period;
        result.nextPaymentDate =
          subscriptionResponse.data[0].next_payment_date_gmt;
      }

      return result;
    } catch (error) {
      console.error("Error fetching subscription data:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Error fetching subscription data."
      );
    }
  }
);
