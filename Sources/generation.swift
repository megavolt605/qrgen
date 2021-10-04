//
//  generation.swift
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

/// Parses input params and perform qr code recognition
/// - Throws: if any error
func generation() throws {
    guard
        let inputString = CLI.shared.inputParam.value,
        let outFileName = CLI.shared.outputParam.value
    else { throw GenError(reason: "invalid parameters") }

    let front = CIColor(rgba: CLI.shared.frontColorParam.value ?? "#000000")
    let back = CIColor(rgba: CLI.shared.backColorParam.value ?? "#FFFFFF")
    let size = CGFloat(CLI.shared.sizeParam.value ?? 400)
    
    if let i = qrgen(qrCode: inputString, size: size, front: front, back: back) {
        try i.savePNG(to: outFileName)
    } else {
        throw GenError(reason: "unable to generate qr code")
    }
}

///
/// Generates UIImage with QR code of the string with specified size and correction level
/// - Parameters:
///   - qrCode: Source string. Must have UTF8 representation
///   - size: Width and height of generated image
///   - foregroundColor: foregroundColor
///   - backgroundColor: backgroundColor
/// - Returns: CIImage
///
fileprivate func qrgen(
    qrCode: String,
    size: CGFloat,
    front foregroundColor: CIColor,
    back backgroundColor: CIColor
) -> CIImage? {
    guard
        size > 0.0,
        let data = qrCode.data(using: .utf8)
    else { return nil }
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(data, forKey: "inputMessage")

    guard let initialImage = filter?.outputImage else { return nil }
    let filterColor = CIFilter(
        name: "CIFalseColor",
        parameters: [
            "inputImage": initialImage,
            "inputColor0": foregroundColor,
            "inputColor1": backgroundColor
        ]
    )

    guard let ciImage = filterColor?.outputImage else { return nil }
    let width = ciImage.extent.size.width
    if width > 0.0, size > width {
        let scale = size / width
        return ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }
    return ciImage
}

