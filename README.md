# DailyCalc

DailyCalc is an offline-first Flutter utility app for everyday money and life calculations.

## Current release candidate

Version: V0.7

Core calculators include expense, simple interest, compound interest, monthly/Vaddi interest, EMI, loan prepayment, savings, GST, discount, fuel, electricity, age, date difference, SIP, FD, RD, inflation, unit-price comparison, bill split, and rent increase.

The app is designed to work primarily on-device with no backend or cloud database required for core calculations. Development builds use Google test ads only.

## Build

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

A GitHub Actions workflow will be used to produce downloadable APK and AAB artifacts.
