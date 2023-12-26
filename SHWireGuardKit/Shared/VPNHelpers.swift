//
//  VPNHelpers.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation

class VPNHelpers {
  
  /// get difference between current time and last saved time.
  ///  we will be using this fucntion for checking lasr saved profile time for wireguard.
  func getDifferenceInSeconds(lastDate: Date, currentDate: Date) -> Int {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(
      [Calendar.Component.second],
      from: lastDate,
      to: currentDate
    )
    let seconds = dateComponents.second
    return Int(seconds!)
  }
  
  /// used to generate public key using private key required for wireguard handshake.
  func generatePublicKey() -> (String, String) {
    let private_key = Curve25519.generatePrivateKey()
    let pKey = private_key.base64Key() ?? ""
    let public_key = Curve25519.generatePublicKey(fromPrivateKey: private_key)
    let public_key_value: String = public_key.base64Key() ?? ""
    return (public_key_value, pKey)
  }
}
