//
//  WebDriver.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import Foundation
import UIKit

class WebDriver {
    let fontNames: [String]
    let fontSize: CGFloat

    init(fontNames: [String], fontSize: CGFloat) {
        self.fontNames = fontNames
        self.fontSize = fontSize
    }

    func contours(display: ((UIImage, CGRect) -> Void)? = nil) -> Contours {
        var contours: Contours = [:]

        for name in fontNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "png"),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)?.blackAndWhite() else {
                    debugPrint("Failed to load", name)

                    continue
            }

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
