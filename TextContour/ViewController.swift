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
    let size = CGSize(width: 800, height: 200)
    let position = CGPoint(x: 0, y: 10)
    let fontSize: CGFloat = 40
    var containerView: UIView!
    var textView: UITextView!
    var imageView1: UIImageView!
    var contourView1: UIView!
    var imageView2: UIImageView!
    var contourView2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView = UIView(frame: CGRect(x: 0, y: 20, width: size.width, height: size.height))
        textView = UITextView(frame: CGRect(x: position.x, y: position.y, width: size.width - position.x, height: size.height - position.y))
        imageView1 = UIImageView(frame: CGRect(x: 0, y: 250,
                                               width: size.width, height: size.height))
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 500,
                                               width: size.width, height: size.height))

        configuration()

//        let range: Range<Int> = 21 ..< 22
//        let displayed = true

        let range: Range<Int>? = nil
        let displayed = false

        loadFonts(displayed: displayed, range: range)
        loadImages(displayed: displayed, range: range)
    }

    // MARK: - Configuration

    func configuration() {
        containerView.backgroundColor = .white

        textView.backgroundColor = .white
        textView.textContainerInset = .zero;
        textView.textContainer.lineFragmentPadding = 0;
        textView.layoutManager.delegate = self
        containerView.addSubview(textView)
        view.addSubview(containerView)

        imageView1.layer.borderColor = UIColor.red.cgColor
        imageView1.layer.borderWidth = 1

        contourView1 = UIView()
        contourView1.layer.borderColor = UIColor.red.cgColor
        contourView1.layer.borderWidth = 1

        imageView2.layer.borderColor = UIColor.red.cgColor
        imageView2.layer.borderWidth = 1

        contourView2 = UIView()
        contourView2.layer.borderColor = UIColor.red.cgColor
        contourView2.layer.borderWidth = 1
    }

    // MARK: -

    func loadFonts(displayed: Bool, range: Range<Int>? = nil) {
        var fonts = FontLoader().list()
        var contours: Dictionary<String, Dictionary<String, CGFloat>> = [:]

        if let range = range {
            fonts = Array(fonts[range])
        }

        for name in fonts {
            guard let font = UIFont(name: name, size: fontSize) else {
                contours[name] = ["x": 0,
                                  "y": 0,
                                  "width": 0,
                                  "height": 0]

                continue
            }

            let content = "Grumpy wizards make toxic brew for the evil Queen and Jack. AV. \(name)"
            let style = NSMutableParagraphStyle()
            let string = NSMutableAttributedString(string: content)

            style.maximumLineHeight = fontSize
            style.minimumLineHeight = fontSize
            string.addAttribute(NSParagraphStyleAttributeName, value:style,
                                range:NSMakeRange(0, string.length))

            textView.attributedText = string
            textView.font = font
            textView.textColor = .black

            let image = imageSync(of: containerView)
            let contour = textContourSync(of: image)

            contours[name] = ["x": contour.origin.x,
                              "y": contour.origin.y,
                              "width": contour.size.width,
                              "height": contour.size.height]

            if displayed {
                display(image, in: imageView2)
                displayTextContour(contourView2, at: contour, in: imageView2)
            }
        }

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            write(data, to: "contours-ios.json")
        }
    }

    func loadImages(displayed: Bool, range: Range<Int>? = nil) {
        var fonts = FontLoader().list()
        var contours: Dictionary<String, Dictionary<String, CGFloat>> = [:]

        if let range = range {
            fonts = Array(fonts[range])
        }

        for name in fonts {
            guard let url = Bundle.main.url(forResource: name, withExtension: "png"),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)?.blackAndWhite() else {
                    debugPrint("Failed to load", name)

                    continue
            }

            let contour = textContourSync(of: image)

            contours[name] = ["x": contour.origin.x,
                              "y": contour.origin.y,
                              "width": contour.size.width,
                              "height": contour.size.height]

            if displayed {
                display(image, in: imageView1)
                displayTextContour(contourView1, at: contour, in: imageView1)
            }
        }

        if let data = try? JSONSerialization.data(withJSONObject: contours, options: .prettyPrinted) {
            write(data, to: "contours-web.json")
        }
    }

    func write(_ data: Data, to filename: String) {
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }

        debugPrint(url)
        url.appendPathComponent(filename)
        do {
            try data.write(to: url, options: .atomic)
            debugPrint("Wrote to", filename)
        } catch {
            debugPrint("Failed to write to", filename)
        }
    }

    // MARK: - Display

    func display(_ image: UIImage, in imageView: UIImageView) {
        imageView.removeFromSuperview()
        imageView.image = image
        view.addSubview(imageView)
    }

    func displayTextContour(_ view: UIView, at rect: CGRect, in imageView: UIImageView) {
        view.removeFromSuperview()
        view.frame = rect
        imageView.addSubview(view)
    }

    // MARK: -

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

    func imageSync(of view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 1)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!.blackAndWhite()
        UIGraphicsEndImageContext()

        return image
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

    func textContourSync(of image: UIImage) -> CGRect {
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
        
        return CGRect(x: min.x, y: min.y, width: max.x - min.x + 1, height: max.y - min.y + 1)
    }
}

extension UIImage {
    
    func blackAndWhite() -> UIImage {
        let filter = GPUImageLuminanceThresholdFilter()
        
        filter.threshold = 0.5;
        
        return filter.image(byFilteringImage: self)
    }
}

extension ViewController: NSLayoutManagerDelegate {

    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSGlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int {
        print("glyphs", glyphs)
        print("props", props)
        print("charIndexes", charIndexes)

        return 0
    }

    func layoutManager(_ layoutManager: NSLayoutManager, boundingBoxForControlGlyphAt glyphIndex: Int, for textContainer: NSTextContainer, proposedLineFragment proposedRect: CGRect, glyphPosition: CGPoint, characterIndex charIndex: Int) -> CGRect {
        print("glyphIndex", glyphIndex)
        print("proposedRect", proposedRect)
        print("glyphPosition", glyphPosition)
        print("charIndex", charIndex)

        return proposedRect
    }
}
