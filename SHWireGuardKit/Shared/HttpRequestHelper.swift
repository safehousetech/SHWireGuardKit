//
//  HttpRequestHelper.swift
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

import Foundation

public class HttpRequestHelper {
    
    public func postRequest(
        urlString: String,
        parameters: [String: Any],
        authToken: String?,
        requestType: String = "POST", // Default to POST, you can change it as needed
        completion: @escaping (Bool, Data?, Int?) -> ()
    ) {
        guard let url = URL(string: urlString) else {
            completion(false, nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        
        // Set headers
        let header = makeHeaderForRequest(authToken: authToken)
        for (key, value) in header {
            request.addValue(value, forHTTPHeaderField: key)
        }
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Set Content-Type header
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set request body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "Empty")")
        } catch {
            completion(false, nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("the post response: \(String(describing: response))")
                
                if let data = data {
                    completion(true, data, statusCode)
                } else {
                    completion(false, nil, statusCode)
                }
            }  else {
                completion(false, nil, nil)
            }
        }
        
        task.resume()
    }
    
    public func getRequest(
        urlString: String,
        parameters: [String: Any],
        authToken: String?,
        customHeader: [String: String]? = nil,
        completion: @escaping (Bool, Data?, Int?) -> ()
    ) {
        guard let url = URL(string: urlString) else {
            completion(false, nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        var headers: [String: String] = [
            "Accept": "application/json",
        ]

        if let token = authToken {
            headers["Authorization"] = "Bearer " + token
        }

        if let customHeader = customHeader {
            headers.merge(customHeader) { _, new in new }
        }

        request.allHTTPHeaderFields = headers

        print("Request URL: \(url)")
        print("Request Headers: \(headers)")
        print("Request Parameters: \(parameters)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("Response Status Code: \(statusCode)")

                if let data = data {
                    if statusCode == 200 || statusCode == 201 {
                        completion(true, data, statusCode)
                    } else {
                        print("Error Response Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        completion(false, data, statusCode)
                    }
                } else {
                    completion(false, nil, statusCode)
                }
            }
        }
        task.resume()
    }

    
    private func makeHeaderForRequest(authToken: String?) -> [String: String] {
        var headers: [String: String] = [:]
        
        if let token = authToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}



