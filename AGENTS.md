# Ulaşımda Rahatlık

Demo iOS app (home-screen name "Kolay Ulaşım") that shows city buses on a MapKit map with each bus's in-vehicle temperature and crowd level, polled from a Firebase Realtime Database. The data comes from Arduino sensors that are not part of this repo. Status: portfolio project from 2023. It was modernized in September 2026 (SPM, current Xcode) and gets only occasional maintenance. Stack: Swift 5, UIKit (programmatic Auto Layout, no storyboards except the launch screen), MapKit, CoreLocation, Firebase 12.19.1 via Swift Package Manager. The repo is public.

## Repo map

- `Ulasimda Rahatlik.xcodeproj/`: the only project to open. It has one shared scheme, `Ulasimda Rahatlik`. SPM pins live in `project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.
- `UlasimdaRahatlik/Base Files/AppDelegate.swift`: Firebase bootstrap. It only configures Firebase when `GoogleService-Info.plist` is in the bundle and the `-FirebaseSetupPreview` launch argument is absent.
- `UlasimdaRahatlik/Base Files/SceneDelegate.swift`: builds the window in code. If Firebase is not configured, it shows a "Firebase setup required" screen. Otherwise it shows `ViewController`.
- `UlasimdaRahatlik/ViewController.swift`: nearly all app logic. It covers the map, zoom and recenter buttons, bus annotations, the `BusData()` Firebase read, and the 10 s `Timer` poll.
- `UlasimdaRahatlik/Helper/`: `LocationManager` (singleton, one-shot location) and `CustomPointAnnotation` (in `CustomAnnotation.swift`).
- `Ulasimda RahatlikTests/`: unit test target. It holds only the Xcode template and has no real tests.
- `Ulasimda RahatlikUITests/`: UI tests. They launch with `-FirebaseSetupPreview` and assert on the setup screen.
- `design-assets/banner/`: the Canduru banner. `CHANGELOG.md` has not been updated since 2023.
- A local, untracked `Ulasimda Rahatlik.xcworkspace/` folder may exist. It holds only ignored `xcuserdata` (plus an empty `xcshareddata` directory), so `git status` lists it as ignored. The tracked workspace was deliberately removed, so do not recreate or commit it.

## Commands

```bash
xcodebuild -list -project "Ulasimda Rahatlik.xcodeproj"
xcodebuild -project "Ulasimda Rahatlik.xcodeproj" -scheme "Ulasimda Rahatlik" \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project "Ulasimda Rahatlik.xcodeproj" -scheme "Ulasimda Rahatlik" \
  -destination 'platform=iOS Simulator,name=<installed iPhone>' test
```

- The README requires Xcode 27 or later (the build was verified on 27.0). Firebase resolves through SPM on the first build.
- `test` needs an installed iOS 17+ simulator runtime, because the test targets have a deployment target of 17.0. The app itself targets iOS 15.0.
- There is no linter, no CI, and no release automation. Signing and running happen from Xcode.

## Firebase and secrets

- `UlasimdaRahatlik/GoogleService-Info.plist` is git-ignored but referenced in the app target's Copy Bundle Resources. Each developer supplies their own copy. Never commit it.
- An earlier copy was purged from git history with a rewrite in 2026-09, so never re-add it and never force-push old history back.
- `.gitignore` also blocks `Keys.plist` and `.env*`. The project uses no environment variables.
- The app reads the `Busses` node. Each child has `name` (String), `temperature`, `crowd`, `latitude` and `longitude` (numbers). The README has the full schema.
- The crowd thresholds are hard-coded in `busLocations()`: above 50000 is "Çok Kalabalık", above 25000 is "Kalabalık", and anything else is "Kalabalık Değil".
- The linked Firebase products are `FirebaseCore`, `FirebaseDatabase` and `FirebaseAnalytics`.

## Conventions and gotchas

- UI is written in code with `NSLayoutConstraint.activate` and `//MARK:` sections. User-facing strings are in Turkish.
- `BusData()` replaces the whole `busses` array on each poll. Its `didSet` observer removes the old `"busAnnotation"` pins before redrawing. Malformed records and invalid coordinates are skipped silently, and a failed read keeps the last snapshot.
- Both UI test files (`Ulasimda_RahatlikUITests.swift` and `Ulasimda_RahatlikUITestsLaunchTests.swift`) match the exact setup-screen text in `SceneDelegate.swift`. Change all three together.
- `-FirebaseSetupPreview` is the only supported way to run the app without Firebase in tests. Keep the guard in `AppDelegate`.
- The repo follows the owner's portfolio README standard. Keep the section order and the "Can Duru — canduru.net" author line when editing `README.md`.

## Validation placement and reuse (owner update 2026-10-26)

- Follow the global Claude/Codex test policy and `~/Developer/personal/mac-mini/validation-economy/README.md` and `COVERAGE.md`. Focus first; full coverage only when the changed inputs require it. Docs-only policy edits need no application suite or deploy.
- Use `~/Developer/personal/mac-mini/validation-economy/remote-run.py` as the first choice for compatible heavy committed-source Python/Node checks. It defaults to `gaming-pc` and handles connection and bounded Wake-on-LAN automatically; call it directly without a separate online check or asking the owner each time. Match the pinned runtime and locked dependencies, bound actual workers, and preserve repo data-export restrictions. Never export credentials, production data, signing keys or uncommitted work.
- The PC pool shares eight CPU slots and 24 GiB across isolated jobs with zero test swap; retain automatic job cleanup, the 8 GiB package-cache budget and 128 GiB virtual-disk cap. Brain is an explicit secondary route (`--runner brain`) when compatible, capped at two CPUs and 4 GiB together. If the PC remains unavailable after bounded wake/connect, report the blocker; never silently start the same work on the Mini or replay an uncertain submitted job.
- Xcode, Swift, simulator, signing and device checks stay on the Mini. The PC Linux runner has no Apple toolchain; only compatible ancillary Python/Node checks are eligible.
- For work that must run on the Mini: manual heavy commands use `repo-run.py --repo <absolute checkout> --profile <profile> -- <command>` from the shared helper; choose from native for the actual tool. Tiny syntax checks need no reservation. Bound tool workers and reserve separate heavy phases.
- Reuse only supported receipts with matching source, coverage, dependencies, runtime/platform and relevant environment. Preserve passed unaffected batches; count remote results only when the owning gate aggregates them. Receipts do not replace required build artifacts or OS/device/browser proof. Split or offload an impossible reservation instead of waiting indefinitely; only stop your own obsolete jobs. Existing gates need explicit remote routing and matching-result aggregation; this instruction does not automatically move unintegrated commands.
