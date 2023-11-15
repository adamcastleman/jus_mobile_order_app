require("dotenv").config();

function generateCleanseInstructionsEmail() {
  return `
    <html>
      <body>
       <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Cleanse Guidelines</title>
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

        <h3 style="font-weight: bold;">Why Cleanse?</h3>
        <ul>
          <li>Our cleanses let you push a ‘reset’ button on your body.</li>
          <li>If your diet has been less than ideal lately, or you’ve been feeling sluggish or low energy, a detox cleanse may be just what you need to get back to feeling your best.</li>
          <li>Cleanses are designed to give your digestive system a well earned rest, while simultaneously flooding your body with an abundance of nutrients from freshly pressed fruits and vegetables.</li>
        </ul>
        <br/>

        <h3 style="font-weight: bold;">The Cleanses</h3>
          <br>
              <h4 style="font-weight: bold;">Full Day Cleanse:</h4>
              <p>Up to five days of juicing. | Six juices per day.</p>
              <p>Designed as a complete fast. Fully rest your digestive system while giving your body the tools it needs for a healthy detox.</p>
              <p>We provide six cold-pressed juices per day:</p>
              <ul>
                <li>Activated Charcoal, Ginger, Lemon, Maple, Water</li>
                <li>100% Celery Juice</li>
                <li>Orange, Carrot, Beet, Lemon, Ginger</li>
                <li>Cucumber, Apple, Celery, Spinach, Kale</li>
                <li>Cucumber, Ginger, Lemon, Celery, Spinach, Kale</li>
                <li>Blue Algae, Ginger, Lemon, Maple, Water</li>
              </ul>
           <br>
              <h4 style="font-weight: bold;">Juice ’til Dinner:</h4>
              <p>Up to five days of juicing. | Four juices per day.</p>
              <p>A great introduction to cleansing. Reap many benefits of a full cleanse while still being able to consume some solid foods.</p>
              <p>We provide four cold-pressed juices per day:</p>
              <ul>
                <li>Activated Charcoal, Ginger, Lemon, Maple, Water</li>
                <li>100% Celery Juice</li>
                <li>Orange, Carrot, Beet, Lemon, Ginger</li>
                <li>Cucumber, Apple, Celery, Spinach, Kale</li>
              </ul>
            </td>
          </tr>
        <br/>
        <h4>Preparing for your cleanse</h4>
        <h4>Pre-tox</h4>
        <p>Failing to plan is planning to fail. Before you start your cleanse, it’s recommended you take steps to ensure you have a smooth and successful transition to a liquid diet.</p>
        <p>A few days before you start your cleanse, begin by reducing, and ultimately eliminating, chemical stimulants and refined sugars from your diet including alcohol, caffeine, processed cane sugar, and corn syrup. Limit your intake of red meats, fried and processed foods, and complex gluten foods like bread and pasta. Consume a diet of mostly raw vegetables and lean proteins leading up to your cleanse.</p>
        <p>Plan your logistics. Your juices need to stay chilled at all times. If you have work or school, or errands to run, invest in an insulated lunch bag or cooler with ice packs to make sure your juices stay cold while you’re out of your home, and ensure you stay on your juice schedule.</p>
        <p>Plan on taking it easy during the duration of your cleanse. Try to have nothing to do on the days you are cleansing. You are consuming far fewer calories than normal, and your energy levels will reflect this. Refrain from heavy exercise and try not to overexert yourself. Plan on needing extra, deeper sleep and rest throughout the day. Your body is doing a lot of work. Help it!</p>
       <h4>During Your Cleanse</h4>
       <p>Begin your first juice within 45 minutes of waking. Doing so will jump-start your metabolism and get your day off on the right foot.</p>
       <p>Drink your juices in order and space them out every three hours. This will make sure you’re constantly and consistently supplying your body with the proper nutrients. In addition, keeping a regular drinking schedule will help your body adjust quickly during the initial transition of the fast.</p>
       <p>Drinking water is essential during your cleanse. The live nutrients in the juice will allow your cells to dump built-up toxins, and the water will help wash them all away. Try to match your water consumption with your juice consumption ounce-for-ounce.</p>
       <p>Keep your bottles sealed and chilled until you’re ready to enjoy them. Consume each bottle fully before opening the next, as too much oxygen exposure will reduce the longevity and nutritional value of the juices.</p>
       <p>If you’re on the “jüs ’til dinner” cleanse, we suggest eating a light, lean meal at least 3 hours before going to bed. This will ensure full digestion before your body shuts down for the night.</p>
       <h4>Post Cleanse</h4>
       <p>Congratulations! You’ve made it through your cleanse and your body is thanking you. Before you ease back into a normal (and hopefully healthy) lifestyle, it’s recommended you take a few steps to help successfully transition back to eating.</p>
       <p>Your stomach has likely shrunk from the lack of food, and you’ll need to introduce food back into your body carefully.</p>
       <h4>Full Day Cleanse:</h4>
       <p>Start your morning with something very light and easily digestible. Soft fruits (bananas, oranges, melon), smoothies, simple soups, etc. are all great options to break your fast with. Make sure the foods are “pre-digested” by using a blender, eating foods that are mostly broth based, or eating soft, easily digestible foods.</p>
       <p>Gradually increase toward more solid foods like rice, quinoa, whole vegetables, etc., and see how your stomach responds. If you feel discomfort, keep drinking those smoothies until a little later in the day, then try again.</p>
       <p>After you can handle these foods in moderate quantities, experiment with other foods in your usual diet and see what works. You should be back to normal by this point, but don’t overdo it before you feel comfortable at all stages.</p>
       <h4>Juice \'til Dinner:</h4>
       <p>Start your morning with a smoothie or piece of fruit or vegetable to help your transition back to your fully solid diet.</p>
       <p>Gradually increase toward more solid foods like rice, quinoa, hearty salads, and lean proteins throughout your day. You should be back to normal by dinner time, but don’t overdo it before you feel comfortable at all stages.</p>
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
        </div>
        </body>
        </html>
        `;
}

module.exports = generateCleanseInstructionsEmail;
