//
//  APIConstants.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation

enum ServerUrlEndPoint {
  case antiTheft
  case others
}

enum ServerUrlComponents {
  // Server Base url
  static func getBaseUrl() -> String {
    if K.Server.currentBuild == K.Server.Dev {
      return "https://api-dev.safehousetech.com/"
    } else if K.Server.currentBuild == K.Server.Staging {
      return "https://api-stage.safehousetech.com/"
    } else {
      return "https://api.safehousetech.com/"
    }
  }

  // Server API url end point
  static func getEndPoint() -> String {
    "api/v1/"
  }

  static func getUrlEndpoints(endPoint: ServerUrlEndPoint) -> String {
    switch endPoint {
    case .antiTheft:
      if K.Server.currentBuild == K.Server.Dev {
        return "https://bgapi-dev.safehousetech.com/"
      } else if K.Server.currentBuild == K.Server.Staging {
        return "https://bgapi-stage.safehousetech.com/"
      } else {
        return "https://bgapi.safehousetech.com/"
      }
    case .others:
      return getBaseUrl()
    }
  }
}

enum K {
  enum Server {
    static let Dev = -1
    static let Staging = 0
    static let Production = 1
    // static var currentBuild = UserDefaults.standard.object(forKey: "environment") as? Int ?? Production
    // static var currentBuild = Production

    static var currentBuild: Int = {
      if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
        print("Current_Build = \(configuration)")
        if configuration.range(of: "Debug") != nil {
          return Server.Dev
        } else if configuration.range(of: "Staging") != nil {
          return Server.Staging
        }
      }
      return Server.Production
    }()
  }
}

