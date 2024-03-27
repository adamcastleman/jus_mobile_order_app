const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
const crypto = require('crypto');
const functions = require('firebase-functions');

const projectId = 'jusmobileorderapp';
const secretNames = { key: 'EncryptKey', iv: 'EncryptIV' };

async function accessSecretVersion(secretName) {
  const client = new SecretManagerServiceClient();
  const name = `projects/${projectId}/secrets/${secretName}/versions/latest`;
  const [version] = await client.accessSecretVersion({ name });
  return version.payload.data.toString('utf8'); // Assuming the secret is stored as a string
}

function convertSecretToBuffer(secret) {
  if (Buffer.isBuffer(secret)) {
    return secret;
  } else if (typeof secret === 'string') {
    return Buffer.from(secret.replace(/\s+/g, ''), 'hex');
  }
  throw new Error('Secret format is invalid');
}

exports.encryptText = functions.https.onCall(async (data, context) => {
  const { plaintext } = data;

  const key = await accessSecretVersion(secretNames.key);

  // Generate a random IV
  const ivBuffer = crypto.randomBytes(16);

  // Convert key to buffer
  const keyBuffer = convertSecretToBuffer(key);

  // Check key length
  if (keyBuffer.length !== 32) {
    throw new Error('Invalid key length. The key length must be 32 bytes (256 bits).');
  }

  const cipher = crypto.createCipheriv('aes-256-cbc', keyBuffer, ivBuffer);
  let encrypted = cipher.update(plaintext, 'utf8', 'base64');
  encrypted += cipher.final('base64');

  // Prepend IV to the encrypted message
  const ivString = ivBuffer.toString('base64');
  const encryptedWithIV = ivString + ':' + encrypted;

  return encryptedWithIV;
});
