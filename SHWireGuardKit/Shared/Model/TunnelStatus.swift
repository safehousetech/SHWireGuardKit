//
//  TunnelStatus.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation
import NetworkExtension

// MARK: - TunnelStatus

@objc
enum TunnelStatus: Int {
  case inactive
  case activating
  case active
  case deactivating
  case reasserting // Not a possible state at present
  case restarting // Restarting tunnel (done after saving modifications to an active tunnel)
  case waiting // Waiting for another tunnel to be brought down

  // MARK: Lifecycle

  init(from systemStatus: NEVPNStatus) {
    switch systemStatus {
    case .connected:
      self = .active
    case .connecting:
      self = .activating
    case .disconnected:
      self = .inactive
    case .disconnecting:
      self = .deactivating
    case .reasserting:
      self = .reasserting
    case .invalid:
      self = .inactive
    @unknown default:
      fatalError()
    }
  }
}

// MARK: CustomDebugStringConvertible

extension TunnelStatus: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .inactive: return "inactive"
    case .activating: return "activating"
    case .active: return "active"
    case .deactivating: return "deactivating"
    case .reasserting: return "reasserting"
    case .restarting: return "restarting"
    case .waiting: return "waiting"
    }
  }
}

// MARK: - NEVPNStatus + CustomDebugStringConvertible

extension NEVPNStatus: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .connected: return "connected"
    case .connecting: return "connecting"
    case .disconnected: return "disconnected"
    case .disconnecting: return "disconnecting"
    case .reasserting: return "reasserting"
    case .invalid: return "invalid"
    @unknown default:
      fatalError()
    }
  }
}

