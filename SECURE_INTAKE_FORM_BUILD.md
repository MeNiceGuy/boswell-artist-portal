# Secure Intake Form Build Guide

Boswell Consulting Group

Version: 1.0  
Prepared: 2026-06-11

## Recommended Setup

Use Fillout, Tally, Jotform, Airtable Forms, Typeform, or another secure form provider for the first live version. Do not use the static HTML prototype as the production intake backend.

Recommended simplest path: create one Fillout or Tally form using the sections below, enable file uploads, and set the final confirmation message to tell artists to keep their Stripe receipt.

Recommended launch stack:

- Stripe Payment Links for payment.
- Secure intake form for data and uploads.
- Airtable or Google Sheets for admin tracking.
- Google Drive, Dropbox, or Box for confirmation folders.
- Gmail templates for client updates.

## Required Form Sections

1. Artist identity
2. Package purchased
3. Stripe receipt email or payment confirmation
4. Portal selection: BMI, ASCAP, The MLC, SoundExchange
5. Current account status
6. Song/release metadata
7. Writer, producer, split, and ownership details
8. ISRC, UPC, distributor, and store links
9. Uploads
10. Secure access preference
11. Authorization checkboxes
12. No-guarantee acknowledgment

Use WORK_ORDER_INTAKE_FORM.md as the complete field list.

## File Upload Fields

Enable uploads for:

- Split sheets
- Producer agreements
- Featured artist agreements
- Distributor screenshots
- ISRC/UPC proof
- Existing BMI/ASCAP/MLC/SoundExchange confirmations
- Store links or release evidence
- Prior royalty statements, if the artist wants a cleanup review

Do not request documents that are not needed for the specific work order.

## Required Checkboxes

Add these as required fields:

- I authorize Boswell Consulting Group to perform administrative registration support for this work order.
- I understand this service does not guarantee royalties, income, registration acceptance, claim approval, matching, or collection.
- I confirm I have the right to request support for the listed songs and recordings.
- I understand Boswell Consulting Group does not provide legal, tax, accounting, financial, publishing, or investment advice.
- I understand unresolved ownership or split disputes may delay or block the work order.
- I will not send passwords by normal email or open text fields.

## Payment Verification

Add one of these fields:

- Stripe receipt email
- Stripe payment link package selected
- Stripe payment confirmation screenshot
- Stripe checkout session ID, if available

Do not start work until payment is confirmed.

## Live Link Placeholder

After creating the form, replace `REPLACE_SECURE_INTAKE_FORM_LINK` in ARTIST_PORTAL_MVP.html and EMAIL_TEMPLATES.md with the live form URL.

If the upload form is separate, replace `REPLACE_SECURE_UPLOAD_LINK` in MISSING_INFORMATION_REQUEST_TEMPLATE.md with the live upload URL.

## Secure Access Workflow

Offer these choices:

- I will log in during a screen-share session.
- I will use a password manager shared item.
- I will create limited access if the portal allows it.
- I only want instructions and do not authorize done-for-you login support.

Do not collect passwords in the intake form.

## Confirmation Folder Structure

Create one folder per client:

Client Name - Artist Name

Inside it:

- 01 Intake
- 02 Uploads
- 03 Missing Info
- 04 Portal Confirmations
- 05 Completion Reports
- 06 Follow-Up
