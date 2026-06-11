$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$indexPath = Join-Path $root "index.html"
$content = Get-Content -LiteralPath $indexPath -Raw

$checks = @()

function Add-Check {
  param(
    [string]$Name,
    [bool]$Passed,
    [string]$Detail
  )

  $script:checks += [pscustomobject]@{
    Check = $Name
    Passed = $Passed
    Detail = $Detail
  }
}

$legacyPlaceholderToken = "RE" + "PLACE_"
$replaceTokens = Get-ChildItem -LiteralPath $root -File |
  Where-Object { $_.Name -ne "LAUNCH_AUDIT.ps1" -and $_.Extension -notin @(".pdf", ".docx", ".xlsx") } |
  Select-String -Pattern $legacyPlaceholderToken -SimpleMatch -ErrorAction SilentlyContinue
Add-Check "No legacy launch tokens" ($replaceTokens.Count -eq 0) "Repository should not contain old hardcoded launch placeholders."

$hasDisabledGuard = $content -match "setLinkState" -and $content -match "aria-disabled"
Add-Check "Disabled external-link guard" $hasDisabledGuard "Payment and intake links should not be clickable until configured."

$stripeUrlCount = ([regex]::Matches($content, '"https://buy\.stripe\.com/')).Count
Add-Check "Stripe links configured" ($stripeUrlCount -ge 7) "Expected 7 live Stripe Payment Link URLs in portalConfig."

$secureIntakeConfigured = $content -match 'secureIntakeUrl:\s*"https?://'
Add-Check "Secure intake configured" $secureIntakeConfigured "Expected a live secure intake form URL in portalConfig.secureIntakeUrl."

$requiredDocs = @(
  "CLIENT_AUTHORIZATION_AND_TERMS.md",
  "PRIVACY_POLICY.md",
  "REFUND_POLICY.md",
  "CREDENTIAL_POLICY.md",
  "SECURE_INTAKE_FORM_BUILD.md",
  "STRIPE_PAYMENT_LINK_SETUP.md",
  "WORK_ORDER_INTAKE_FORM.md"
)

foreach ($doc in $requiredDocs) {
  Add-Check "Required doc: $doc" (Test-Path -LiteralPath (Join-Path $root $doc)) "Required launch/support document should exist."
}

$failed = @($checks | Where-Object { -not $_.Passed })
$checks | Format-Table -AutoSize

if ($failed.Count -gt 0) {
  Write-Host ""
  Write-Host "Launch readiness: BLOCKED ($($failed.Count) check(s) failing)." -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "Launch readiness: PASS." -ForegroundColor Green
