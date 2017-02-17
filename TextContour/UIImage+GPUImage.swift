//
//  UIImage+GPUImage.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit
import GPUImage

extension UIImage {

    func blackAndWhite() -> UIImage {
        let filter = GPUImageLuminanceThresholdFilter()

        filter.threshold = 0.5;

        return filter.image(byFilteringImage: self)
    }
}
