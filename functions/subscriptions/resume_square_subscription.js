const { Client, Environment } = require("square");
const { createSquareClient } = require("../payments/square_client");

// Helper function to get the current date in YYYY-MM-DD format
function getCurrentDateString() {
    const today = new Date();
    const year = today.getFullYear();
    const month = (today.getMonth() + 1).toString().padStart(2, '0'); // Ensure month is 2 digits
    const day = today.getDate().toString().padStart(2, '0'); // Ensure day is 2 digits

    return `${year}-${month}-${day}`;
}

const resumeSquareSubscription = async ({
  subscriptionId
}) => {
  const client = await createSquareClient();

  // Get the current date formatted as YYYY-MM-DD
  const currentDate = getCurrentDateString();

  try {
    const response = await client.subscriptionsApi.resumeSubscription(subscriptionId,
    {
      resumeEffectiveDate: currentDate,
      resumeChangeTiming: 'IMMEDIATE'
    });

    console.log(response.result);
  } catch(error) {
    console.log(error);
    throw error;
  }

};

module.exports = { resumeSquareSubscription };