const { Client, Environment } = require("square");
const { v4: uuidv4 } = require("uuid");
const { createSquareClient } = require("../payments/square_client");

const createSquareCustomer = async (
  firstName,
  lastName,
  email,
  phoneNumber,
) => {
  const client = await createSquareClient();

  try {
    const response = await client.customersApi.searchCustomers({
      query: {
        filter: {
          phoneNumber: {
            exact: `+1${phoneNumber}`,
          },
        },
      },
    });

    if (response.result.customers && response.result.customers.length !== 0) {
      return response.result.customers[0].id; // Return the ID of the existing customer
    } else {
      const {
        result: { customer },
      } = await client.customersApi.createCustomer({
        idempotencyKey: uuidv4(),
        givenName: firstName,
        familyName: lastName,
        emailAddress: email,
        phoneNumber: `+1${phoneNumber}`,
      });
      return customer.id; // Return the ID of the new customer
    }
  } catch (error) {
    console.error(error);
    return null; // Return null in case of an error
  }
};

module.exports = { createSquareCustomer };
