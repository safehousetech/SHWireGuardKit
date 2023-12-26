//
//  WireGuardAppError.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

protocol WireGuardAppError: Error {
  typealias AlertText = (title: String, message: String)

  var alertText: AlertText { get }
}
