//
//  TunnelError.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import NetworkExtension


public func tr(_ key: String) -> String {
  key
}

public func tr(format: String, _ arguments: CVarArg...) -> String {
  String(format: NSLocalizedString(format, comment: ""), arguments: arguments)
}

// MARK: - TunnelsManagerError

public enum TunnelsManagerError: WireGuardAppError {
  case tunnelNameEmpty
  case tunnelAlreadyExistsWithThatName
  case systemErrorOnListingTunnels(systemError: Error)
  case systemErrorOnAddTunnel(systemError: Error)
  case systemErrorOnModifyTunnel(systemError: Error)
  case systemErrorOnRemoveTunnel(systemError: Error)

  // MARK: Internal

 var alertText: AlertText {
    switch self {
    case .tunnelNameEmpty:
      return (tr("alertTunnelNameEmptyTitle"), tr("alertTunnelNameEmptyMessage"))
    case .tunnelAlreadyExistsWithThatName:
      return (
        tr("alertTunnelAlreadyExistsWithThatNameTitle"),
        tr("alertTunnelAlreadyExistsWithThatNameMessage")
      )
    case let .systemErrorOnListingTunnels(systemError):
      return (tr("alertSystemErrorOnListingTunnelsTitle"), systemError.localizedUIString)
    case let .systemErrorOnAddTunnel(systemError):
      return (tr("alertSystemErrorOnAddTunnelTitle"), systemError.localizedUIString)
    case let .systemErrorOnModifyTunnel(systemError):
      return (tr("alertSystemErrorOnModifyTunnelTitle"), systemError.localizedUIString)
    case let .systemErrorOnRemoveTunnel(systemError):
      return (tr("alertSystemErrorOnRemoveTunnelTitle"), systemError.localizedUIString)
    }
  }
}

// MARK: - TunnelsManagerActivationAttemptError

public enum TunnelsManagerActivationAttemptError: WireGuardAppError {
  case tunnelIsNotInactive
  case failedWhileStarting(systemError: Error) // startTunnel() throwed
  case failedWhileSaving(systemError: Error) // save config after re-enabling throwed
  case failedWhileLoading(systemError: Error) // reloading config throwed
  case failedBecauseOfTooManyErrors(lastSystemError: Error) // recursion limit reached

  // MARK: Internal

  var alertText: AlertText {
    switch self {
    case .tunnelIsNotInactive:
      return (
        tr("alertTunnelActivationErrorTunnelIsNotInactiveTitle"),
        tr("alertTunnelActivationErrorTunnelIsNotInactiveMessage")
      )
    case let .failedBecauseOfTooManyErrors(systemError),
         let .failedWhileLoading(systemError),
         let .failedWhileSaving(systemError),
         let .failedWhileStarting(systemError):
      return (
        tr("alertTunnelActivationSystemErrorTitle"),
        tr(
          format: "alertTunnelActivationSystemErrorMessage (%@)",
          systemError.localizedUIString
        )
      )
    }
  }
}

// MARK: - TunnelsManagerActivationError

public enum TunnelsManagerActivationError: WireGuardAppError {
  case activationFailed(wasOnDemandEnabled: Bool)
  case activationFailedWithExtensionError(
    title: String,
    message: String,
    wasOnDemandEnabled: Bool
  )

  // MARK: Internal

  var alertText: AlertText {
    switch self {
    case let .activationFailed(wasOnDemandEnabled):
      return (
        tr("alertTunnelActivationFailureTitle"),
        tr("alertTunnelActivationFailureMessage") +
          (wasOnDemandEnabled ? tr("alertTunnelActivationFailureOnDemandAddendum") : "")
      )
    case let .activationFailedWithExtensionError(title, message, wasOnDemandEnabled):
      return (
        title,
        message +
          (wasOnDemandEnabled ? tr("alertTunnelActivationFailureOnDemandAddendum") : "")
      )
    }
  }
}

// MARK: - PacketTunnelProviderError + WireGuardAppError

extension PacketTunnelProviderError: WireGuardAppError {
  var alertText: AlertText {
    switch self {
    case .savedProtocolConfigurationIsInvalid:
      return (
        tr("alertTunnelActivationFailureTitle"),
        tr("alertTunnelActivationSavedConfigFailureMessage")
      )
    case .dnsResolutionFailure:
      return (tr("alertTunnelDNSFailureTitle"), tr("alertTunnelDNSFailureMessage"))
    case .couldNotStartBackend:
      return (
        tr("alertTunnelActivationFailureTitle"),
        tr("alertTunnelActivationBackendFailureMessage")
      )
    case .couldNotDetermineFileDescriptor:
      return (
        tr("alertTunnelActivationFailureTitle"),
        tr("alertTunnelActivationFileDescriptorFailureMessage")
      )
    case .couldNotSetNetworkSettings:
      return (
        tr("alertTunnelActivationFailureTitle"),
        tr("alertTunnelActivationSetNetworkSettingsMessage")
      )
    }
  }
}

extension Error {
 public var localizedUIString: String {
    if let systemError = self as? NEVPNError {
      switch systemError {
      case NEVPNError.configurationInvalid:
        return tr("alertSystemErrorMessageTunnelConfigurationInvalid")
      case NEVPNError.configurationDisabled:
        return tr("alertSystemErrorMessageTunnelConfigurationDisabled")
      case NEVPNError.connectionFailed:
        return tr("alertSystemErrorMessageTunnelConnectionFailed")
      case NEVPNError.configurationStale:
        return tr("alertSystemErrorMessageTunnelConfigurationStale")
      case NEVPNError.configurationReadWriteFailed:
        return tr("alertSystemErrorMessageTunnelConfigurationReadWriteFailed")
      case NEVPNError.configurationUnknown:
        return tr("alertSystemErrorMessageTunnelConfigurationUnknown")
      default:
        return ""
      }
    } else {
      return localizedDescription
    }
  }
}


