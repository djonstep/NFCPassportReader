//
//  DataGroup16.swift
//  MIDNFCReader
//
//  Created by ivan.zagorulko on 07.09.2021.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class DataGroup16: DataGroup {
    
    public private(set) var nrInstances: Int = 0
    public private(set) var dateOfRecord: String?
    public private(set) var personName: String?
    public private(set) var telephone : String?
    public private(set) var address : String?
    
    required init( _ data : [UInt8] ) throws {
        try super.init(data)
        datagroupType = .DG16
    }
    
    override func parse(_ data: [UInt8]) throws {
        var tag = try getNextTag()
        // Tag should be 0x02
        if  tag != 0x02 {
            throw NFCPassportReaderError.InvalidResponse
        }
        nrInstances = try Int(getNextValue()[0])
        var i = 0
        repeat {
            let _ = try getNextTag() //Ax begin
            tag = try getNextTag()
            let val = try String( bytes:getNextValue(), encoding:.utf8)
            if tag == 0x5F50 {
                dateOfRecord = val
            } else if tag == 0x5F51 {
                personName = val
            } else if tag == 0x5F52 {
                telephone = val
            } else if tag == 0x5F53 {
                address = val
            }
            i += 1
        } while i < nrInstances
    }
}
