//
//  Data+KeyEncoding.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation


extension Data {
  func hexKey() -> String? {
    if count != WG_KEY_LEN {
      return nil
    }
    var out = Data(repeating: 0, count: Int(WG_KEY_LEN_HEX))
    out.withUnsafeMutableInt8Bytes { outBytes in
      self.withUnsafeUInt8Bytes { inBytes in
        key_to_hex(outBytes, inBytes)
      }
    }
    out.removeLast()
    return String(data: out, encoding: .ascii)
  }

  init?(hexKey hexString: String) {
    self.init(repeating: 0, count: Int(WG_KEY_LEN))

    if !withUnsafeMutableUInt8Bytes({ key_from_hex($0, hexString) }) {
      return nil
    }
  }

  func base64Key() -> String? {
    if count != WG_KEY_LEN {
      return nil
    }
    var out = Data(repeating: 0, count: Int(WG_KEY_LEN_BASE64))
    out.withUnsafeMutableInt8Bytes { outBytes in
      self.withUnsafeUInt8Bytes { inBytes in
        key_to_base64(outBytes, inBytes)
      }
    }
    out.removeLast()
    return String(data: out, encoding: .ascii)
  }

  init?(base64Key base64String: String) {
    self.init(repeating: 0, count: Int(WG_KEY_LEN))

    if !withUnsafeMutableUInt8Bytes({ key_from_base64($0, base64String) }) {
      return nil
    }
  }
}

extension Data {
  func withUnsafeUInt8Bytes<R>(_ body: (UnsafePointer<UInt8>) -> R) -> R {
    assert(!isEmpty)
    return withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> R in
      let bytes = ptr.bindMemory(to: UInt8.self)
      return body(bytes.baseAddress!) // might crash if self.count == 0
    }
  }

  mutating func withUnsafeMutableUInt8Bytes<R>(_ body: (UnsafeMutablePointer<UInt8>) -> R) -> R {
    assert(!isEmpty)
    return withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) -> R in
      let bytes = ptr.bindMemory(to: UInt8.self)
      return body(bytes.baseAddress!) // might crash if self.count == 0
    }
  }

  mutating func withUnsafeMutableInt8Bytes<R>(_ body: (UnsafeMutablePointer<Int8>) -> R) -> R {
    assert(!isEmpty)
    return withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) -> R in
      let bytes = ptr.bindMemory(to: Int8.self)
      return body(bytes.baseAddress!) // might crash if self.count == 0
    }
  }
}

