const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const updateSquareCustomer = async (
  firstName,
  lastName,
  email,
  phone,
  squareCustomerId,
) => {
  const client = await createSquareClient();

  try {
    const response = await client.customersApi.updateCustomer(squareCustomerId,
     {
       givenName: firstName,
       familyName: lastName,
       emailAddress: email,
       phoneNumber: phone
     });

  } catch (error) {
    console.error(error);
    return null; // Return null in case of an error
  }
};

module.exports = { updateSquareCustomer };
