const { SecretManagerServiceClient } = require("@google-cloud/secret-manager");

const getSecret = async (secretName) => {
  const secretManagerServiceClient = new SecretManagerServiceClient();
  const name = `projects/${process.env.PROJECT_ID}/secrets/${secretName}/versions/latest`;
  const [version] = await secretManagerServiceClient.accessSecretVersion({
    name,
  });
  const payload = version.payload.data.toString();
  return payload;
};

module.exports = { getSecret };