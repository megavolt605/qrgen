//
//  cli.swift
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

import Foundation
import CommandLineKit

/// Command line interface (parameters) handler. It acually is the wrapper to CommandLine singletone from CommandLineKit
struct CLI {
    
    enum Mode: String {
        case generation = "g", reconition = "r"
    }
    
    static let shared = CLI()
    
    
    /// Set of params
    let modeParam = EnumOption<Mode>(
        shortFlag: "m",
        longFlag: "mode",
        required: false,
        helpMessage: "mode. g - generation, r - reconition, default is generation"
    )
    let inputParam = StringOption(
        shortFlag: "i",
        longFlag: "input",
        required: true,
        helpMessage: "source (either string to encode for genetation or image file name for recognition), required"
    )
    let outputParam = StringOption(
        shortFlag: "o",
        longFlag: "output",
        required: true,
        helpMessage: "output file name, required"
    )
    let sizeParam = IntOption(
        longFlag: "size",
        required: false,
        helpMessage: "size of the image, default is 400"
    )
    let backColorParam = StringOption(
        shortFlag: "b",
        longFlag: "back",
        required: false,
        helpMessage: "background color #RRGGBB, default if #FFFFFF"
    )
    let frontColorParam = StringOption(
        shortFlag: "f",
        longFlag: "front",
        required: false,
        helpMessage: "foreground color #RRGGBB, default is #000000"
    )
    fileprivate let silentModeParam = BoolOption(
        shortFlag: "s",
        longFlag: "silent",
        required: false,
        helpMessage: "suppress output, default is false"
    )
    
    private let cli = CommandLine()
    func add(options: [Option]) {
        cli.addOptions(options)
    }
    
    private init() {
        add(options: [
            modeParam,
            silentModeParam,
            inputParam, outputParam,
            sizeParam, backColorParam, frontColorParam
        ])
    }
    
    
    /// Prints usage
    /// - Parameter error: an error
    func printUsage(_ error: Error) {
        cli.printUsage(error)
    }
    
    /// Parse wrapper
    func parse() throws {
        try cli.parse()
    }
    
    /// Outputs file size
    /// - Parameter path: path to the file
    func outputFileSize(path: String) throws {
        let attrs = try FileManager.default.attributesOfItem(atPath: path)
        if let size = attrs[.size] as? UInt64 {
            output("\(size) bytes written")
        }
    }

}

/// Outputs a string to stdout with verbose condition
/// - Parameter string: value
func output(_ string: String) {
    if !CLI.shared.silentModeParam.value { print("qrgen:", string) }
}

