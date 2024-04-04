const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const fetchSquareLoyaltyPoints = async (squareCustomerId) => {
  const client = await createSquareClient();

  try {
    const response = await client.loyaltyApi.searchLoyaltyAccounts({
      query: {
        customerIds: [squareCustomerId],
      },
    });

    console.log(response.result);

    // Check if loyaltyAccounts exists and has elements
    if (!response.result.loyaltyAccounts || response.result.loyaltyAccounts.length === 0) {
      return 0; // No loyalty account exists, so there are no points
    } else {
      const balance = response.result.loyaltyAccounts[0].balance;
      return balance; // Return the balance of the user's account
    }
  } catch (error) {
    console.error(error);
    return null; // Return null in case of an error
  }
};


module.exports = { fetchSquareLoyaltyPoints };
