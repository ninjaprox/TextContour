//
//  FontLoader.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/10/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import Foundation

final class FontLoader {

    func list() -> [String] {
        let paths = Bundle.main.paths(forResourcesOfType: "ttf", inDirectory: "Fonts")

        return paths.map {
            return ($0 as NSString).lastPathComponent.replacingOccurrences(of: ".ttf", with: "")
        }
    }
}
