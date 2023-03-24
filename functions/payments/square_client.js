const { SecretManagerServiceClient } = require("@google-cloud/secret-manager");
const { Client, Environment } = require("square");
const { getSecret } = require("../secrets");

const createSquareClient = async () => {
  const accessToken = await getSecret("square-access-token-sandbox");
  const client = new Client({
    accessToken: accessToken,
    environment: Environment.Sandbox,
  });
  return client;
};

module.exports = {
  createSquareClient,
};
