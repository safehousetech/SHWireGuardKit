//
//  VPNRegionModel.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation


public struct VPNRegionModel: Codable {
  public let regionCode, regionName: String?
  public let distance: Double?
    
    public init(regionCode: String, regionName: String, distance: Double){
        self.regionCode = regionCode
        self.regionName = regionName
        self.distance = distance
    }

}
