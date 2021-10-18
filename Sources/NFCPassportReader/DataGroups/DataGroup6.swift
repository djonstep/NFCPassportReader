//
//  DataGroup6.swift
//  MIDNFCReader
//
//  Created by ivan.zagorulko on 08.09.2021.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class DataGroup6: DataGroup {
    public private(set) var groupData : [UInt8] = []
    
    required init( _ data : [UInt8] ) throws {
        try super.init(data)
        datagroupType = .DG6
    }
    
    override func parse(_ data: [UInt8]) throws {
        var tag = try getNextTag()
        let value = try getNextValue()
        groupData = value
    }
}
