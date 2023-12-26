//
//  KeychainWrapper.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation


public enum KeychainWrapper {
  // MARK: Public

  public static func setPassword(_ password: String, forVPNID VPNID: String) {
    let key = NSURL(string: VPNID)!.lastPathComponent!
    _ = try? k.remove(key)
    k[key] = password
  }

  public static func setSecret(_ secret: String, forVPNID VPNID: String) {
    let key = NSURL(string: VPNID)!.lastPathComponent!
    _ = try? k.remove("\(key)psk")
    k["\(key)psk"] = secret
  }

  public static func passwordRefForVPNID(_ VPNID: String) -> Data? {
    let key = NSURL(string: VPNID)!.lastPathComponent!
    return k[attributes: key]?.persistentRef
  }

  public static func secretRefForVPNID(_ VPNID: String) -> Data? {
    let key = NSURL(string: VPNID)!.lastPathComponent!
    if let data = k[attributes: "\(key)psk"]?.data,
       let value = String(data: data, encoding: .utf8) {
      if !value.isEmpty {
        return k[attributes: "\(key)psk"]?.persistentRef
      }
    }
    return nil
  }

  // MARK: Private

  private static var k: Keychain {
    Keychain(service: "Safehouse")
  }
}

