//
//  TextViewDriver.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit

class TextViewDriver {
    static let position = CGPoint(x: 0, y: 10)
    static let size = CGSize(width: 800, height: 200)

    let font: UIFont
    let fontSize: CGFloat
    let content: String
    let view: UIView
    let textView: UITextView

    // MARK: - Init

    init?(fontName: String, fontSize: CGFloat, content: String) {
        guard let font = UIFont(name: fontName.postScriptName, size: fontSize) else {
            debugPrint("Failed to load font", fontName)

            return nil
        }

        self.font = font
        self.fontSize = fontSize
        self.content = content
        view = UIView(frame: CGRect(origin: .zero, size: TextViewDriver.size))
        textView = UITextView(frame: CGRect(origin: TextViewDriver.position,
                                            size: CGSize(width: TextViewDriver.size.width - TextViewDriver.position.x,
                                                         height: TextViewDriver.size.height - TextViewDriver.position.y)))

        configure()
        configureTextView()
    }

    // MARK: - Configuration

    func configure() {
        view.backgroundColor = .white
        textView.clipsToBounds = false
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.textContainerInset = .zero;
        textView.textContainer.lineFragmentPadding = 0;
        view.addSubview(textView)
    }

    func configureTextView() {
        let style = NSMutableParagraphStyle()
        let string = NSMutableAttributedString(string: content)

        style.maximumLineHeight = fontSize
        style.minimumLineHeight = fontSize
        string.addAttribute(NSParagraphStyleAttributeName, value:style,
                            range:NSMakeRange(0, string.length))
        string.addAttribute(NSFontAttributeName, value: font,
                            range:NSMakeRange(0, string.length))

        textView.attributedText = string
    }

    // MARK: - Interface

    func driverView() -> UIView {
        return view
    }

    func image() -> UIImage {
        return view.imageSync()
    }

    func textContour() -> CGRect {
        return view.imageSync().textContourSync()
    }
}
