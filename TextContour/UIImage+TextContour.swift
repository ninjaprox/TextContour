//
//  UIImage+TextContour.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit

extension UIImage {

    func textContour(completion: @escaping (CGRect) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let contour = self.textContourSync()

            DispatchQueue.main.async {
                completion(contour)
            }
        }
    }

    func textContourSync() -> CGRect {
        let pixelData = cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let width = size.width
        let height = size.height
        var min = CGPoint(x: width, y: height)
        var max = CGPoint.zero

        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let pixelInfo: Int = ((Int(width) * y) + x) * 4
                let r = data[pixelInfo]
                let g = data[pixelInfo + 1]
                let b = data[pixelInfo + 2]

                if r == 0 && g == 0 && b == 0 {
                    if CGFloat(x) > max.x {
                        max.x = CGFloat(x)
                    }
                    if CGFloat(y) > max.y {
                        max.y = CGFloat(y)
                    }
                    if CGFloat(x) < min.x {
                        min.x = CGFloat(x)
                    }
                    if CGFloat(y) < min.y {
                        min.y = CGFloat(y)
                    }
                }
            }
        }

        return CGRect(x: min.x, y: min.y, width: max.x - min.x + 1, height: max.y - min.y + 1)
    }
}
