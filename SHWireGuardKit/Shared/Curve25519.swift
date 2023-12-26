//
//  Curve25519.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation

struct Curve25519 {
  static let keyLength: Int = 32

  static func generatePrivateKey() -> Data {
    var privateKey = Data(repeating: 0, count: keyLength)
    privateKey.withUnsafeMutableUInt8Bytes { bytes in
      curve25519_generate_private_key(bytes)
    }
    assert(privateKey.count == keyLength)
    return privateKey
  }

  static func generatePublicKey(fromPrivateKey privateKey: Data) -> Data {
    assert(privateKey.count == keyLength)
    var publicKey = Data(repeating: 0, count: keyLength)
    privateKey.withUnsafeUInt8Bytes { privateKeyBytes in
      publicKey.withUnsafeMutableUInt8Bytes { bytes in
        curve25519_derive_public_key(bytes, privateKeyBytes)
      }
    }
    assert(publicKey.count == keyLength)
    return publicKey
  }
}

extension InterfaceConfiguration {
  var publicKey: Data {
    privateKey.publicKey.rawValue
  }
}

