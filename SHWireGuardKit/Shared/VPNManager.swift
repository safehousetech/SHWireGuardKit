//
//  VPNManager.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation
import NetworkExtension
//import Reachability
import SafariServices
import SystemConfiguration

//MARK: - Protocols

/// It will be responsible for configuring vpn configuartion and get response from `get-region` api and passing response from `peer-config` in case of `failure.`
public protocol VpnManagerProtocol {
  func configureVpnOnDemand()
  func getRegionsFromServerResponse(status: Bool, vpnServerList: [VPNRegionModel], statusCode: Int?,showPicker: Bool)
  func updateUIWhileConnectingToServer()
  func errorConnectingToVpnServer()
  
}
///  It will be responsible for `connecting` the already added  tunnel and observe changes related to adding tunnel
public protocol ConnectingToTunnelManager {
  func couldNotFindTunnelManager()
  func couldNotFindTunnel()
  func loadALLFromPreferenceError(error: Error)
  func showRetryAlert()
  func tunnelIsConnected()
  
}
/// It will be responsible for `adding new tunnel` and identifying `already added tunnel` and  pass `success` and `failure` for tunnel addition.
public protocol AddTunnelResponseProtocol {
  func missingVPNConfiguration()
  func tunnelAddedSuccessfully()
}
/// It will be responsilble for `disconnecting the already connected tunnel` and  pass `success` and `failure` for tunnel disconnection.
public protocol DisconnectTunnelProtocol {
  func errorDisconnectingTunnel(error: Error)
  func tunnelDisconnectedSuccessfully(forMode: String)
  func retryTunnelDisconnectOnFailure()
}
/// It will be responsible for `observing states of connected tunnel` and send call back to `update UI and send events`
public protocol TunnelStatusProtocol {
  func noVPNServerConnection()
  func vpnIsInConnectedState()
  func vpnIsInConnectingState()
  func vpnIsInDisconnectedState()
  func vpnIsInDisconnectingState()
  func vpnIsInInvalidState()
  func vpnIsInReasseringState()
  func vpnIsInSomeUnknownState()
  
}
/// save `current wireguard profile` and `last profile save time` to user defaults to make peers active for `24 hrs.`
public protocol SaveSHDataToUserDefaultsProtocol {
    func setWGProfile(wgProfile: String, region: String, mode: String)
    func setLastWGProfileSaveTime(dateObj: Date, region: String)
}

public class VPNManager {
  
  //MARK: - Intialiser
  public static let shared = VPNManager()
  public  init () {}
  
  //MARK: Static variables
  public static var secret: String = ""
  public static var pressConnect: Date?
  public static var server: String = ""
  public static var errorCount: Int32 = 0
  public static var showError: Bool = false
  public static var manager: NEVPNManager!
    public static var mngr : NETunnelProviderManager? = NEVPNManager.shared() as? NETunnelProviderManager
//  public static var manager: NEVPNManager! = NEVPNManager.shared()
  public static var tunnelsManager: TunnelsManager?

  
  //MARK: - Properties
 public var getRegionsRetryCount = 0
 var vpnHelpers = VPNHelpers()
 public var vpnPublicKey = ""
 public var connectRetryCount = 0
 public var FASTEST_SERVER_REGION = "blr"
 public var isAddingTunnelConfiguration = false
 public var statusIsConnecting = false
 public var tunnel: TunnelContainer?
// public var mngr: NETunnelProviderManager?
 public var isDisconnecting = false
  
  //MARK: - Delegates
 public var vpnDelegate                       : VpnManagerProtocol?
 public var connectingToTunnelManagerDelegate : ConnectingToTunnelManager?
 public var addTunnelResponseDelegate         : AddTunnelResponseProtocol?
 public var disconnectTunnelDelegate          : DisconnectTunnelProtocol?
 public var tunnelStatusDelegate              : TunnelStatusProtocol?
 public var saveSafehouseDataToUserDefaults   : SaveSHDataToUserDefaultsProtocol?
  
  //MARK: - Public Methods
    public func startVPN(userName: String) {
    VPNManager.errorCount = 0
    VPNManager.showError = false
      KeychainWrapper.setPassword(Constants.password, forVPNID: Constants.password)
    KeychainWrapper.setSecret(VPNManager.secret, forVPNID: Constants.secret)
    VPNManager.manager.isEnabled = true
    VPNManager.manager.loadFromPreferences { error1 in
      if error1 != nil {
        print("VPN Preferences error: 1")
      }
      VPNManager.manager.isOnDemandEnabled = true
      let connectRule = NEOnDemandRuleConnect()
      VPNManager.manager.onDemandRules = [connectRule]
      let p: NEVPNProtocolIPSec = .init()
      p.username = userName
      p.passwordReference = KeychainWrapper.passwordRefForVPNID(Constants.password)
      p.serverAddress = VPNManager.server // "54.246.132.161"x
      p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
      p.useExtendedAuthentication = true
      p.disconnectOnSleep = false
      p.sharedSecretReference = KeychainWrapper.secretRefForVPNID(Constants.secret)
      VPNManager.manager.isEnabled = true
      VPNManager.manager.protocolConfiguration = p
      VPNManager.manager.localizedDescription = Constants.appName
      VPNManager.manager.saveToPreferences(completionHandler: { error2 in
        print("s3")
        if error2 != nil {
          self.vpnDelegate?.configureVpnOnDemand()
        }
        do {
          print("really call startVPNTunnel")
          VPNManager.pressConnect = Date()
          VPNManager.errorCount = 0
          try VPNManager.manager.connection.startVPNTunnel()
        } catch {
          self.vpnDelegate?.configureVpnOnDemand()
        }
      })
    }
  }
    
    public func configureAndConnectVPN(userName: String) {
          // Set up VPN configuration
        requestVPNPermission {
            self.setUpVPNConfiguration()
        }
          
          // Check if VPN is not already connected
          if VPNManager.mngr?.connection.status != .connected {
              // Request user consent to manage VPN configurations
              requestVPNPermission {
                  // Initiate the VPN connection after user consent
                  self.connectVPN()
              }
          }
      }
    
    private func requestVPNPermission(completion: @escaping () -> Void) {
          NEVPNManager.shared().loadFromPreferences { managerError in
              if managerError != nil {
                  // Handle error loading preferences
                  return
              }
              
              // Request user consent to manage VPN configurations
              NEVPNManager.shared().isEnabled = true
              NEVPNManager.shared().localizedDescription = "Your VPN Description"
              
              NEVPNManager.shared().saveToPreferences { saveError in
                  if saveError != nil {
                      // Handle error saving preferences)
                      return
                  }
                  
                  // Present UI to request user consent
                  NEVPNManager.shared().loadFromPreferences { loadError in
                      // Handle load error if needed
                      completion()
                  }
              }
          }
      }
    
    private func connectVPN() {
           do {
               try VPNManager.mngr?.connection.startVPNTunnel()
           } catch (let error) {
               // Handle connection error
               debugPrint(error.localizedDescription)
           }
       }
    
    public func setUpVPNConfiguration(){
        let p: NEVPNProtocolIPSec = .init()
//        NEVPNManager.shared().loadFromPreferences { (managerError) in
//            if managerError != nil {
//                // Handle error
//                return
//            }
            NEVPNManager.shared().isEnabled = true
            NEVPNManager.shared().localizedDescription = "Allow VPN access"
            NEVPNManager.shared().protocolConfiguration = p
//        }
            NEVPNManager.shared().saveToPreferences { (saveError) in
                if saveError != nil {
                    // Handle error
                    return
                }
                
                NEVPNManager.shared().loadFromPreferences { (loadError) in
                    // Handle load error if needed
                    // Present UI to request user consent
                    NEVPNManager.shared().protocolConfiguration = p
                }
                
            }
        }
    
    
  /// **Responsiblities
  /// - reads all of the NETunnelProvider configurations created by the calling app that have previously been saved to disk and returns them as NETunnelProviderManager objects.
  /// - NSError passed to this block will be nil if the load operation succeeded, non-nil otherwise.
  /// - Use to maintain VPN state in case user kill the app .
 public func loadVPNVar(completion: @escaping ([NETunnelProviderManager]?, Error?) -> Void) {
    NETunnelProviderManager.loadAllFromPreferences { managers, error in
      if let error = error {
        completion(nil , error)
      } else {
        completion(managers , nil)
      }
    }
  }
  
   public func getRegionsFromServer(showPicker: Bool , authToken : String, latitude: String, longitude: String) {
    getRegionsRetryCount = getRegionsRetryCount + 1
    VPNService().getVPNServerRegions(authToken: authToken, latitude: latitude, longitude: longitude) { success, vpnServerList, statusCode in
        print("\(vpnServerList)--------")
      if success {
        DispatchQueue.main.async {
          self.getRegionsRetryCount = 0
          if vpnServerList.count <= 0 {
            return
          }
          self.vpnDelegate?.getRegionsFromServerResponse(status: true, vpnServerList: vpnServerList, statusCode: statusCode,showPicker: showPicker)
        }
      } else if statusCode == 401 {
        self.vpnDelegate?.getRegionsFromServerResponse(status: false, vpnServerList: vpnServerList, statusCode: statusCode,showPicker: showPicker)
      } else if statusCode == 404 {
        self.vpnDelegate?.getRegionsFromServerResponse(status: false, vpnServerList: vpnServerList, statusCode: statusCode,showPicker: showPicker)
      } else {
        self.vpnDelegate?.getRegionsFromServerResponse(status: false, vpnServerList: vpnServerList, statusCode: statusCode,showPicker: showPicker)
      }
    }
       
  }
  
    public func getWGData(authtoken: String, mode: String, lastSavedDateTime: Date, wireGuardProfile:String?, regionCode: String) {
    if let wgProfile = wireGuardProfile {
        let currentDateTimee = Date()
        if vpnHelpers.getDifferenceInSeconds(lastDate: lastSavedDateTime, currentDate: currentDateTimee) < 86400 {
            self.connectToWGProfile(authToken: authtoken, wgProfile: wgProfile, mode: mode, regionCode: regionCode)
        } else {
            self.proceedToConnectVPN(authToken: authtoken, mode: mode, regionCode: regionCode)
        }
    } else {
        self.proceedToConnectVPN(authToken: authtoken, mode: mode, regionCode: regionCode)
    }
  }
  
  public func connectButtonAction(mode: String) {
    NETunnelProviderManager.loadAllFromPreferences {[self] managers, error in
      if let error = error {
        self.connectingToTunnelManagerDelegate?.loadALLFromPreferenceError(error: error)
      } else {
        
        self.connectRetryCount += 1
        if let manager = VPNManager.tunnelsManager {
          if let tunnel = manager.tunnel(named: mode){
            self.tunnel = tunnel
            manager.startActivation(of: tunnel)
            if VPNManager.mngr?.connection.status != .connected {
              if self.connectRetryCount <= 2 {
                self.connectButtonAction(mode: mode)
              } else {
                self.connectRetryCount = 0
              }
            } else {
              VPNManager.mngr = managers?.first
              self.connectingToTunnelManagerDelegate?.tunnelIsConnected()
            }
          } else {
            self.connectingToTunnelManagerDelegate?.couldNotFindTunnel()
          }
        } else {
          self.connectingToTunnelManagerDelegate?.couldNotFindTunnelManager()
        }
      }
    }
  }
  
    public func disconnectButtonAction(isRetry: Bool = false, mode: String) {
        isDisconnecting = true
        
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                self.disconnectTunnelDelegate?.errorDisconnectingTunnel(error: error)
            } else {
                let tunnelManagers = managers ?? []
                if let mode = VPNManager.mngr?.localizedDescription { //SafeHouseData.getPreviousSelectedMode()
                    if let tm = tunnelManagers.first(where: { $0.localizedDescription == mode }) {
                        let tunnel = TunnelContainer(tunnel: tm, modeName: mode)
                        VPNManager.tunnelsManager?.startDeactivation(of: tunnel)
                        if !isRetry {
                            self.disconnectTunnelDelegate?.retryTunnelDisconnectOnFailure()
                        }
                    }
                }
            }
        }
    }
  
 public func updateStatus(withViewAppear flag: Bool = false) {
    if VPNManager.showError {
      VPNManager.shared.statusIsConnecting = false
      VPNManager.showError = false
      self.tunnelStatusDelegate?.noVPNServerConnection()
    }
    switch VPNManager.mngr?.connection.status {
    case .connected:
      VPNManager.errorCount = 0
      VPNManager.pressConnect = nil
      VPNManager.shared.isDisconnecting = false
      self.tunnelStatusDelegate?.vpnIsInConnectedState()
    case .connecting:
      self.tunnelStatusDelegate?.vpnIsInConnectingState()
    case .disconnected:
      VPNManager.shared.statusIsConnecting = false
      self.tunnelStatusDelegate?.vpnIsInDisconnectedState()
    case .disconnecting:
      VPNManager.shared.isDisconnecting = true
      self.tunnelStatusDelegate?.vpnIsInDisconnectingState()
    case .invalid:
      self.tunnelStatusDelegate?.vpnIsInInvalidState()
    case .reasserting:
      VPNManager.shared.isDisconnecting = true
      self.tunnelStatusDelegate?.vpnIsInReasseringState()
    case .none:
      debugPrint("")
    case .some:
      self.tunnelStatusDelegate?.vpnIsInSomeUnknownState()
    }
  }
  
  // MARK: - Private Methods
    
    /// in  original safehouse app we are saving regionMoe
    fileprivate func connectToWGProfile(authToken: String,wgProfile: String, mode: String, regionCode: String) {
    
      let scannedTunnelConfiguration = try? TunnelConfiguration(
        fromWgQuickConfig: wgProfile,
        called: mode
      )
      guard let tunnelConfiguration = scannedTunnelConfiguration else {
          proceedToConnectVPN(authToken: authToken, mode: mode, regionCode: regionCode)
        return
      }
      addTunnel(tunnelConfiguration: tunnelConfiguration, mode: mode)

  }
  
    fileprivate func proceedToConnectVPN(authToken: String,mode: String, regionCode: String) {
    let (publicKey, privateKey) = vpnHelpers.generatePublicKey()
    vpnPublicKey = publicKey
    connectRetryCount = connectRetryCount + 1
    VPNService().connectVPN(
      publicKey: publicKey,
      region:    regionCode,
      mode:      mode,
      authToken: authToken
    ) { success, connectResult, _ in
      if success, let obj = connectResult {
        self.connectRetryCount = 0
        self.createString(
          obj: obj,
          privateKey: privateKey,
          regionStr: regionCode, mode: mode
        )
      } else {
        self.vpnDelegate?.updateUIWhileConnectingToServer()
        if self.connectRetryCount >= 3 {
          self.vpnDelegate?.errorConnectingToVpnServer()
        } else {
            self.proceedToConnectVPN(authToken: authToken, mode: mode, regionCode: regionCode)
        }
      }
    }
  }
  
  fileprivate func createString(obj: ConnectResult, privateKey: String, regionStr: String, mode: String) {
    guard let add = obj.peerConfig?.interface?.address,
          let dns = obj.peerConfig?.interface?.dns,
          let peer = obj.peerConfig?.peers?.first else {
        return
    }
    let publicKey = peer.publicKey
    let allowedIPs = peer.allowedIPs ?? []
    let persistentKeepAlive = peer.persistentKeepAlive
    let endpoint = peer.endpoint
    let privateKey = privateKey
    
    var addStr = ""
    for item in add {
      if item == add.first {
        addStr = item
      } else {
        addStr = addStr + ", " + item
      }
    }
    var dnsStr = ""
    for item in dns {
      if item == dns.first {
        dnsStr = item
      } else {
        dnsStr = dnsStr + ", " + item
      }
    }
    
    var allowIPStr = ""
    for item in allowedIPs {
      if item == allowedIPs.first {
        allowIPStr = item
      } else {
        allowIPStr = allowIPStr + ", " + item
      }
    }
    
    let str =
    "[Interface]\nAddress = \(addStr)\nPrivateKey = \(privateKey)\nDNS = \(dnsStr)\n\n[Peer]\nPublicKey = \(publicKey ?? "")\nAllowedIPs = \(allowIPStr)\nEndpoint = \(endpoint ?? "")\nPersistentKeepalive = \(persistentKeepAlive ?? "")\n"
    
      let scannedTunnelConfiguration = try? TunnelConfiguration(
        fromWgQuickConfig: str,
        called: mode
      )
      guard let tunnelConfiguration = scannedTunnelConfiguration else {
        return
      }
      self.saveSafehouseDataToUserDefaults?.setWGProfile(wgProfile: str, region: regionStr, mode: mode)
      self.saveSafehouseDataToUserDefaults?.setLastWGProfileSaveTime(dateObj: Date(), region: regionStr)
      
      addTunnel(tunnelConfiguration: tunnelConfiguration, mode: mode)
    

  }
  
  fileprivate func addTunnel(tunnelConfiguration: TunnelConfiguration, mode: String) {
    
    if !isAddingTunnelConfiguration {
      isAddingTunnelConfiguration = true
        TunnelsManager.create(mode: mode) { [weak self] result in
        guard let self = self else { return }
        
        switch result {
        case .failure:
          self.statusIsConnecting = false
          self.isAddingTunnelConfiguration = false
          
        case let .success(tunnelsManager):
          VPNManager.tunnelsManager = tunnelsManager
          tunnelsManager.add(tunnelConfiguration: tunnelConfiguration,mode: mode) { result in
            switch result {
            case let .failure(error):
              self.isAddingTunnelConfiguration = false
              if error.alertText
                .title == "alertTunnelAlreadyExistsWithThatNameTitle" {
                if !(mode.isEmpty) {
                  if let manager = VPNManager.tunnelsManager, let tunnel = manager.tunnel(named: mode) {
                    tunnelsManager.modify(tunnel: tunnel, tunnelConfiguration: tunnelConfiguration, onDemandOption: .off) { error in
                      if let error = error{
                          debugPrint(error.localizedDescription)
                      } else {
                        self.connectButtonAction(mode: mode)
                      }
                    }
                  } else {
                    self.connectButtonAction(mode: mode)
                  }
                } else {
                  self.connectButtonAction(mode: mode)
                }
              } else {
                self.addTunnelResponseDelegate?.missingVPNConfiguration()
                self.statusIsConnecting = false
              }
            case .success:
              self.isAddingTunnelConfiguration = false
              self.connectButtonAction(mode: mode)
              self.addTunnelResponseDelegate?.tunnelAddedSuccessfully()
            }
          }
        }
      }
    }
  }
}


