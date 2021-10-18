//
//  DataGroup3.swift
//  MIDNFCReader
//
//  Created by ivan.zagorulko on 02.09.2021.
//

import Foundation

#if !os(macOS)
import UIKit
#endif

@available(iOS 13, macOS 10.15, *)
public class DataGroup3: DataGroup {
    
    public private(set) var nrImages : Int = 0
    public private(set) var imageData : [UInt8] = []
    
    #if !os(macOS)
    func getImage() -> UIImage? {
            if imageData.count == 0 {
                return nil
            }
            
            let image = UIImage(data:Data(imageData) )
            return image
        }
    #endif

    required init( _ data : [UInt8] ) throws {
        try super.init(data)
        datagroupType = .DG3
    }
    
    override func parse(_ data: [UInt8]) throws {
        var tag = try getNextTag()
        if tag != 0x7F61 {
            throw NFCPassportReaderError.InvalidResponse
        }
        _ = try getNextLength()
        
        // Tag should be 0x02
        tag = try getNextTag()
        if  tag != 0x02 {
            throw NFCPassportReaderError.InvalidResponse
        }
        nrImages = try Int(getNextValue()[0])
        
        // Next tag is 0x7F60
        tag = try getNextTag()
        if tag != 0x7F60 {
            throw NFCPassportReaderError.InvalidResponse
        }
        _ = try getNextLength()
        
        // Next tag is 0xA1 (Biometric Header Template) - don't care about this
        tag = try getNextTag()
        if tag != 0xA1 {
            throw NFCPassportReaderError.InvalidResponse
        }
        _ = try getNextValue()
        
        // Now we get to the good stuff - next tag is either 5F2E or 7F2E
        tag = try getNextTag()
        if tag != 0x5F2E && tag != 0x7F2E {
            throw NFCPassportReaderError.InvalidResponse
        }
        let value = try getNextValue()
        
        try parseISO19794_4( data:value )
    }
    
    func parseISO19794_4( data : [UInt8] ) throws {
        // Validate header - 'F', 'I' 'R' 0x00 - 0x46495200
        if data[0] != 0x46 && data[1] != 0x49 && data[2] != 0x52 && data[3] != 0x00 {
            throw NFCPassportReaderError.InvalidResponse
        }
        
        imageData = data
    }
}
