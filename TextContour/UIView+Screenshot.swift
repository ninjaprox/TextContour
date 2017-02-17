//
//  UIView+Screenshot.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit

extension UIView {

    func image(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .utility).sync {
            let image = imageSync()

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    func imageSync() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!.blackAndWhite()
        UIGraphicsEndImageContext()

        return image
    }
}
