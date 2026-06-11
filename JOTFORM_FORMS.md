# Jotform Form Build Pack

Boswell Consulting Group

Version: 1.0  
Prepared: 2026-06-11

Use this pack to create the live Jotform forms for the artist portal. The two-form setup keeps the main intake focused while giving you a separate link for missing information and follow-up uploads.

## Forms to Create

1. Secure Work Order Intake
2. Missing Information and Follow-Up Upload

## Global Settings

- Owner email: 1boswelld@gmail.com
- Require SSL on all forms.
- Enable file uploads only for work-order support materials.
- Do not add password fields.
- Do not request portal passwords in text fields, upload fields, or email notifications.
- Add the privacy, refund, credential, and authorization docs as footer or confirmation links if your Jotform plan supports links in form text.

## Secure Work Order Intake

Form title:

Boswell Artist Portal - Secure Work Order Intake

Confirmation message:

Thank you. Your work order intake was received. Keep your Stripe receipt for your records. Boswell Consulting Group will review the intake and follow up if required information is missing. Do not send passwords by email or through open text fields.

Notification subject:

New artist work order intake - {artistStageName} - {songOrReleaseTitle}

Fields:

| Section | Field | Jotform type | Required | Options / Notes |
| --- | --- | --- | --- | --- |
| Artist Information | Legal name | Full Name | Yes | First and last legal name. |
| Artist Information | Artist/stage name | Short Text | Yes | Public artist name. |
| Artist Information | Email | Email | Yes | Used for work-order follow-up. |
| Artist Information | Phone | Phone | No | Best callback number. |
| Artist Information | Country | Short Text | Yes | Country of residence/business. |
| Artist Information | State/province | Short Text | No | State, province, or region. |
| Artist Information | Preferred contact method | Dropdown | Yes | Email, Phone, Text message, Video call. |
| Artist Information | Are you 18 or older? | Yes/No | Yes | If no, collect parent/guardian contact. |
| Artist Information | Parent/guardian contact | Long Text | Conditional | Show only when artist is under 18. |
| Payment | Package purchased | Dropdown | Yes | Starter Release Bundle - $97; Royalty Account Setup - $49; Single Song Registration - $29; Release Pack - $97; Extra Track Add-On - $5; Catalog Cleanup Sprint - $200; Monthly Royalty Admin Desk - $49/mo. |
| Payment | Stripe receipt email | Email | Yes | Email used at Stripe checkout. |
| Payment | Stripe payment confirmation | File Upload | No | Optional receipt screenshot. |
| Portal Selection | Portals needing support | Multiple Choice | Yes | BMI; ASCAP; The MLC; SoundExchange; Not sure / need review. |
| Current Account Status | Current account status | Multiple Choice | Yes | I already have BMI access; I already have ASCAP access; I already have The MLC access; I already have SoundExchange access; I need account setup support; I am not sure. |
| Song or Release Details | Work order type | Dropdown | Yes | Single song; EP; Album; Old catalog cleanup; Account setup only; Missing-information review. |
| Song or Release Details | Song title | Short Text | Conditional | Required unless account setup only. |
| Song or Release Details | Alternate title | Short Text | No | Optional. |
| Song or Release Details | Recording title, if different | Short Text | No | Optional. |
| Song or Release Details | Primary artist | Short Text | Yes | Main recording artist. |
| Song or Release Details | Featured artists | Long Text | No | Names and roles. |
| Song or Release Details | Writers | Long Text | Conditional | Required for song/release work orders. |
| Song or Release Details | Producers | Long Text | No | Names and roles. |
| Song or Release Details | Master owner | Short Text | No | Person/entity controlling the recording. |
| Song or Release Details | Publisher or self-administered status | Short Text | No | Publisher name or self-administered. |
| Song or Release Details | Release date | Date Picker | No | Use known or planned release date. |
| Song or Release Details | Distributor | Short Text | No | DistroKid, TuneCore, CD Baby, etc. |
| Song or Release Details | UPC | Short Text | No | Release UPC if available. |
| Song or Release Details | ISRC | Short Text | No | Recording ISRC if available. |
| Song or Release Details | DSP/store links | Long Text | No | Spotify, Apple Music, YouTube, distributor links. |
| Song or Release Details | Lyrics available? | Yes/No | No | Optional. |
| Song or Release Details | Explicit content? | Yes/No | No | Optional. |
| Song or Release Details | Is this already released? | Yes/No | Yes | Helps determine portal workflow. |
| Song or Release Details | Is this already registered anywhere? | Long Text | No | Existing BMI, ASCAP, MLC, SoundExchange, distributor, or publisher records. |
| Splits and Ownership | Writer split percentages | Long Text | Conditional | Required for composition-related work. |
| Splits and Ownership | Publisher split percentages | Long Text | No | If known. |
| Splits and Ownership | Master ownership percentages | Long Text | No | If known. |
| Splits and Ownership | Featured artist agreement status | Dropdown | No | Signed; Verbal only; Not applicable; Not sure. |
| Splits and Ownership | Producer agreement status | Dropdown | No | Signed; Verbal only; Not applicable; Not sure. |
| Splits and Ownership | Any unresolved split disputes? | Yes/No | Yes | If yes, work may be delayed or blocked. |
| Splits and Ownership | Any samples or interpolations? | Yes/No | Yes | If yes, collect notes. |
| Splits and Ownership | Any cover song involved? | Yes/No | Yes | If yes, collect notes. |
| Splits and Ownership | Ownership, sample, cover, or dispute notes | Long Text | Conditional | Show when any ownership risk answer is yes. |
| Uploads | Split sheet or agreement upload | File Upload | No | Split sheets, producer agreements, featured artist agreements. |
| Uploads | Distributor or release proof upload | File Upload | No | Distributor screenshots, ISRC/UPC proof, store evidence. |
| Uploads | Existing registration confirmations | File Upload | No | BMI, ASCAP, MLC, SoundExchange, or other portal confirmations. |
| Uploads | Prior royalty statements | File Upload | No | Optional for cleanup review. |
| Portal Task Request | Portal tasks requested | Multiple Choice | Yes | Register composition with selected PRO; Register or claim composition with The MLC; Register or claim recording with SoundExchange; Review existing portal entries; Correct missing metadata; Prepare missing-information report only. |
| Credentials and Access | Preferred secure access method | Dropdown | Yes | Artist will log in during a screen-share session; Artist will create limited access if portal allows it; Artist will provide credentials through an approved password manager; Artist only wants instructions, not done-for-you login support. |
| Authorization | Authorization to perform support | Checkbox | Yes | Exact text from `WORK_ORDER_INTAKE_FORM.md`. |
| Authorization | Accuracy and rights confirmation | Checkbox | Yes | Exact text from `WORK_ORDER_INTAKE_FORM.md`. |
| Authorization | Delay/blocking acknowledgment | Checkbox | Yes | Exact text from `WORK_ORDER_INTAKE_FORM.md`. |
| Authorization | No password submission acknowledgment | Checkbox | Yes | I understand passwords must not be submitted by normal email or open form fields. |

## Missing Information and Follow-Up Upload

Form title:

Boswell Artist Portal - Missing Information Upload

Confirmation message:

Thank you. Your missing-information response was received. Boswell Consulting Group will review the update and contact you if anything else is required. Do not send passwords by email or through open text fields.

Notification subject:

Missing information response - {artistStageName} - {songOrReleaseTitle}

Fields:

| Section | Field | Jotform type | Required | Options / Notes |
| --- | --- | --- | --- | --- |
| Work Order | Work order ID | Short Text | No | Use if provided in the request. |
| Work Order | Artist/stage name | Short Text | Yes | Matches original work order. |
| Work Order | Email | Email | Yes | Follow-up email. |
| Work Order | Song/release title | Short Text | Yes | Matches original work order. |
| Missing Information | Missing information being provided | Long Text | Yes | Artist describes what they are submitting. |
| Missing Information | Files to upload | File Upload | No | Split sheet, agreement, distributor proof, confirmation screenshot, royalty statement, or other requested support file. |
| Missing Information | Portal or task this relates to | Multiple Choice | No | BMI; ASCAP; The MLC; SoundExchange; Distributor metadata; Split/ownership details; Other. |
| Missing Information | Deadline from request | Date Picker | No | Optional. |
| Access | Secure access preference update | Dropdown | No | Screen-share login session; Password manager shared item; Limited access if available; Instructions only. |
| Authorization | No password submission acknowledgment | Checkbox | Yes | I understand passwords must not be submitted by normal email or open form fields. |
| Authorization | Accuracy confirmation | Checkbox | Yes | I confirm this information is accurate to the best of my knowledge. |

## After Publishing

1. Copy the public URL for Secure Work Order Intake.
2. Copy the public URL for Missing Information and Follow-Up Upload.
3. Paste the intake URL into `portalConfig.secureIntakeUrl` in `index.html` and `ARTIST_PORTAL_MVP.html`.
4. Paste the missing-information upload URL into `portalConfig.secureUploadUrl` in both HTML files if you use the separate upload form.
5. Update `LIVE_LINKS_TO_REPLACE.md`, `EMAIL_TEMPLATES.md`, and `MISSING_INFORMATION_REQUEST_TEMPLATE.md`.
6. Run `.\LAUNCH_AUDIT.ps1`.

