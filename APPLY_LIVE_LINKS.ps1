$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$stripePath = Join-Path $root "stripe-created-links.local.json"
$jotformPath = Join-Path $root "jotform-created-links.local.json"

if (-not (Test-Path -LiteralPath $stripePath)) {
  throw "Missing $stripePath. Run .\CREATE_STRIPE_PAYMENT_LINKS.ps1 first, or create this JSON file with portalLabel/url entries."
}

if (-not (Test-Path -LiteralPath $jotformPath)) {
  throw "Missing $jotformPath. Run .\CREATE_JOTFORM_FORMS.ps1 first, or create this JSON file with secureWorkOrderIntake and missingInformationUpload entries."
}

$stripeLinks = @(Get-Content -LiteralPath $stripePath -Raw | ConvertFrom-Json)
$jotformLinks = @(Get-Content -LiteralPath $jotformPath -Raw | ConvertFrom-Json)

$secureIntakeUrl = ($jotformLinks | Where-Object { $_.key -eq "secureWorkOrderIntake" } | Select-Object -First 1).url
$secureUploadUrl = ($jotformLinks | Where-Object { $_.key -eq "missingInformationUpload" } | Select-Object -First 1).url

$packageLabelsByKey = @{
  starterReleaseBundle = 'Starter Release Bundle - $97'
  royaltyAccountSetup = 'Royalty Account Setup - $49'
  singleSongRegistration = 'Single Song Registration - $29'
  releasePack = 'Release Pack - $97'
  extraTrackAddOn = 'Extra Track Add-On - $5'
  catalogCleanupSprint = 'Catalog Cleanup Sprint - $200'
  monthlyRoyaltyAdminDesk = 'Monthly Royalty Admin Desk - $49/mo'
}

if (-not $secureIntakeUrl) {
  throw "Could not find secureWorkOrderIntake URL in $jotformPath."
}

if (-not $secureUploadUrl) {
  $secureUploadUrl = $secureIntakeUrl
}

function Set-JsonStringLine {
  param(
    [string]$Content,
    [string]$PropertyName,
    [string]$Value
  )

  $escapedProperty = [regex]::Escape($PropertyName)
  $escapedValue = $Value -replace '\\', '\\' -replace '"', '\"'
  return [regex]::Replace($Content, "($escapedProperty\s*:\s*)"".*?""", "`${1}`"$escapedValue`"")
}

function Set-PackageUrl {
  param(
    [string]$Content,
    [string]$PackageLabel,
    [string]$Url
  )

  $escapedLabel = [regex]::Escape($PackageLabel)
  $escapedUrl = $Url -replace '\\', '\\' -replace '"', '\"'
  return [regex]::Replace($Content, "(""$escapedLabel""\s*:\s*)"".*?""", "`${1}`"$escapedUrl`"")
}

function Update-PortalFile {
  param([string]$Path)

  $content = Get-Content -LiteralPath $Path -Raw
  $content = Set-JsonStringLine -Content $content -PropertyName "secureIntakeUrl" -Value $secureIntakeUrl
  $content = Set-JsonStringLine -Content $content -PropertyName "secureUploadUrl" -Value $secureUploadUrl

  foreach ($link in $stripeLinks) {
    $packageLabel = if ($link.key -and $packageLabelsByKey[$link.key]) { $packageLabelsByKey[$link.key] } else { $link.portalLabel }
    if (-not $packageLabel -or -not $link.url) {
      throw "Stripe link entry is missing a recognized key/portalLabel or url: $($link | ConvertTo-Json -Compress)"
    }
    $content = Set-PackageUrl -Content $content -PackageLabel $packageLabel -Url $link.url
  }

  Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
}

function Update-LiveLinksDoc {
  param([string]$Path)

  $content = Get-Content -LiteralPath $Path -Raw

  foreach ($link in $stripeLinks) {
    $packageLabel = if ($link.key -and $packageLabelsByKey[$link.key]) { $packageLabelsByKey[$link.key] } else { $link.portalLabel }
    if (-not $packageLabel -or -not $link.url) {
      throw "Stripe link entry is missing a recognized key/portalLabel or url: $($link | ConvertTo-Json -Compress)"
    }
    $label = [regex]::Escape($packageLabel)
    $content = [regex]::Replace(
      $content,
      "(- ${label}:\r?\n\s+- Live URL:).*",
      "`${1} $($link.url)"
    )
  }

  $content = [regex]::Replace($content, "(- Secure intake form:\r?\n\s+- Live URL:).*", "`${1} $secureIntakeUrl")
  $content = [regex]::Replace($content, "(- Secure upload link, if separate from intake:\r?\n\s+- Live URL:).*", "`${1} $secureUploadUrl")

  Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
}

function Update-TextTemplate {
  param(
    [string]$Path,
    [string]$Needle,
    [string]$Replacement
  )

  $content = Get-Content -LiteralPath $Path -Raw
  $content = $content.Replace($Needle, $Replacement)
  Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
}

Update-PortalFile -Path (Join-Path $root "index.html")
Update-PortalFile -Path (Join-Path $root "ARTIST_PORTAL_MVP.html")
Update-LiveLinksDoc -Path (Join-Path $root "LIVE_LINKS_TO_REPLACE.md")
Update-TextTemplate -Path (Join-Path $root "EMAIL_TEMPLATES.md") -Needle "[Secure Intake Form URL]" -Replacement $secureIntakeUrl
Update-TextTemplate -Path (Join-Path $root "MISSING_INFORMATION_REQUEST_TEMPLATE.md") -Needle "[Secure Upload Link]" -Replacement $secureUploadUrl

Write-Host "Applied live links to portal and template files."
Write-Host "Next: run powershell -ExecutionPolicy Bypass -File .\TEST_PORTAL.ps1"
Write-Host "Then: run powershell -ExecutionPolicy Bypass -File .\LAUNCH_AUDIT.ps1"
