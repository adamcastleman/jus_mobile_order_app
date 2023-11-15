require("dotenv").config();

function generateGiftCardEmail(giftCardMap) {
  const footer = `
<div class="email-container">
 <div class="divider"></div>
  <div class="center">
    <h4>We're here to help</h4>
    <p>Email us at <a href="mailto:support@jusreno.com">support@jusreno.com</a> for any questions or concerns regarding this order. We will respond within 24 hours.</p>
  </div>
  <div class="divider"></div>
   <p style="text-align: center; font-size: 12px;">
     You are receiving this email because you have made a purchase from jüs. You can manage notifications for marketing emails in the jüs app or at <a href="https://www.jusreno.com" style="color: blue;">www.jusreno.com</a>, but you will always receive emails regarding transactions.
   </p>
  </div>
 </div>`;

  return `
    <html>
      <body>
       <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>We\'ve loaded your Wallet.</title>
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500&display=swap" rel="stylesheet">
        <style>
                 body { font-family: 'Quicksand', sans-serif; }
                 .center { text-align: center; }
                 .divider { border-top: 1px solid #ddd; margin: 20px 0; }
                 .email-container {
                   margin: 0 auto;
                   max-width: 600px;
                 }
               </style>
      <div class="center">
         <img src="${process.env.JUS_LOGO}" alt="jusLogo" width="100" />
        <br/><br/>

       Your Wallet has been loaded with $${
         giftCardMap.paymentDetails.amount / 100
       }.
       <br>
       ${footer}
        </body>
        </html>
        `;
}

module.exports = generateGiftCardEmail;
