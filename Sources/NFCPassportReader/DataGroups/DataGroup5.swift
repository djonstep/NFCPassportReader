//
//  DataGroup5.swift
//  MIDNFCReader
//
//  Created by ivan.zagorulko on 07.09.2021.
//

import Foundation

#if !os(macOS)
import UIKit
#endif

@available(iOS 13, macOS 10.15, *)
public class DataGroup5 : DataGroup {
    
    public private(set) var imageData : [UInt8] = []
    
    required init( _ data : [UInt8] ) throws {
        try super.init(data)
        datagroupType = .DG5
    }
    
#if !os(macOS)
    func getImage() -> UIImage? {
        if imageData.count == 0 {
            return nil
        }
        
        let image = UIImage(data:Data(imageData) )
        return image
    }
#endif
    
    
    override func parse(_ data: [UInt8]) throws {
        var tag = try getNextTag()
        if tag != 0x02 {
            throw NFCPassportReaderError.InvalidResponse
        }
        _ = try getNextValue()
        
        tag = try getNextTag()
        if tag != 0x5F40 {
            throw NFCPassportReaderError.InvalidResponse
        }
        
        imageData = try getNextValue()
    }
}
