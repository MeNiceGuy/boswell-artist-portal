$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputPath = Join-Path $root "stripe-created-links.local.json"
$apiKey = $env:STRIPE_SECRET_KEY
$apiBase = if ($env:STRIPE_API_BASE) { $env:STRIPE_API_BASE.TrimEnd("/") } else { "https://api.stripe.com/v1" }

if (-not $apiKey) {
  throw "STRIPE_SECRET_KEY is not set. Create a restricted Stripe secret key with Products, Prices, and Payment Links write access, then run: `$env:STRIPE_SECRET_KEY='sk_live_...'; .\CREATE_STRIPE_PAYMENT_LINKS.ps1"
}

$headers = @{
  Authorization = "Bearer $apiKey"
}

$packages = @(
  @{
    key = "starterReleaseBundle"
    portalLabel = 'Starter Release Bundle - $97'
    productName = "Starter Release Bundle"
    amount = 9700
    mode = "one_time"
    description = "Account setup checklist, up to 12 songs, completion tracker, and 30-day follow-up."
  },
  @{
    key = "royaltyAccountSetup"
    portalLabel = 'Royalty Account Setup - $49'
    productName = "Royalty Account Setup"
    amount = 4900
    mode = "one_time"
    description = "Portal readiness review for BMI or ASCAP, The MLC, and SoundExchange."
  },
  @{
    key = "singleSongRegistration"
    portalLabel = 'Single Song Registration - $29'
    productName = "Single Song Registration Work Order"
    amount = 2900
    mode = "one_time"
    description = "One song registration/claim support across selected royalty portals."
  },
  @{
    key = "releasePack"
    portalLabel = 'Release Pack - $97'
    productName = "Release Pack"
    amount = 9700
    mode = "one_time"
    description = "Up to 12 songs with metadata review, portal support, completion summary, and 30-day follow-up."
  },
  @{
    key = "extraTrackAddOn"
    portalLabel = 'Extra Track Add-On - $5'
    productName = "Extra Track Add-On"
    amount = 500
    mode = "one_time"
    description = "One additional track beyond the Release Pack's included 12 songs."
  },
  @{
    key = "catalogCleanupSprint"
    portalLabel = 'Catalog Cleanup Sprint - $200'
    productName = "Catalog Cleanup Sprint"
    amount = 20000
    mode = "one_time"
    description = "Up to 25 older songs with catalog audit, portal support, confirmation tracker, and follow-up."
  },
  @{
    key = "monthlyRoyaltyAdminDesk"
    portalLabel = 'Monthly Royalty Admin Desk - $49/mo'
    productName = "Monthly Royalty Admin Desk"
    amount = 4900
    mode = "recurring"
    interval = "month"
    description = "Up to 2 single-song work orders per month, quarterly audit, and priority support."
  }
)

function Invoke-StripePost {
  param(
    [string]$Path,
    [hashtable]$Body,
    [string]$IdempotencyKey
  )

  $requestHeaders = $headers.Clone()
  if ($IdempotencyKey) {
    $requestHeaders["Idempotency-Key"] = $IdempotencyKey
  }

  Invoke-RestMethod `
    -Method Post `
    -Uri "$apiBase/$Path" `
    -Headers $requestHeaders `
    -ContentType "application/x-www-form-urlencoded" `
    -Body $Body
}

function New-StripePackageLink {
  param([hashtable]$Package)

  Write-Host "Creating Stripe product: $($Package.productName)"
  $product = Invoke-StripePost -Path "products" -IdempotencyKey "boswell-artist-portal-product-$($Package.key)" -Body @{
    name = $Package.productName
    description = $Package.description
    "metadata[portal_key]" = $Package.key
    "metadata[portal_label]" = $Package.portalLabel
  }

  $priceBody = @{
    currency = "usd"
    unit_amount = "$($Package.amount)"
    product = $product.id
    "metadata[portal_key]" = $Package.key
    "metadata[portal_label]" = $Package.portalLabel
  }

  if ($Package.mode -eq "recurring") {
    $priceBody["recurring[interval]"] = $Package.interval
  }

  Write-Host "Creating Stripe price: $($Package.portalLabel)"
  $price = Invoke-StripePost -Path "prices" -IdempotencyKey "boswell-artist-portal-price-$($Package.key)" -Body $priceBody

  $paymentLinkBody = @{
    "line_items[0][price]" = $price.id
    "line_items[0][quantity]" = "1"
    "metadata[portal_key]" = $Package.key
    "metadata[portal_label]" = $Package.portalLabel
  }

  Write-Host "Creating Stripe Payment Link: $($Package.portalLabel)"
  $paymentLink = Invoke-StripePost -Path "payment_links" -IdempotencyKey "boswell-artist-portal-payment-link-$($Package.key)" -Body $paymentLinkBody

  [pscustomobject]@{
    key = $Package.key
    portalLabel = $Package.portalLabel
    productId = $product.id
    priceId = $price.id
    paymentLinkId = $paymentLink.id
    url = $paymentLink.url
  }
}

$created = @()
foreach ($package in $packages) {
  $created += New-StripePackageLink -Package $package
}

$created | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $outputPath -Encoding UTF8

Write-Host ""
Write-Host "Created Stripe Payment Links:"
$created | Select-Object portalLabel, url | Format-Table -AutoSize
Write-Host ""
Write-Host "Saved local link output to $outputPath"
Write-Host "Next: run .\APPLY_LIVE_LINKS.ps1 after Jotform links also exist."
