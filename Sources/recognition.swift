//
//  recognition.swift
//  qrgen
//
//  Created by Igor Smirnov on 10/03/2021.
//
//  Copyright (c) 2021 Igor Smirnov <megavolt605@yandex.ru>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import CoreImage

/// Parses input params and perform qr code generation
/// - Throws: if any error
func recognition() throws {
    guard
        let inFileName = CLI.shared.inputParam.value,
        let outFileName = CLI.shared.outputParam.value
    else { throw GenError(reason: "invalid parameters") }
    
    let inputURL = URL(fileURLWithPath: inFileName)
    let outputURL = URL(fileURLWithPath: outFileName)

    guard
        let image = CIImage(contentsOf: inputURL)
    else { throw GenError(reason: "unable to read input file")}
    let result = recognition(image: image).joined(separator: "\n")
    try result.write(to: outputURL, atomically: true, encoding: .utf8)
    try CLI.shared.outputFileSize(path: outFileName)
}

/// Convert CIImage with qr code(s) to array of string with options
/// - Parameter image: source imagr
/// - Returns: array of recognized strings
fileprivate func recognition(image: CIImage, options: [String: Any]? = nil) -> [String] {
    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
    guard let features = detector?.features(in: image) else { return [] }
    return features.compactMap { ($0 as? CIQRCodeFeature)?.messageString }
}

/// Convert CIImage with qr code(s) to array of string
/// - Parameter image: source imagr
/// - Returns: array of recognized strings
fileprivate func recognition(image: CIImage) -> [String] {
    let result = recognition(image: image, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    if result.isEmpty, let grayscaleImage = image.grayscale {
        return recognition(image: grayscaleImage, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    }
    return result
}
