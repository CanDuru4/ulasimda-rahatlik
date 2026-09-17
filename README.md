# Ulaşımda Rahatlık

[![Swift](https://img.shields.io/badge/Swift-5.0-F05138?style=flat&logo=swift&logoColor=white)](https://swift.org/)
[![UIKit](https://img.shields.io/badge/UIKit-MapKit-2396F3?style=flat&logo=apple&logoColor=white)](https://developer.apple.com/documentation/mapkit)
[![iOS](https://img.shields.io/badge/iOS-15.0%2B-000000?style=flat&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Firebase](https://img.shields.io/badge/Firebase-12.19.1-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/docs/ios/setup)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat)](LICENSE)

Ulaşımda Rahatlık ("comfort in transit") is a demo iOS app that puts city buses on a live map together with the temperature inside each bus and how crowded it is. Sensors wired to an Arduino UNO in the vehicle publish those readings to a Firebase Realtime Database; the app reads them back every 10 seconds and annotates each bus on a MapKit map. On the home screen the app is named Kolay Ulaşım. It is a proof-of-concept portfolio project for a minimal IoT-to-mobile pipeline; the Arduino firmware and the Firebase project are not part of this repository.

## Features

- Live bus locations on a MapKit map, refreshed every 10 seconds
- Temperature of each bus shown in the annotation callout
- Crowd level per bus, shown with the in-app Turkish labels `Kalabalık Değil` (not crowded), `Kalabalık` (crowded) and `Çok Kalabalık` (very crowded)
- User location with a recenter button and custom zoom in/out controls

## Tech stack

| Layer | What is used |
| --- | --- |
| App | Swift 5.0, UIKit with programmatic Auto Layout, MapKit, CoreLocation |
| Backend | Firebase Realtime Database (`FirebaseCore`, `FirebaseDatabase`, `FirebaseFirestore`) |
| Dependencies | Swift Package Manager (Firebase 12.19.1) |
| Hardware (external) | Arduino UNO with a temperature sensor and a camera |

## Getting started

### Prerequisites

- macOS with Xcode 27 or later
- iOS 15.0 or later on a simulator or device (test targets require iOS 17 or later)
- A Firebase project with Realtime Database enabled

### Installation

1. Clone the repository.

   ```bash
   git clone https://github.com/CanDuru4/ulasimda-rahatlik.git
   ```

2. Open `Ulasimda Rahatlik.xcodeproj` in Xcode. Swift Package Manager resolves the pinned Firebase packages automatically.
3. Add your own Firebase config file (see [Configuration](#configuration)).
4. Run the shared `Ulasimda Rahatlik` scheme. Without the Firebase config file the app shows a setup screen instead of calling Firebase. The app asks for location access on first launch.

### Configuration

No environment variables are used. One credential file is required and is git-ignored, so you must supply your own:

| File | Where it goes | How to get it |
| --- | --- | --- |
| `GoogleService-Info.plist` | `UlasimdaRahatlik/` | Firebase console → Project settings → your iOS app |

Never commit that file, or any `Keys.plist`, `.env` or certificate; `.gitignore` already blocks them.

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

`crowd` is the raw sensor counter: above 50000 the bus is labelled very crowded, above 25000 crowded, otherwise not crowded.

## Project structure

```
.
├── Ulasimda Rahatlik.xcodeproj/     Xcode project to open (Swift Package Manager)
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
├── CHANGELOG.md                     Version history
└── LICENSE
```

## Deployment

There is no CI pipeline and no automated release; the app is built, signed and run from Xcode.

## Screenshots

No screenshots are committed yet.

## License

MIT. See [LICENSE](LICENSE).

## Author

Can Duru — [canduru.net](https://canduru.net)
