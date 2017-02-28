//
//  String+PostScriptName.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/28/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import Foundation
import CoreGraphics

extension String {
    var postScriptName: String {
        guard let url = Bundle.main.url(forResource: self, withExtension: "ttf", subdirectory: "Fonts"),
            let data = try? Data(contentsOf: url),
            let provider = CGDataProvider(data: data as CFData) else {
                debugPrint("Failed to load font file", self)

                return self
        }

        let font = CGFont(provider)
        let postScriptName = font.postScriptName as! String

        return postScriptName
    }
}
