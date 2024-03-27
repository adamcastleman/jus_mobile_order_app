const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { pauseSquareSubscription } = require("../subscriptions/pause_square_subscription");

if (admin.apps.length === 0) {
    admin.initializeApp();
}

const db = admin.firestore();

exports.handleSquareWebhooks = functions.https.onRequest(async (req, res) => {
    if (req.method !== 'POST') {
        res.status(405).send('Method Not Allowed');
        return;
    }

    const event = req.body;

     switch (event.type) {
           case 'payment.created':
               await handleFailedInitialPayment(event);
               break;
           case 'payment.updated':
               await handleFailedRecurringPayment(event);
               break;
           case 'subscription.updated':
               await handleSubscriptionUpdated(event);
               break;
           default:
               console.log('Unhandled event type:', event.type);
       }

    res.status(200).send('Event received');
});

async function handleFailedInitialPayment(event) {
    console.log('Handling failed initial payment event');
    const squareCustomerId = event.data.object.customer_id;

    // Check if squareCustomerId is undefined
    if (typeof squareCustomerId === 'undefined') {
        console.log('squareCustomerId is undefined');
        return;
    }

    const usersRef = db.collection('users');
    const userSnapshot = await usersRef.where('squareCustomerId', '==', squareCustomerId).get();
    if (userSnapshot.empty) {
        console.log('No matching user found for Square Customer ID:', squareCustomerId);
        return;
    }

    const userId = userSnapshot.docs[0].id;  // Changed from .uid to .id
    console.log('Failed initial payment for user:', userId);
    await db.collection('users').doc(userId).update({ subscriptionStatus: 'FAILED' });
}

async function handleFailedRecurringPayment(event) {
    const squareCustomerId = event.data.object.payment.customer_id;
    const locationId = event.data.object.payment.location_id;
    const isFailedPayment = event.data.object.payment.status === 'FAILED';

    if (locationId !== 'LPRZ3G3PWZBKF' || !isFailedPayment) {
        return;
    }

    const userSnapshot = await db.collection('users').where('squareCustomerId', '==', squareCustomerId).get();
    if (userSnapshot.empty) {
        console.log('No matching user found for Square Customer ID:', squareCustomerId);
        return;
    }

    const userId = userSnapshot.docs[0].uid;
    const subscriptionSnapshot = await db.collection('subscriptions').where('userId', '==', userId).get();
    if (subscriptionSnapshot.empty) {
        console.log('No subscription detected for this user:', squareCustomerId);
        return;
    }

    const subscriptionId = subscriptionSnapshot.docs[0].data().subscriptionId;
    const pauseResult = await pauseSquareSubscription(subscriptionId);
    if (pauseResult === 200) {
        await db.collection('users').doc(userId).update({ subscriptionStatus: 'PAUSED' });
        console.log('Subscription status set to PAUSED for user:', userId);
    } else {
        console.log('Failed to pause subscription for user:', userId);
    }
    }

async function handleSubscriptionUpdated(event) {
    const subscriptionStatus = event.data.object.subscription.status;
    const canceledDateString = event.data.object.subscription.canceled_date;
    const squareCustomerId = event.data.object.subscription.customer_id;

    const userSnapshot = await db.collection('users').where('squareCustomerId', '==', squareCustomerId).get();
    if (userSnapshot.empty) {
        console.log('No matching user found for Square Customer ID:', squareCustomerId);
        return;
    }

    const userId = userSnapshot.docs[0].id;
    let updatedStatus = subscriptionStatus; // Initialize with current status

    if (canceledDateString) {
        const now = new Date();
        const cancelDate = new Date(canceledDateString);

        if (cancelDate > now) {
            updatedStatus = 'PENDING-CANCEL';
        } else {
            updatedStatus = 'CANCELED';
        }
    }

    await db.collection('users').doc(userId).update({ subscriptionStatus: updatedStatus });
    console.log('Subscription status updated for user:', userId, 'New status:', updatedStatus);
}
