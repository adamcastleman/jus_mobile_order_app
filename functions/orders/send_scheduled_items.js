const axios = require("axios");
const { getSecret } = require("../secrets");

const sendScheduledItems = async (scheduledItems) => {

const functionUrl = await getSecret("scheduled-items-to-leo");

  await axios.post(functionUrl, scheduledItems);
};

module.exports = sendScheduledItems;
