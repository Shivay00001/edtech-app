# Flutter Setup and Build Script for EdTech App

Write-Host "EdTech App - Setup and Build" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

cd c:\VisionQuantech-Projects\edtech-app

# Check Flutter
Write-Host "`nChecking Flutter installation..." -ForegroundColor Cyan
flutter --version

# Clean previous builds
Write-Host "`nCleaning previous builds..." -ForegroundColor Cyan
flutter clean

# Get dependencies
Write-Host "`nGetting dependencies..." -ForegroundColor Cyan
flutter pub get

# Run code generation if needed
Write-Host "`nGenerating code..." -ForegroundColor Cyan
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze code
Write-Host "`nAnalyzing code..." -ForegroundColor Cyan
flutter analyze

# Check for issues
Write-Host "`nRunning Flutter doctor..." -ForegroundColor Cyan
flutter doctor

Write-Host "`n✓ EdTech App setup complete!" -ForegroundColor Green
Write-Host "`nAvailable commands:" -ForegroundColor Yellow
Write-Host "  flutter run -d chrome        # Run in web browser" -ForegroundColor White
Write-Host "  flutter run -d windows       # Run desktop app" -ForegroundColor White
Write-Host "  flutter build apk           # Build Android APK" -ForegroundColor White
Write-Host "  flutter build web           # Build for web" -ForegroundColor White
