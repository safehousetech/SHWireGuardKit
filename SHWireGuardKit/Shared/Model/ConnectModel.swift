//
//  ConnectModel.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

// MARK: - ConnectResult

public struct ConnectResult: Codable {
  public let peerConfig: ConnectConfig?
}

// MARK: - ConnectConfig

public struct ConnectConfig: Codable {
 public let interface: ConnectInterface?
 public let peers: [ConnectPeerModel]?
}

// MARK: - ConnectInterface

public struct ConnectInterface: Codable {
  public let address, dns: [String]?
}

// MARK: - ConnectPeerModel

public struct ConnectPeerModel: Codable {
  public let publicKey: String?
  public let hasPresharedKey: Bool?
  public let persistentKeepAlive: String?
  public let allowedIPs: [String]?
  public let endpoint: String?
}


