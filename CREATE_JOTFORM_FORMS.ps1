$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$specPath = Join-Path $root "jotform-form-specs.json"
$outputPath = Join-Path $root "jotform-created-links.local.json"
$apiKey = $env:JOTFORM_API_KEY
$apiBase = if ($env:JOTFORM_API_BASE) { $env:JOTFORM_API_BASE.TrimEnd("/") } else { "https://api.jotform.com" }

if (-not $apiKey) {
  throw "JOTFORM_API_KEY is not set. Create a Jotform API key in Account > API, then run: `$env:JOTFORM_API_KEY='your-key'; .\CREATE_JOTFORM_FORMS.ps1"
}

if (-not (Test-Path -LiteralPath $specPath)) {
  throw "Missing form spec: $specPath"
}

$spec = Get-Content -LiteralPath $specPath -Raw | ConvertFrom-Json
$headers = @{ APIKEY = $apiKey }

try {
  $user = Invoke-RestMethod -Method Get -Uri "$apiBase/user" -Headers $headers
  if (-not $user.content.username) {
    throw "Jotform did not return account details."
  }
} catch {
  throw "Jotform API key could not read account details. Create a valid API key in Account > API, then rerun this script. $($_.Exception.Message)"
}

function Convert-ToJotformQuestion {
  param(
    [object]$Field,
    [int]$Order
  )

  $typeMap = @{
    fullName = "control_fullname"
    shortText = "control_textbox"
    longText = "control_textarea"
    email = "control_email"
    phone = "control_phone"
    dropdown = "control_dropdown"
    multipleChoice = "control_checkbox"
    yesNo = "control_radio"
    date = "control_datetime"
    fileUpload = "control_fileupload"
    checkbox = "control_checkbox"
  }

  $question = [ordered]@{
    type = $typeMap[$Field.type]
    text = $Field.label
    order = $Order
    name = if ($Field.name) { $Field.name } else { ($Field.label -replace "[^A-Za-z0-9]+", " ").Trim().Split(" ") -join "" }
    required = if ($Field.required) { "Yes" } else { "No" }
  }

  if ($Field.options) {
    $question.options = ($Field.options -join "|")
  }

  if ($Field.type -eq "yesNo") {
    $question.options = "Yes|No"
  }

  if ($Field.type -eq "checkbox" -and -not $Field.options) {
    $question.options = "I agree"
  }

  return $question
}

function New-JotformForm {
  param([object]$FormSpec)

  $questions = [ordered]@{}
  $order = 1
  $lastSection = ""

  foreach ($field in $FormSpec.fields) {
    if ($field.section -ne $lastSection) {
      $questions["q$order"] = [ordered]@{
        type = "control_head"
        text = $field.section
        order = $order
        name = (($field.section -replace "[^A-Za-z0-9]+", " ").Trim().Split(" ") -join "")
      }
      $order++
      $lastSection = $field.section
    }

    $questions["q$order"] = Convert-ToJotformQuestion -Field $field -Order $order
    $order++
  }

  $payload = @{
    questions = ($questions | ConvertTo-Json -Depth 8 -Compress)
    properties = (@{
      title = $FormSpec.title
      thanktext = $FormSpec.confirmationMessage
      activeRedirect = "thanktext"
      sendpostdata = "No"
    } | ConvertTo-Json -Compress)
  }

  try {
    $response = Invoke-RestMethod -Method Post -Uri "$apiBase/user/forms" -Headers $headers -Body $payload
  } catch {
    $details = if ($_.ErrorDetails.Message) { $_.ErrorDetails.Message } else { $_.Exception.Message }
    throw "Jotform rejected form creation for '$($FormSpec.title)'. Create this form manually from JOTFORM_FORMS.md, or use an API key/account that allows form creation. API response: $details"
  }
  $formId = if ($response.content.id) { $response.content.id } elseif ($response.content) { $response.content } else { $response.id }

  if (-not $formId) {
    throw "Jotform did not return a form ID for '$($FormSpec.title)'. Raw response: $($response | ConvertTo-Json -Depth 8)"
  }

  [pscustomobject]@{
    key = $FormSpec.key
    title = $FormSpec.title
    formId = "$formId"
    url = "https://form.jotform.com/$formId"
  }
}

$created = @()
foreach ($form in $spec.forms) {
  Write-Host "Creating Jotform: $($form.title)"
  $created += New-JotformForm -FormSpec $form
}

$created | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $outputPath -Encoding UTF8

Write-Host ""
Write-Host "Created forms:"
$created | Format-Table -AutoSize
Write-Host ""
Write-Host "Saved local link output to $outputPath"
Write-Host "Next: paste the intake and upload URLs into portalConfig in index.html and ARTIST_PORTAL_MVP.html."
