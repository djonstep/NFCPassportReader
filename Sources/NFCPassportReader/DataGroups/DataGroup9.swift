//
//  DataGroup9.swift
//  MIDNFCReader
//
//  Created by ivan.zagorulko on 07.09.2021.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class DataGroup9: DataGroup {
    public private(set) var nrInstances : Int = 0
    public private(set) var groupData : [UInt8] = []
    
    required init( _ data : [UInt8] ) throws {
        try super.init(data)
        datagroupType = .DG9
    }
    
    override func parse(_ data: [UInt8]) throws {
        var tag = try getNextTag()
        // Tag should be 0x02
        if  tag != 0x02 {
            throw NFCPassportReaderError.InvalidResponse
        }
        nrInstances = try Int(getNextValue()[0])
        
        tag = try getNextTag()
        let value = try getNextValue()
        
        groupData = value
    }
}
