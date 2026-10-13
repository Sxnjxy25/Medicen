Set-Location -Path $PSScriptRoot

if (-not (Test-Path ".git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
}

# Set repository local git identity if not configured
git config user.name "Sxnjxy25"
git config user.email "sxnjxy25@gmail.com"

git branch -M main

# Set remote origin URL
$remoteExists = git remote
if ($remoteExists -contains "origin") {
    git remote set-url origin https://github.com/Sxnjxy25/Medicen.git
} else {
    git remote add origin https://github.com/Sxnjxy25/Medicen.git
}

Write-Host "Staging files..." -ForegroundColor Yellow
git add .

Write-Host "Committing changes..." -ForegroundColor Yellow
git commit -m "Update database connection string to Render PostgreSQL"

Write-Host "Pushing changes to GitHub repository (https://github.com/Sxnjxy25/Medicen)..." -ForegroundColor Yellow
git push -u origin main

Write-Host "Done!" -ForegroundColor Green
