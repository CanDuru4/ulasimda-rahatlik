[![Swift Version][swift-image]][swift-url]

# Kolay Ulaşım

Kolay Ulaşım monitors temperature and passenger crowding on public transportation, alongside vehicle locations. Its teal app icon combines a thermometer and passengers to represent those measurements.
<br />
<p align="center">
  <a href="https://canduru.net">
    <img src="https://i.ibb.co/rHFr92y/Original-resized.png" alt="Logo" width="221" height="90">
  </a>
</p>

## Features

- [x] Live Bus Locations (updated every 10 seconds)
- [x] View Temperature of the Bus
- [x] View Status of Bus for Crowd

## Requirements

- iOS 15.0+
- Xcode 27

## Installation

Open the `.xcodeproj` directly in Xcode 27 or later. Swift Package Manager resolves the pinned dependencies automatically; CocoaPods is no longer required. Firebase 12.19.1 requires iOS 15 or later (SponsorApp retains iOS 16). Test targets require iOS 17 or later.

Supply the app's existing `GoogleService-Info.plist` through the app target before using Firebase services. Missing configuration shows a setup screen without accessing Firebase.

## Meta

Can Duru , canduru2004@gmail.com, support@canduru.net


[https://github.com/CanDuru4](https://github.com/CanDuru4)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
