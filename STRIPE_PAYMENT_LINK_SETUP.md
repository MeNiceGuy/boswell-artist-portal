# Stripe Payment Link Setup

Boswell Consulting Group

Version: 1.0  
Prepared: 2026-06-11

## Integration Choice

Use Stripe Payment Links for the first version of the artist portal. This avoids building a backend before the offer is validated. Stripe's documentation describes Payment Links as reusable Stripe-hosted pages for products or subscriptions, with low integration effort, automatic receipts, no-code refunds, and recurring subscription support.

Official Stripe docs:

- Payment Links overview: https://docs.stripe.com/payment-links
- No-code Payment Links setup: https://docs.stripe.com/no-code/payment-links

## Products to Create in Stripe

Create these Stripe products and prices:

1. Starter Release Bundle
   - Price: $97 one-time
   - Description: Account setup checklist, up to 12 songs, completion tracker, and 30-day follow-up.

2. Royalty Account Setup
   - Price: $49 one-time
   - Description: Portal readiness review for BMI or ASCAP, The MLC, and SoundExchange.

3. Single Song Registration Work Order
   - Price: $29 one-time
   - Description: One song registration/claim support across selected royalty portals.

4. Release Pack
   - Price: $97 one-time
   - Description: Up to 12 songs with metadata review, portal support, completion summary, and 30-day follow-up. Additional tracks are $5 each.

5. Catalog Cleanup Sprint
   - Price: $200 one-time
   - Description: Up to 25 older songs with catalog audit, portal support, confirmation tracker, and follow-up.

6. Extra Track Add-On
   - Price: $5 one-time
   - Description: One additional track beyond the Release Pack's included 12 songs.

7. Monthly Royalty Admin Desk
   - Price: $49/month recurring
   - Description: Up to 2 single-song work orders per month, quarterly audit, and priority support.

## Recommended Stripe Settings

For each one-time work order link:

- Collect customer email.
- Enable automatic receipts.
- Collect phone number if desired.
- Add custom field: Artist Name.
- Add custom field: Song or Release Title.
- Add custom field: Selected PRO.
- Add custom field: Work Order Notes.
- Set success URL to a thank-you or intake-confirmation page.
- Set terms/disclaimer in the product description or checkout terms area.

For the monthly plan:

- Use recurring monthly price.
- Enable customer portal for subscription cancellation or card updates.
- Clearly state monthly included work order limit.
- Clearly state extra-song fees.

For the Extra Track Add-On:

- Enable adjustable quantity if Stripe offers it for the link, or instruct artists to buy one add-on per additional track.
- Keep this separate from the Release Pack so smaller artists can pay only when they exceed 12 tracks.

## Portal File Integration

Open ARTIST_PORTAL_MVP.html and replace these placeholders:

- `https://buy.stripe.com/REPLACE_STARTER_RELEASE_BUNDLE`
- `https://buy.stripe.com/REPLACE_ROYALTY_ACCOUNT_SETUP`
- `https://buy.stripe.com/REPLACE_SINGLE_SONG`
- `https://buy.stripe.com/REPLACE_RELEASE_PACK`
- `https://buy.stripe.com/REPLACE_EXTRA_TRACK_ADD_ON`
- `https://buy.stripe.com/REPLACE_CATALOG_SPRINT`
- `https://buy.stripe.com/REPLACE_MONTHLY_SUBSCRIPTION`

Replace each placeholder with the live or test Payment Link URL copied from the Stripe Dashboard.

## Fulfillment Rule

Do not start work until payment is confirmed and the work-order intake is complete.

Suggested sequence:

1. Artist chooses package in the portal.
2. Artist generates the work order summary.
3. Artist pays through Stripe.
4. Artist emails/submits the work order summary.
5. Boswell Consulting Group confirms payment and intake completeness.
6. Work starts.

## Production Upgrade Later

When the portal becomes a custom app, replace Payment Links with Stripe Checkout Sessions and webhooks:

- Create Checkout Session server-side.
- Store work order as `pending_payment`.
- Listen for `checkout.session.completed`.
- Mark work order as `paid`.
- Send confirmation email.
- For subscriptions, listen for subscription lifecycle events.

Do not expose secret keys in the browser.

## Payment Disclaimer

Payment covers administrative service labor only. Official portal fees, if any, are separate unless clearly stated in writing. No royalty payment, income amount, claim approval, registration acceptance, matching, or collection outcome is guaranteed.
