//
//  Writter.swift
//  TextContour
//
//  Created by Vinh Nguyen on 2/17/17.
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

    func writeImage(_ data: Data, to filename: String) {
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }

        url.appendPathComponent("Images", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            url.appendPathComponent(filename)
            try data.write(to: url, options: .atomic)
            debugPrint("Wrote to", filename)
        } catch {
            debugPrint("Failed to write to", filename)
        }

    }
}
