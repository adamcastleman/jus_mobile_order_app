const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
const crypto = require('crypto');
const functions = require('firebase-functions');

const projectId = 'jusmobileorderapp';
const secretNames = { key: 'EncryptKey', iv: 'EncryptIV' };

async function accessSecretVersion(secretName) {
  const client = new SecretManagerServiceClient();
  const name = `projects/${projectId}/secrets/${secretName}/versions/latest`;
  const [version] = await client.accessSecretVersion({ name });
  return version.payload.data.toString('utf8');
}

function convertSecretToBuffer(secret) {
  if (Buffer.isBuffer(secret)) {
    return secret;
  } else if (typeof secret === 'string') {
    return Buffer.from(secret.replace(/\s+/g, ''), 'hex');
  }
  throw new Error('Secret format is invalid');
}

exports.decryptText = functions.https.onCall(async (data, context) => {
  const { encryptedText } = data;

  if (!encryptedText || typeof encryptedText !== 'string') {
    throw new Error('Encrypted text is missing or not a string.');
  }

  const key = await accessSecretVersion(secretNames.key);
  const keyBuffer = convertSecretToBuffer(key);

  if (keyBuffer.length !== 32) {
    throw new Error('Invalid key length.');
  }

  const parts = encryptedText.split(':');
  if (parts.length !== 2) {
    throw new Error('Encrypted text format is invalid.');
  }

  const [ivString, encryptedMessage] = parts;
  const ivBufferFromMessage = Buffer.from(ivString, 'base64');
  const encryptedDataBuffer = Buffer.from(encryptedMessage, 'base64');

  const decipher = crypto.createDecipheriv('aes-256-cbc', keyBuffer, ivBufferFromMessage);
  let decrypted = '';
  try {
    decrypted = decipher.update(encryptedDataBuffer, 'base64', 'utf8');
    decrypted += decipher.final('utf8');
  } catch (error) {
    console.error('Decryption error:', error);
    throw new Error('Decryption failed.');
  }

  return decrypted;
});
