//
//  VPNService.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import UIKit

public class VPNService {
  let jsonDecoder = JSONDecoder()
  private let vpnConfig = "wireguard/peerConfig"
  private let vpnRegion = "wireguard/region"

  public func connectVPN(
    publicKey: String,
    region: String,
    mode: String,
    authToken: String,
    completion: @escaping (Bool, ConnectResult?, Int?) -> ()
  ) {
    let parameters = ["publicKey": publicKey, "region": region, "mode": mode]
    let url = ServerUrlComponents.getBaseUrl() + ServerUrlComponents.getEndPoint() + vpnConfig
    HttpRequestHelper()
      .postRequest(
        urlString: url,
        parameters: parameters,
        authToken: authToken
      ) { success, dataResult, statusCode in
        if success {
          if let vpnData = dataResult {
            do {
                let responseString = String(data: vpnData, encoding: .utf8)
                    print("Response Body: \(responseString ?? "No data")")

              let vpnserver = try self.jsonDecoder.decode(ConnectResult.self, from: vpnData)
              completion(true, vpnserver, statusCode)
            } catch {
              completion(false, nil, statusCode)
            }
          } else {
            completion(false, nil, statusCode)
          }
        } else {
          completion(false, nil, statusCode)
        }
      }
  }
    
   public func getVPNServerRegions(authToken: String,latitude: String,longitude: String,completion: @escaping (Bool, [VPNRegionModel], Int?) -> ()) {
      let url = ServerUrlComponents.getBaseUrl() + ServerUrlComponents.getEndPoint() + vpnRegion
        let customHeader: [String: String] = [
        "Accept": "application/json",
        "Authorization": "Bearer " + authToken,
        "x-client-location": "\(latitude),\(longitude)",
      ]


       HttpRequestHelper()
        .getRequest(
          urlString: url,
          parameters: [:],
          authToken: authToken,
          customHeader: customHeader
        ) { _, jsonData, statusCode in

          if let data = jsonData {
            do {
              let vpnserver = try self.jsonDecoder.decode([VPNRegionModel].self, from: data)
              completion(true, vpnserver, statusCode)
            } catch {
            
              completion(false, [], statusCode)
            }
          } else {
            completion(false, [], statusCode)
          }
        }
    }
}


