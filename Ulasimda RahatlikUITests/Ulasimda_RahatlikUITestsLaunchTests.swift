//
//  Ulasimda_RahatlikUITestsLaunchTests.swift
//  Ulasimda RahatlikUITests
//
//  Created by Can Duru on 7.01.2023.
//

import XCTest

final class Ulasimda_RahatlikUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-FirebaseSetupPreview"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Firebase setup required. Add this app's GoogleService-Info.plist to the app target and rebuild."].waitForExistence(timeout: 10))

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
