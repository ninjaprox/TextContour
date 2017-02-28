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
    var fonts: [String]!

    override func setUp() {
        super.setUp()

        fonts = FontLoader().list()
    }

    override func tearDown() {
        fonts.removeAll()
        fonts = nil

        super.tearDown()
    }

    func test_contours_ios() {
        var contours: Dictionary<String, Dictionary<String, CGFloat>> = [:]

        for name in self.fonts {
            let content = "Grumpy wizards make toxic brew for the evil Queen and Jack. AV. \(name)"

            guard let driver = TextViewDriver(fontName: name, fontSize: self.fontSize, content: content) else {
                contours[name] = ["x": 0,
                                  "y": 0,
                                  "width": 0,
                                  "height": 0]

                continue
            }

            let image = driver.image()
            let contour = image.textContourSync()

            contours[name] = ["x": contour.origin.x,
                              "y": contour.origin.y,
                              "width": contour.size.width,
                              "height": contour.size.height]
        }

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            Writter().write(data, to: self.iosFilename)
        }

        XCTAssert(true)
    }

    func test_contours_web() {
        var contours: Dictionary<String, Dictionary<String, CGFloat>> = [:]

        for name in fonts {
            guard let url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "Images"),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)?.blackAndWhite() else {
                    debugPrint("Failed to load image", name)

                    continue
            }

            let contour = image.textContourSync()

            contours[name] = ["x": contour.origin.x,
                              "y": contour.origin.y,
                              "width": contour.size.width,
                              "height": contour.size.height]
        }

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            Writter().write(data, to: webFilename)
        }

        XCTAssert(true)
    }
}
