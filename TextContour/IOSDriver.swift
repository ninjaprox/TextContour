//
//  IOSDriver.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import Foundation
import UIKit

class IOSDriver {
    let fontNames: [String]
    let fontSize: CGFloat

    init(fontNames: [String], fontSize: CGFloat) {
        self.fontNames = fontNames
        self.fontSize = fontSize
    }

    func contours(display: ((UIImage, CGRect) -> Void)? = nil) -> Contours {
        var contours: Contours = [:]

        for name in fontNames {
            let content = "Grumpy wizards make toxic brew for the evil Queen and Jack. AV. \(name)"

            guard let driver = TextViewDriver(fontName: name, fontSize: fontSize, content: content) else {
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
            display?(image, contour)
        }

        return contours
    }

    func data() -> Data? {
        let contours = self.contours()

        return try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted)
    }
}
