//
//  ViewController.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/4/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let size = CGSize(width: 800, height: 200)
    let position = CGPoint(x: 0, y: 10)
    let fontSize: CGFloat = 40
    var textContainerView: UIView!
    var imageView1: UIImageView!
    var contourView1: UIView!
    var imageView2: UIImageView!
    var contourView2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView1 = UIImageView(frame: CGRect(x: 0, y: 250,
                                               width: size.width, height: size.height))
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 500,
                                               width: size.width, height: size.height))
        contourView1 = UIView()
        contourView2 = UIView()

        configure()

        let index = 0
        let range: Range<Int> = index ..< (index + 1)
        let displayed = true

        loadTextView(index: index)
        loadFonts(displayed: displayed, range: range)
        loadImages(displayed: displayed, range: range)
    }

    // MARK: - Configuration

    func configure() {
        imageView1.layer.borderColor = UIColor.red.cgColor
        imageView1.layer.borderWidth = 1

        contourView1.layer.borderColor = UIColor.red.cgColor
        contourView1.layer.borderWidth = 1

        imageView2.layer.borderColor = UIColor.red.cgColor
        imageView2.layer.borderWidth = 1

        contourView2.layer.borderColor = UIColor.red.cgColor
        contourView2.layer.borderWidth = 1
    }

    // MARK: -

    func loadTextView(index: Int) {
        let fontNames = FontLoader().list()
        let fontName = fontNames[index]
        let content = "Grumpy wizards make toxic brew for the evil Queen and Jack. AV. \(fontName)"

        if textContainerView != nil {
            textContainerView.removeFromSuperview()
        }
        textContainerView = TextViewDriver(fontName: fontName, fontSize: fontSize, content: content)?.driverView()
        textContainerView.frame.origin.y = 20
        textContainerView.layer.borderWidth = 1
        textContainerView.layer.borderColor = UIColor.blue.cgColor
        view.addSubview(textContainerView)
    }

    func loadFonts(displayed: Bool, range: Range<Int>? = nil) {
        var fontNames = FontLoader().list()

        if let range = range {
            fontNames = Array(fontNames[range])
        }

        let _ = IOSDriver(fontNames: fontNames, fontSize: fontSize).contours { (image, contour) in
            if displayed {
                self.display(image, in: self.imageView2)
                self.displayTextContour(self.contourView2, at: contour, in: self.imageView2)
                debugPrint("iOS", contour)
            }
        }
    }

    func loadImages(displayed: Bool, range: Range<Int>? = nil) {
        var fontNames = FontLoader().list()

        if let range = range {
            fontNames = Array(fontNames[range])
        }

        let _ = WebDriver(fontNames: fontNames, fontSize: fontSize).contours { (image, contour) in
            if displayed {
                self.display(image, in: self.imageView1)
                self.displayTextContour(self.contourView1, at: contour, in: self.imageView1)
                debugPrint("Web", contour)
            }
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
}
