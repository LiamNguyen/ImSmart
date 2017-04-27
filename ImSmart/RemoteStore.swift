//
//  RemoteStore.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /25/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class RemoteStore {
    static let sharedInstance = RemoteStore()
    
    private init() {
        
    }
    
    func getAllLights(lightViewModel: LightViewModel, completionHandler: @escaping ((_ allLights: [LightCellViewModel]) -> Void)) {
        let url     = URL(string: "\(BaseURL.BETA.rawValue)/lights")
        
        guard let _ = url else {
            print("URL error")
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, error == nil else {
                print("Error in server response\nError: \(String(describing: error))")
                return
            }
            
            if data?.count == 0 {
                print("Server return no data")
                return
            }
            
            let allLights = Helper.parseJSONToLightCellViewModel(data: data!, lightViewModel: lightViewModel)
            completionHandler(allLights)
        }.resume()
    }
    
    func updateAllLights(lights: String, completionHandler: @escaping ((_ success: Bool) -> Void)) {
        let url = URL(string: "\(BaseURL.BETA.rawValue)/lights")
        
        guard let _ = url else {
            print("URL error")
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = lights.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var statusCode = Constants.HttpStatusCode.noContent

            guard let _ = data, error == nil else {
                print("Error in server response\nError: \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status code: \(httpStatus.statusCode)")
                
                if httpStatus.statusCode >= 400 {
                    print("response = \n\(String(describing: response))")
                }
                statusCode = httpStatus.statusCode
                
                if statusCode == Constants.HttpStatusCode.methodNotAllowed {
                    print("Try different http method ;)")
                    return
                }
            }
            
            if statusCode == Constants.HttpStatusCode.success {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
            if data?.count == 0 {
                print("Server return no data")
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print("Response from server:\n\(String(describing: response))")
            } catch {
                print("Error when decoding response")
            }
            
        }.resume()
        
    }
    
    private enum BaseURL: String {
        case BETA = "http://210.211.109.180/imsmart/api/index.php"
    }
}
