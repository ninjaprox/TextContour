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

        let index = 20
        let range: Range<Int> = index ..< (index + 1)
        let displayed = true

        loadFonts(displayed: displayed, range: range)
        loadImages(displayed: displayed, range: range)
    }

    // MARK: - Configuration

    func configuration() {
        containerView.backgroundColor = .white

        textView.backgroundColor = .white
        textView.textContainerInset = .zero;
        textView.textContainer.lineFragmentPadding = 0;
        //        textView.layoutManager.delegate = self
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
        var fontNames = FontLoader().list()

        if let range = range {
            fontNames = Array(fontNames[range])
        }

        let _ = IOSDriver(fontNames: fontNames, fontSize: fontSize).contours { (image, contour) in
            if displayed {
                self.display(image, in: self.imageView2)
                self.displayTextContour(self.contourView2, at: contour, in: self.imageView2)
                debugPrint(contour)
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
                debugPrint(contour)
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
