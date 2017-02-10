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
        guard let path = Bundle.main.path(forResource: "fonts", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return []
        }

        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return []
        }

        return json as! [String]
    }
}
