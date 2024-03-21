let card; // Global variable to store the card object

async function waitForElement(selector, retryInterval = 100, maxAttempts = 20) {
    let attempts = 0;
    while (attempts < maxAttempts) {
        const element = document.querySelector(selector);
        if (element) return element;
        await new Promise(resolve => setTimeout(resolve, retryInterval));
        attempts++;
    }
    throw new Error(`Element ${selector} not found after ${maxAttempts} attempts`);
}

async function squareCreditCardWebForm(applicationId, locationId) {
    const payments = Square.payments(applicationId, locationId);
    card = await payments.card();

    try {
        const cardContainer = await waitForElement('#card-container');
        await card.attach('#card-container');
    } catch (error) {
        console.error(error);
    }
}

async function squareGiftCardWebForm(applicationId, locationId) {
    const payments = Square.payments(applicationId, locationId);
    card = await payments.giftCard();

    try {
        const cardContainer = await waitForElement('#card-container');
        await card.attach('#card-container');
    } catch (error) {
        console.error(error);
    }
}


async function tokenizeCard(callback) {
    const tokenResult = await card.tokenize();
    if (tokenResult.status === 'OK') {
    const cardDetails = {
        'nonce': tokenResult.token,
        'last4': tokenResult.details.card.last4,
        'brand': tokenResult.details.card.brand,
    };
        callback(cardDetails);
    } else {
        console.error(tokenResult.errors);
    }
}

// This function is called from Dart to set the callback
async function setTokenizationCallback(callback) {
    await tokenizeCard((cardDetails) => {
        const cardDetailsMap = {
            'nonce': cardDetails.nonce,
            'last4': cardDetails.last4,
            'brand': cardDetails.brand,
        };
        const jsonString = JSON.stringify(cardDetailsMap); // Convert to JSON string
        callback(jsonString); // Return the JSON string
    });
}
