const axios = require("axios");
const { getSecret } = require("../secrets");

const sendScheduledItems = async (scheduledItems) => {
  const functionUrl = await getSecret("scheduled-items-to-leo");

  console.log(`FunctionUrl: ${functionUrl}`); // Correct usage for logging `functionUrl`
  console.log(`scheduledItems: ${JSON.stringify(scheduledItems)}`); // Use template literals and JSON.stringify for objects

  await axios.post(functionUrl, scheduledItems);
};

module.exports = sendScheduledItems;
