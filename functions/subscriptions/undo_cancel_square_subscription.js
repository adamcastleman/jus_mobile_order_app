const { createSquareClient } = require("../payments/square_client");

// Function to undo the cancellation action for a Square subscription
const undoCancelSquareSubscription = async (subscriptionId) => {
  const client = await createSquareClient();

  try {

    // Retrieve the subscription and include actions
    const response = await client.subscriptionsApi.retrieveSubscription(
      subscriptionId,
      'actions'
    );

    const actions = response.result.subscription?.actions || [];
    const cancelAction = actions.find(action => action.type === 'CANCEL');

    if (!cancelAction) {
      console.log('No cancellation action found to undo.');
      return 404; // Not Found
    }

    // If a cancellation action is found, delete it
    const deleteResponse = await client.subscriptionsApi.deleteSubscriptionAction(subscriptionId, cancelAction.id);
    console.log('Cancellation action deleted successfully:', deleteResponse.result);
    return 200; // OK
  } catch (error) {
    console.error('Failed to undo cancellation:', error);
    throw error;
  }
};

module.exports = { undoCancelSquareSubscription };
