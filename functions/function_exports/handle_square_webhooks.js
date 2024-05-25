const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { pauseSquareSubscription } = require("../subscriptions/pause_square_subscription");
const { retrieveCardDetails } = require("../payments/retrieve_square_card_from_id");

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

     res.status(200).send('Event received');


    try {
        switch (event.type) {
            case 'payment.created':
                await handleFailedInitialPayment(event);
                break;
            case 'payment.updated':
                await handleFailedRecurringPayment(event);
                break;
            case 'invoice.created':
            return 200;
//                await handleInvoiceCreatedEvent(event);
                break;
            case 'invoice.payment_made':
                await handleInvoicePaymentMade(event);
                break;
            case 'subscription.updated':
                await handleSubscriptionUpdated(event);
                break;
            default:
                console.log('Unhandled event type:', event.type);
        }

        res.status(200).send('Event received');
    } catch (error) {
        console.error('Error handling event:', error);
        res.status(500).send('Internal Server Error');
    }
});

async function handleFailedInitialPayment(event) {
    try {
        console.log('Handling failed initial payment event');
        const squareCustomerId = event.data.object.customer_id;

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

        const userId = userSnapshot.docs[0].id;
        console.log('Failed initial payment for user:', userId);
        await db.collection('users').doc(userId).update({ subscriptionStatus: 'FAILED' });
    } catch (error) {
        console.error('Error handling failed initial payment event:', error);
        throw error; // Propagate the error to ensure the main handler catches it
    }
}

async function handleFailedRecurringPayment(event) {
    try {
        const squareCustomerId = event.data.object.payment.customerId;
        const locationId = event.data.object.payment.locationId;
        const isFailedPayment = event.data.object.payment.status === 'FAILED';

        if (locationId !== 'LPRZ3G3PWZBKF' || !isFailedPayment) {
            return;
        }

        const userSnapshot = await db.collection('users').where('squareCustomerId', '==', squareCustomerId).get();

        if (userSnapshot.empty) {
            console.log('No matching user found for Square Customer ID:', squareCustomerId);
            return;
        }

        const userId = userSnapshot.docs[0].id;
        const subscriptionSnapshot = await db.collection('subscriptions').where('userId', '==', userId).get();
        if (subscriptionSnapshot.empty) {
            console.log('No subscription detected for this user:', squareCustomerId);
            return;
        }

        const subscriptionId = subscriptionSnapshot.docs[0].data().subscriptionId;
        const pauseResult = await pauseSquareSubscription({ subscriptionId });
        if (pauseResult === 200) {
            await db.collection('users').doc(userId).update({ subscriptionStatus: 'PAUSED' });
            console.log('Subscription status set to PAUSED for user:', userId);
        } else {
            console.log('Failed to pause subscription for user:', userId);
        }
    } catch (error) {
        console.error('Error handling failed recurring payment event:', error);
        throw error; // Propagate the error to ensure the main handler catches it
    }
}

async function handleInvoiceCreatedEvent(event) {
    try {
        const squareCustomerId = event.data.object.invoice.primary_recipient.customer_id;
        const locationId = event.data.object.invoice.location_id;

        if (locationId !== 'LPRZ3G3PWZBKF') {
            return;
        }

        const userSnapshot = await db.collection('users').where('squareCustomerId', '==', squareCustomerId).get();
        if (userSnapshot.empty) {
            console.log('No matching user found for Square Customer ID:', squareCustomerId);
            return;
        }

        const userId = userSnapshot.docs[0].id;
        console.log(userId);
        const subscriptionSnapshot = await db.collection('subscriptions').where('userId', '==', userId).get();
        if (subscriptionSnapshot.empty) {
            console.log('No subscription detected for this user:', squareCustomerId);
            return;
        }

        console.log(subscriptionSnapshot.docs[0].data());

        const subscriptionId = subscriptionSnapshot.docs[0].data().subscriptionId;
        const pauseResult = await pauseSquareSubscription({ subscriptionId });
        if (pauseResult === 200) {
            await db.collection('users').doc(userId).update({ subscriptionStatus: 'PAUSED' });
            console.log('Subscription status set to PAUSED for user:', userId);
        } else {
            console.log('Failed to pause subscription for user:', userId);
        }
    } catch (error) {
        console.error('Error handling invoice created event:', error);
        throw error; // Propagate the error to ensure the main handler catches it
    }
}

async function handleSubscriptionUpdated(event) {
    try {
        const subscriptionStatus = event.data.object.subscription.status;
        const canceledDateString = event.data.object.subscription.canceled_date;
        const squareCustomerId = event.data.object.subscription.customer_id;

        const userSnapshot = await db.collection('users').where('squareCustomerId', '==', squareCustomerId).get();
        if (userSnapshot.empty) {
            console.log('No matching user found for Square Customer ID:', squareCustomerId);
            return;
        }

        const userId = userSnapshot.docs[0].id;
        let updatedStatus = subscriptionStatus;

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
    } catch (error) {
        console.error('Error handling subscription updated event:', error);
        throw error; // Propagate the error to ensure the main handler catches it
    }
}

async function handleInvoicePaymentMade(event) {
    try {
        console.log('Handling invoice payment made event');

        const invoiceStatus = event.data.object.invoice.status;
        const squareCustomerId = event.data.object.invoice.primary_recipient.customer_id;
        const customerFirstName = event.data.object.invoice.primary_recipient.given_name;
        const cardId = event.data.object.invoice.payment_requests[0].card_id;

        console.log(squareCustomerId);
        console.log(customerFirstName);
        console.log(cardId);

        if (invoiceStatus !== 'PAID') {
            console.log('Invoice is not paid:', invoiceStatus);
            return;
        }

        const usersRef = db.collection('users');
        const userSnapshot = await usersRef.where('squareCustomerId', '==', squareCustomerId).get();
        if (userSnapshot.empty) {
            console.log('No matching user found for Square Customer ID:', squareCustomerId);
            return;
        }

        console.log('Got user');

        const userId = userSnapshot.docs[0].id;
        const userDocRef = usersRef.doc(userId);
        await userDocRef.update({
            subscriptionStatus: 'ACTIVE'
        });
        console.log('User subscription status updated to ACTIVE for user:', userId);

        const paymentMethodsRef = usersRef.doc(userId).collection('squarePaymentMethods');
        const paymentMethodSnapshot = await paymentMethodsRef.where('cardId', '==', cardId).get();

        if (paymentMethodSnapshot.empty) {
            console.log('Card ID not found, retrieving card details from Square API');

            const cardDetails = await retrieveCardDetails(cardId);
            if (cardDetails) {
                const newPaymentMethodRef = paymentMethodsRef.doc();
                const newDocumentId = newPaymentMethodRef.id;
                await newPaymentMethodRef.set({
                    balance: null,
                    brand: cardDetails.card.cardBrand,
                    cardId: cardDetails.card.id,
                    cardNickname: customerFirstName.trim(),
                    defaultPayment: false,
                    expirationMonth: cardDetails.card.expMonth,
                    expirationYear: cardDetails.card.expYear,
                    gan: null,
                    isWallet: false,
                    last4: cardDetails.card.last4,
                    uid: newDocumentId,
                    userID: userId,
                });
                console.log('New payment method added with UID:', newDocumentId);
            } else {
                console.log('Failed to retrieve card details from Square');
                return;
            }
        }

        const subscriptionsRef = db.collection('subscriptions');
        const subscriptionSnapshot = await subscriptionsRef.where('userId', '==', userId).get();
        if (subscriptionSnapshot.empty) {
            console.log('No subscription detected for this user:’, userId');
             return;
          }
              const subscriptionId = subscriptionSnapshot.docs[0].data().subscriptionId;
              const subscriptionDocRef = subscriptionsRef.doc(subscriptionId);
              await subscriptionDocRef.update({
                  cardId: cardId
              });
              console.log('Subscription card ID updated for user:', userId);
          } catch (error) {
              console.error('Error handling invoice payment made:', error);
              throw error; // Propagate the error to ensure the main handler catches it
          }
          }