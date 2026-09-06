# Ulaşımda Rahatlık

[![Platform](https://img.shields.io/badge/platform-iOS%2014.0%2B-lightgrey.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg)](https://swift.org/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

<p align="center">
  <a href="https://canduru.net">
    <img src="docs/assets/canduru-banner.png" alt="Can Duru" width="221" height="90">
  </a>
</p>

**Ulaşımda Rahatlık** ("comfort in transit") is a demo iOS app that puts city buses on a live map together with the temperature inside each bus and how crowded it is. Sensors wired to an Arduino UNO in the vehicle publish those readings to a Firebase Realtime Database; the app reads them back every 10 seconds and annotates each bus on a MapKit map. It is a proof-of-concept / portfolio project for anyone interested in a minimal IoT-to-mobile pipeline — the Arduino firmware and the Firebase project itself are **not** part of this repository.

## Features

- [x] Live bus locations on a MapKit map, refreshed every 10 seconds
- [x] Temperature of each bus shown in the annotation callout
- [x] Crowd level per bus (`Kalabalık Değil` / `Kalabalık` / `Çok Kalabalık`)
- [x] User location with a recenter button and custom zoom in/out controls

## Tech stack

| Layer | What is used |
| --- | --- |
| App | Swift 5.0, UIKit with programmatic Auto Layout, MapKit, CoreLocation |
| Backend | Firebase Realtime Database (`FirebaseCore`, `FirebaseDatabase`, `FirebaseFirestore`) |
| Dependencies | CocoaPods |
| Hardware (external) | Arduino UNO with a temperature sensor and a camera |

## Getting started

### Prerequisites

- macOS with Xcode 14.3.1 or newer
- iOS 14.0+ device or simulator
- [CocoaPods](https://cocoapods.org/)
- A Firebase project with Realtime Database enabled

### Install

1. Clone the repository.

   ```bash
   git clone https://github.com/CanDuru4/UlasimdaRahatlik.git
   ```

2. Create a `Podfile` next to `Ulasimda Rahatlik.xcodeproj` (it is not checked in) and install the pods:

   ```ruby
   platform :ios, '14.0'
   use_frameworks!

   target 'Ulasimda Rahatlik' do
     pod 'FirebaseAnalytics'
     pod 'FirebaseAuth'
     pod 'FirebaseFirestore'
     pod 'Firebase/Database'
   end
   ```

   ```bash
   pod install
   ```

3. Add your own Firebase config file (see [Configuration](#configuration)).

4. Open the generated `Ulasimda Rahatlik.xcworkspace` and run the `Ulasimda Rahatlik` scheme. The app asks for location access on first launch (`NSLocationWhenInUseUsageDescription`).

### Configuration

No environment variables are used. One credential file is required and is deliberately git-ignored, so you must supply your own:

| File | Where it goes | How to get it |
| --- | --- | --- |
| `GoogleService-Info.plist` | `UlasimdaRahatlik/` | Firebase console → Project settings → your iOS app |

Never commit that file, or any `Keys.plist`, `.env` or certificate — `.gitignore` already blocks them.

### Expected database shape

`ViewController.BusData()` reads the `Busses` node of the Realtime Database and expects one child per vehicle:

```
Busses/
  <busId>/
    name:        String
    temperature: Int
    crowd:       Int
    latitude:    Double
    longitude:   Double
```

`crowd` is the raw sensor counter: above 50000 the bus is labelled `Çok Kalabalık`, above 25000 `Kalabalık`, otherwise `Kalabalık Değil`.

## Project structure

```
.
├── Ulasimda Rahatlik.xcodeproj/     Xcode project (CocoaPods-integrated)
├── UlasimdaRahatlik/
│   ├── Base Files/                  AppDelegate (Firebase bootstrap), SceneDelegate
│   ├── Base.lproj/                  LaunchScreen.storyboard
│   ├── Helper/                      LocationManager, CustomPointAnnotation
│   ├── Assets.xcassets/             App icon and accent colour
│   ├── Photos/                      In-app image assets
│   ├── ViewController.swift         Map, controls, annotations, Firebase reads
│   └── Info.plist
├── Ulasimda RahatlikTests/          Unit test target (template)
├── Ulasimda RahatlikUITests/        UI test target (template)
├── docs/assets/                     README images
├── CHANGELOG.md
└── LICENSE
```

## Deployment

There is no CI pipeline and no automated release in this repository; the app is built, signed and run from Xcode. Version history lives in [CHANGELOG.md](CHANGELOG.md).

## License

Released under the [MIT License](LICENSE).

## Meta

Can Duru — [canduru.net](https://canduru.net) — canduru2004@gmail.com, support@canduru.net

[https://github.com/CanDuru4](https://github.com/CanDuru4)
