//
//  TextContourTests.swift
//  TextContourTests
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import XCTest
@testable import TextContour

class TextContourTests: XCTestCase {
    let fontSize: CGFloat = 40
    let iosFilename = "contours-ios.json"
    let webFilename = "contours-web.json"
    var fontNames: [String]!

    override func setUp() {
        super.setUp()

        fontNames = FontLoader().list()
    }

    override func tearDown() {
        fontNames.removeAll()
        fontNames = nil

        super.tearDown()
    }

    func test_contours_ios() {
        let contours = IOSDriver(fontNames: fontNames, fontSize: fontSize).contours()

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            Writter().write(data, to: self.iosFilename)
        }

        XCTAssert(true)
    }

    func test_contours_web() {
        let contours = WebDriver(fontNames: fontNames, fontSize: fontSize).contours()

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            Writter().write(data, to: webFilename)
        }

        XCTAssert(true)
    }
}
