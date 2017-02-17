//
//  Writter.swift
//  TextContour
//
//  Created by Piktochart on 2/17/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import Foundation

class Writter {

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
}
