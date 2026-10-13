@echo off
cd /d "%~dp0"

if not exist ".git" (
    echo Initializing git repository...
    git init
)

git config user.name "Sxnjxy25"
git config user.email "sxnjxy25@gmail.com"
git branch -M main

git remote remove origin 2>nul
git remote add origin https://github.com/Sxnjxy25/Medicen.git

echo Staging files...
git add .

echo Committing changes...
git commit -m "Update database connection string to Render PostgreSQL"

echo Pushing to GitHub...
git push -u origin main

echo Done!
pause
