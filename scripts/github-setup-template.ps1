<#
.SYNOPSIS
    GitHub Repository Setup Script
.DESCRIPTION
    Use this script to quickly initialize a Git repo for any new project and push to GitHub.
    Copy this script to your new project folder and run it.
.PARAMETER RepoName
    Name of the GitHub repository to create
.PARAMETER Description
    Short description of the project
.PARAMETER Visibility
    "public" or "private"
.PARAMETER GitUserName
    Your GitHub username
.EXAMPLE
    .\github-setup-template.ps1 -RepoName "my-new-project" -Description "My awesome project" -Visibility "public" -GitUserName "sharatmanikonda"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,

    [Parameter(Mandatory=$false)]
    [string]$Description = "",

    [Parameter(Mandatory=$false)]
    [ValidateSet("public", "private")]
    [string]$Visibility = "public",

    [Parameter(Mandatory=$false)]
    [string]$GitUserName = "sharatmanikonda"
)

# ── Check if already a git repo ──
if (Test-Path ".git") {
    Write-Host "⚠️  Git already initialized in this folder." -ForegroundColor Yellow
} else {
    git init
    git branch -M main
    Write-Host "✅ Git initialized." -ForegroundColor Green
}

# ── Check for .gitignore ──
if (!(Test-Path ".gitignore")) {
    Write-Host "⚠️  No .gitignore found. Creating a Python/ML template..." -ForegroundColor Yellow
@"
# Python
__pycache__/
*.py[cod]
*.so
*.egg-info/
dist/
build/
.venv/
venv/
env/

# IDE
.vscode/
.idea/
.DS_Store
Thumbs.db

# ML / Data
*.pt
*.pth
*.onnx
dataset/
data/
runs/

# Environment
.env
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
    Write-Host "✅ .gitignore created." -ForegroundColor Green
} else {
    Write-Host "✅ .gitignore exists." -ForegroundColor Green
}

# ── Check for README.md ──
if (!(Test-Path "README.md")) {
    Write-Host "⚠️  No README.md found. Creating a basic one..." -ForegroundColor Yellow
@"
# $RepoName

$Description
"@ | Out-File -FilePath "README.md" -Encoding utf8
    Write-Host "✅ README.md created." -ForegroundColor Green
} else {
    Write-Host "✅ README.md exists." -ForegroundColor Green
}

# ── Ask for GitHub Token ──
$token = Read-Host -Prompt "Enter your GitHub PAT (personal access token)" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

# ── Create repo on GitHub via API ──
$body = @{
    name        = $RepoName
    description = $Description
    private     = ($Visibility -eq "private")
    auto_init   = $false
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
        -Method POST `
        -Headers @{Authorization = "Bearer $plainToken"} `
        -Body $body `
        -ContentType "application/json"

    Write-Host "✅ GitHub repo created: $($response.html_url)" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create repository: $_" -ForegroundColor Red
    exit 1
}

# ── Stage, commit & push ──
git add -A
$status = git status --porcelain
if ($status) {
    git commit -m "Initial commit: $RepoName"
    Write-Host "✅ Files committed." -ForegroundColor Green
} else {
    Write-Host "⚠️  No files to commit." -ForegroundColor Yellow
}

git remote remove origin 2>$null
git remote add origin "https://$plainToken@github.com/$GitUserName/$RepoName.git"
git push -u origin main 2>&1

# Clean up token from URL
git remote set-url origin "https://github.com/$GitUserName/$RepoName.git"

Write-Host ""
Write-Host "🚀 Done! Repository ready at: https://github.com/$GitUserName/$RepoName" -ForegroundColor Green
