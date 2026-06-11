$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$indexPath = Join-Path $root "index.html"
$mvpPath = Join-Path $root "ARTIST_PORTAL_MVP.html"
$specPath = Join-Path $root "jotform-form-specs.json"
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

function Get-PortalConfigBlock {
  param([string]$Script)

  $match = [regex]::Match(
    $Script,
    'const\s+portalConfig\s*=\s*(\{[\s\S]*?\n\s{4}\});',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
  )

  if (-not $match.Success) {
    return $null
  }

  return $match.Groups[1].Value
}

function Convert-JsObjectToJson {
  param([string]$JsObject)

  return $JsObject `
    -replace '([,{]\s*)([A-Za-z_][A-Za-z0-9_]*)\s*:', '$1"$2":' `
    -replace ',(\s*[}\]])', '$1'
}

$indexContent = Get-Content -LiteralPath $indexPath -Raw
$mvpContent = Get-Content -LiteralPath $mvpPath -Raw

Add-Check "index.html exists" (Test-Path -LiteralPath $indexPath) "Static portal entrypoint should exist."
Add-Check "ARTIST_PORTAL_MVP.html exists" (Test-Path -LiteralPath $mvpPath) "Standalone MVP copy should exist."
Add-Check "Portal files are synchronized" ($indexContent -eq $mvpContent) "index.html and ARTIST_PORTAL_MVP.html should match exactly."

$scriptMatch = [regex]::Match($indexContent, '<script>([\s\S]*?)</script>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
Add-Check "Inline script present" $scriptMatch.Success "Portal should include the form behavior script."

if ($scriptMatch.Success) {
  $script = $scriptMatch.Groups[1].Value
  $tempScriptPath = Join-Path ([System.IO.Path]::GetTempPath()) "boswell-artist-portal-inline-script.js"
  Set-Content -LiteralPath $tempScriptPath -Value $script -Encoding UTF8

  $nodeOutput = & node --check $tempScriptPath 2>&1
  Add-Check "Inline JavaScript syntax" ($LASTEXITCODE -eq 0) (($nodeOutput | Out-String).Trim())

  $configBlock = Get-PortalConfigBlock -Script $script
  Add-Check "portalConfig present" ($null -ne $configBlock) "Script should expose the external link configuration object."

  if ($configBlock) {
    $portalConfig = Convert-JsObjectToJson -JsObject $configBlock | ConvertFrom-Json
    $configPackages = @($portalConfig.stripePaymentLinks.PSObject.Properties.Name)
    $selectMatch = [regex]::Match($indexContent, '<select id="packageName">([\s\S]*?)</select>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $optionMatches = [regex]::Matches($selectMatch.Groups[1].Value, '<option>(.*?)</option>')
    $selectPackages = @($optionMatches | ForEach-Object { [System.Net.WebUtility]::HtmlDecode($_.Groups[1].Value) })
    $missingConfig = @($selectPackages | Where-Object { $_ -notin $configPackages })
    $missingOptions = @($configPackages | Where-Object { $_ -notin $selectPackages })

    Add-Check "Package options have Stripe config keys" ($missingConfig.Count -eq 0) "Missing config keys: $($missingConfig -join ', ')"
    Add-Check "Stripe config keys appear in package options" ($missingOptions.Count -eq 0) "Missing select options: $($missingOptions -join ', ')"
    Add-Check "Seven payment packages configured" ($configPackages.Count -eq 7) "Expected 7 Stripe package entries."
  }

  $requiredIds = @(
    "artistName", "email", "legalName", "phone", "packageName", "pro", "title", "releaseDate",
    "distributor", "isrc", "upc", "storeLinks", "portalStatus", "accessMethod", "tasks", "splits",
    "authOne", "authTwo", "authThree", "authFour", "stripeLink", "intakeLink", "copyButton",
    "summary", "emailLink", "summaryStripeLink", "summaryIntakeLink", "launchStatus"
  )
  $missingIds = @($requiredIds | Where-Object { $indexContent -notmatch ('id="' + [regex]::Escape($_) + '"') })
  Add-Check "Required DOM ids present" ($missingIds.Count -eq 0) "Missing ids: $($missingIds -join ', ')"
}

try {
  $spec = Get-Content -LiteralPath $specPath -Raw | ConvertFrom-Json
  Add-Check "Jotform spec is valid JSON" $true "jotform-form-specs.json should parse."
  Add-Check "Jotform spec has forms" (@($spec.forms).Count -ge 2) "Expected secure intake and missing-information forms."
} catch {
  Add-Check "Jotform spec is valid JSON" $false $_.Exception.Message
}

$failed = @($checks | Where-Object { -not $_.Passed })
$checks | Format-Table -AutoSize

if ($failed.Count -gt 0) {
  Write-Host ""
  Write-Host "Portal smoke test: FAIL ($($failed.Count) check(s) failing)." -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "Portal smoke test: PASS." -ForegroundColor Green
