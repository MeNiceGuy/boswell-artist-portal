# Independent Artist Royalty Registration Portal

Boswell Consulting Group

Version: 1.0  
Prepared: 2026-06-11

## Product Positioning

The portal is a paid work-order system for independent recording artists who need help organizing and submitting royalty-registration tasks. The artist submits one work order per song, release, or catalog batch. Boswell Consulting Group reviews the intake, flags missing information, and completes administrative registration or claim steps in the artist's selected portals.

This is an admin service, not a royalty-collection guarantee. The artist keeps ownership, account control, and payment destination. Boswell Consulting Group charges for intake review, metadata cleanup, registration support, claim support, documentation, and follow-up.

## Supported Portals

- BMI or ASCAP, based on the artist's chosen PRO.
- The MLC, for eligible U.S. digital audio mechanical royalty registration or claiming.
- SoundExchange, for sound recording digital performance royalty registration or claiming.

Do not submit both BMI and ASCAP for the same writer unless the artist has a legitimate separate reason. The intake must ask which PRO they are affiliated with, whether they need a new account, and whether they already have active portal access.

## Official Portal Notes

- BMI's join page states that songwriters and publishers affiliate separately, writer applicants sign a two-year agreement, and publisher applicants sign a five-year agreement. BMI also notes a one-time processing fee for publisher applications.
- The MLC says independent self-administered songwriters can become members to register works, suggest matches, and collect eligible U.S. digital audio mechanical royalties, and that joining is free.
- SoundExchange says creator/copyright-holder registration is free, simple, and fast, and that SoundExchange Direct lets registered creators claim recordings, manage catalog data, and review digital royalty payments.

Source links are maintained in Sources_and_References.txt.

## Portal Workflow

1. Artist chooses a package.
2. Artist submits a work order with song/release details, portal status, splits, identifiers, and authorization.
3. Boswell Consulting Group performs an intake review.
4. If data is missing, the work order moves to "Needs Artist Info."
5. If data is complete, Boswell Consulting Group completes the selected registration/claim tasks.
6. Artist receives a completion summary with portal, action taken, date, confirmation number or screenshot/file reference where available, and unresolved follow-up items.
7. Boswell Consulting Group schedules a 30-day or quarterly follow-up if included in the package.

## Work Order Statuses

- Draft
- Submitted
- Intake Review
- Needs Artist Info
- Ready for Submission
- Submitted to Portal
- Pending Portal Review
- Complete
- Follow-Up Scheduled
- Blocked
- Cancelled

## Minimum Viable Portal

The first version can be no-code or low-code:

- Checkout: Stripe Payment Link, Gumroad, Lemon Squeezy, or similar.
- Intake: Tally, Typeform, Fillout, Jotform, Airtable form, or custom form.
- Backend tracker: Airtable, Notion database, Google Sheet, or the included Excel tracker.
- Artist updates: email templates plus status fields.
- File upload: secure upload field in the form provider, not normal email attachments for sensitive documents.

The included ARTIST_PORTAL_MVP.html is a static prototype. It can generate a work-order summary and email draft, but it is not a secure production backend.

## Production Requirements

- Secure form submission with file upload.
- Payment before intake review starts.
- Client authorization checkbox and timestamp.
- Privacy policy.
- Terms of service.
- Refund policy.
- Work-order dashboard for admin tracking.
- Confirmation file storage.
- Status emails.
- Password manager workflow for portal credentials if access is required.
- No guarantee language anywhere in the funnel.

## Recommended Admin Stack

Fast launch:

- Stripe Payment Links for packages.
- Fillout or Tally for work-order forms.
- Airtable for work-order tracking.
- Google Drive or Dropbox for organized confirmation folders.
- Gmail templates for client updates.

Custom app later:

- Next.js portal.
- PostgreSQL database.
- Stripe checkout.
- Authenticated artist dashboard.
- Admin dashboard.
- File storage with signed upload URLs.
- Email notifications.

## Service Boundaries

Boswell Consulting Group can:

- Organize metadata.
- Prepare and submit administrative registration entries.
- Help artists identify missing portal/account steps.
- Record confirmation details.
- Provide a completion summary.
- Schedule follow-up checks.

Boswell Consulting Group should not:

- Promise royalties or income.
- Decide legal ownership disputes.
- Give tax, legal, accounting, or publishing advice.
- Hold itself out as the artist's lawyer, accountant, business manager, publisher, or royalty collector.
- Take ownership of songs, masters, publishing, or accounts.
- Use the artist's credentials without written authorization.
