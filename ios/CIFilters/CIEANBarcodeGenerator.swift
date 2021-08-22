//
//  CIEANBarcodeGenerator.swift
//  BarcodeCreator
//
//  Created by David Vittori on 22/08/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

@objcMembers
public class CIEANBarcodeGeneratorConstructor: CIFilterConstructor {
    public func filter(withName name: String) -> CIFilter? {
        return CIEANBarcodeGenerator()
    }
}

@objcMembers
public class CIEANBarcodeGenerator: CIFilter {
    
    private static let kernelSrc =
        "kernel vec4 coreImageKernel(float barCount, vec4 vector) {\n" +
        "    vec2 dc = destCoord();\n" +
        "    int x = int(floor(dc.x));\n" +
        "    int y = int(floor(dc.y));\n" +
        "    if (x < 0 || x >= int(barCount) || y < 0 || y >= 32) {\n" +
        "        return vec4(1.0, 1.0, 1.0, 1.0);\n" +
        "    }\n" +
        "    int vectorIndex = int(x / 24);\n" +
        "    int value = int(vector[vectorIndex]);\n" +
        "    value = value & (1 << (x % 24));\n" +
        "    if (value != 0) {\n" +
        "       return vec4(0.0, 0.0, 0.0, 1.0);\n" +
        "    }\n" +
        "    return vec4(1.0, 1.0, 1.0, 1.0);\n" +
        "}\n"
    
    private static let codingMap: [[UInt8]] = [
        // left,      right,     guard
        [0b0001101, 0b1110010, 0b0100111], // 0
        [0b0011001, 0b1100110, 0b0110011], // 1
        [0b0010011, 0b1101100, 0b0011011], // 2
        [0b0111101, 0b1000010, 0b0100001], // 3
        [0b0100011, 0b1011100, 0b0011101], // 4
        [0b0110001, 0b1001110, 0b0111001], // 5
        [0b0101111, 0b1010000, 0b0000101], // 6
        [0b0111011, 0b1000100, 0b0010001], // 7
        [0b0110111, 0b1001000, 0b0001001], // 8
        [0b0001011, 0b1110100, 0b0010111]  // 9
    ]
    
    private static let leftPartMap: [UInt8] = [
        // 0-left, 1-guard
        0b000000, // 0
        0b001011, // 1
        0b001101, // 2
        0b001110, // 3
        0b010011, // 4
        0b011001, // 5
        0b011100, // 6
        0b010101, // 7
        0b010110, // 8
        0b011010  // 9
    ]
    
    @objc
    private var inputMessage: Data = Data()
    
    public override var attributes: [String : Any] {
        return [
            "inputMessage": [
                kCIAttributeName: "inputMessage",
                kCIAttributeDisplayName: "inputMessage",
                kCIAttributeClass: "NSData",
                kCIAttributeDefault: ""
            ]
        ]
    }
    
    public class func register() {
        CIFilter.registerName("CIEANBarcodeGenerator",
                              constructor: CIEANBarcodeGeneratorConstructor(),
                              classAttributes: [
                                kCIAttributeFilterDisplayName: "EAN-13 UPC-A barcode generator",
                                kCIAttributeFilterCategories: [kCICategoryBuiltIn]
            ]
        )
    }
    
    public override var outputImage: CIImage? {
        get {
            return drawOutputImage()
        }
    }
    
    public override func setDefaults() {
        inputMessage = Data()
    }
    
    private func drawOutputImage() -> CIImage? {
        guard let barcodeData: Data = value(forKey: "inputMessage") as? Data else {
            print("Invalid barcode. (Should be EAN-13 or UPC-A barcode)")
            return nil
        }
        let barcode = parseBarcodeString(barcodeData)
        if validateEAN13Barcode(barcode) {
            return drawEAN13(barcode: barcode)
        } else if validateUPCABarcode(barcode) {
            return drawUPCA(barcode: barcode)
        } else {
            print("Invalid barcode. (Should be EAN-13 or UPC-A barcode)")
            return nil
        }
    }
    
    private func parseBarcodeString(_ barcodeData: Data) -> [UInt8] {
        let str = String(decoding: barcodeData, as: UTF8.self)
        let intArray = str.map { UInt8(String($0)) ?? 0 }

        // the number of elements:
//        let count = barcodeData.count / MemoryLayout<Int8>.size

        // create array of appropriate length:
//        let array = [UInt8](barcodeData)
        
        // copy bytes into array
//        barcodeData.getBytes(array, length:count * MemoryLayout<Int8>.size)

        print(intArray)
        
//        var numbers: [Int8] = []
//        barcodeString.forEach { (character) in
//            if let number = Int8(String(character)) {
//                numbers.append(number)
//            }
//        }
        
        return intArray
    }
    
    private func drawEAN13(barcode: [UInt8]) -> CIImage? {
        let firstNumber = Int(barcode.first!)
        let leftPartPattern = CIEANBarcodeGenerator.leftPartMap[firstNumber]
        let leftPart = [UInt8](barcode[1...6])
        let rightPart = [UInt8](barcode[7...12])
        let bars = prepareBars(leftPart: leftPart, rightPart: rightPart, leftPartPattern: leftPartPattern)
        return drawBarcode(bars: bars)
    }
    
    private func drawUPCA(barcode: [UInt8]) -> CIImage? {
        let leftPartPattern = CIEANBarcodeGenerator.leftPartMap.first!
        let leftPart = [UInt8](barcode[0...5])
        let rightPart = [UInt8](barcode[6...11])
        let bars = prepareBars(leftPart: leftPart, rightPart: rightPart, leftPartPattern: leftPartPattern)
        return drawBarcode(bars: bars)
    }
    
    private func prepareBars(leftPart: [UInt8], rightPart: [UInt8], leftPartPattern: UInt8) -> [UInt8] {
        var bars: [UInt8] = []
        
        // add start guard
        bars.append(contentsOf: [1, 0, 1])
        
        // add left part
        for i in 0..<leftPart.count {
            let n = Int(leftPart[i])
            
            var value: UInt8;
            if leftPartPattern & (1 << (leftPart.count - 1 - i)) == 0 {
                // left
                value = CIEANBarcodeGenerator.codingMap[n][0]
            } else {
                // guard
                value = CIEANBarcodeGenerator.codingMap[n][2]
            }
            
            bars.append(contentsOf: toBitArray(value))
        }
        
        // add middle guard
        bars.append(contentsOf: [0, 1, 0, 1, 0])
        
        // add right part
        for i in 0..<rightPart.count {
            let n = Int(rightPart[i])
            
            // right
            let value = CIEANBarcodeGenerator.codingMap[n][1]
            bars.append(contentsOf: toBitArray(value))
        }
        
        // add end guard
        bars.append(contentsOf: [1, 0, 1])
        
        return bars
    }
    
    private func toBitArray(_ value: UInt8) -> [UInt8] {
        var bits: [UInt8] = []
        for i in 0..<7 {
            bits.append(value & (1 << (6 - i)) == 0 ? 0 : 1)
        }
        
        return bits
    }
    
    
    private func drawBarcode(bars:[UInt8]) -> CIImage? {
        guard let kernel = CIColorKernel(source: CIEANBarcodeGenerator.kernelSrc) else {
            return nil
        }
        
        var args: [Any] = [bars.count]
        var vector: [CGFloat] = []
        var value: Int32 = 0
        
        for i in 0..<bars.count {
            if i > 0 && i % 24 == 0 {
                vector.append(CGFloat(value))
                value = 0
            }
            
            if (bars[i] == 1) {
                value = value | (Int32(1) << (i % 24))
            }
        }
        
        vector.append(CGFloat(value))
        args.append(CIVector(values: vector, count: vector.count) )
        
        let width: CGFloat = CGFloat(bars.count)
        let height: CGFloat = 32.0
        return kernel.apply(extent: CGRect(x: 0, y: 0, width: width, height: height), arguments: args)
    }
    
    private func validateEAN13Barcode(_ barcode: [UInt8]) -> Bool {
        guard barcode.count == 13 else {
            return false
        }
        
        return checkSum(barcode) == 0
    }
    
    private func validateUPCABarcode(_ barcode: [UInt8]) -> Bool {
        guard barcode.count == 12 else {
            return false
        }
        
        return checkSum(barcode) == 0
    }
    
    private func checkSum(_ barcode: [UInt8]) -> UInt8 {
        var checkSum:UInt8 = 0
        for i in 0..<barcode.count {
            checkSum = (checkSum + (i % 2 == 0 ? barcode[i] : barcode[i] * 3)) % 10
        }
        
        return checkSum
    }
}
