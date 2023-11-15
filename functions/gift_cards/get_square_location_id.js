const { Client, Environment } = require("square");
const { createSquareClient } = require("../payments/square_client");

const getSquareLocationID = async () => {
  const client = await createSquareClient();
  try {
    const {
      result: { locations },
    } = await client.locationsApi.listLocations();
    const locationId = locations[0].id;
    return locationId;
  } catch (error) {
    console.error("Error:", error);
    return null;
  }
};

module.exports = getSquareLocationID;
