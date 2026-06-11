param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [string]$Content,

    [string]$ContentFile,

    [switch]$Append,

    [string]$CommitMessage = "Update $FilePath",

    [switch]$NoPush
)

$ErrorActionPreference = "Stop"

function Stop-WithMessage {
    param([string]$Message)
    Write-Error $Message
    exit 1
}

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
    Stop-WithMessage "This script must be run inside a Git repository."
}

Set-Location $repoRoot

if ([string]::IsNullOrWhiteSpace($Content) -and [string]::IsNullOrWhiteSpace($ContentFile)) {
    Stop-WithMessage "Provide either -Content or -ContentFile."
}

if (-not [string]::IsNullOrWhiteSpace($Content) -and -not [string]::IsNullOrWhiteSpace($ContentFile)) {
    Stop-WithMessage "Use either -Content or -ContentFile, not both."
}

$targetPath = Join-Path $repoRoot $FilePath
$targetFullPath = [System.IO.Path]::GetFullPath($targetPath)
$repoFullPath = [System.IO.Path]::GetFullPath($repoRoot)

if (-not $targetFullPath.StartsWith($repoFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
    Stop-WithMessage "FilePath must point to a file inside the repository."
}

if ($ContentFile) {
    if (-not (Test-Path -LiteralPath $ContentFile -PathType Leaf)) {
        Stop-WithMessage "ContentFile was not found: $ContentFile"
    }

    $newContent = Get-Content -LiteralPath $ContentFile -Raw
} else {
    $newContent = $Content
}

$targetDirectory = Split-Path -Parent $targetFullPath
if ($targetDirectory -and -not (Test-Path -LiteralPath $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory | Out-Null
}

if ($Append) {
    Add-Content -LiteralPath $targetFullPath -Value $newContent
} else {
    Set-Content -LiteralPath $targetFullPath -Value $newContent
}

git add -- $FilePath

$stagedChanges = git diff --cached --name-only
if (-not $stagedChanges) {
    Write-Host "No changes to commit for $FilePath."
    exit 0
}

git commit -m $CommitMessage

if ($NoPush) {
    Write-Host "Committed changes locally. Push skipped because -NoPush was used."
} else {
    git push
}
