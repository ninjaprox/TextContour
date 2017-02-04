//
//  ViewController.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/4/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    var textView: UITextView!
    var imageView: UIImageView!
    var contourView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView(frame: CGRect(x: 10, y: 100, width: 300, height: 200))
        textView.font = UIFont(name: "Arial", size: 23)
        textView.textColor = .black
        textView.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        view.addSubview(textView)

        image(of: textView) {
            self.display($0)
            self.textContour(of: $0) {
                self.displayTextContour(at: $0)
            }
        }
    }

    func display(_ image: UIImage) {
        if imageView != nil {
            imageView.removeFromSuperview()
        }
        imageView = UIImageView(frame: CGRect(x: 10, y: 400,
                                              width: image.size.width, height:image.size.height))
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = image
        view.addSubview(imageView)
    }

    func displayTextContour(at rect: CGRect) {
        guard imageView != nil else {
            return
        }

        if contourView != nil {
            contourView.removeFromSuperview()
        }
        contourView = UIView(frame: rect)
        contourView.layer.borderColor = UIColor.red.cgColor
        contourView.layer.borderWidth = 1
        imageView.addSubview(contourView)
    }

    func image(of view: UIView, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .utility).sync {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 1)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()!.blackAndWhite()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    func textContour(of image: UIImage, completion: @escaping (CGRect) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let pixelData = image.cgImage!.dataProvider!.data
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            let width = image.size.width
            let height = image.size.height
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
            DispatchQueue.main.async {
                completion(CGRect(x: min.x, y: min.y, width: max.x - min.x + 1, height: max.y - min.y + 1))
            }
        }
    }
}

extension UIImage {

    func blackAndWhite() -> UIImage {
        let filter = GPUImageLuminanceThresholdFilter()

        filter.threshold = 0.5;
        
        return filter.image(byFilteringImage: self)
    }
}
