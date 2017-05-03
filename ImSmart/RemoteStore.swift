//
//  RemoteStore.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /25/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import Alamofire

class RemoteStore: StoreType {

    static let sharedInstance = RemoteStore()
    
    private let manager = SessionManager()
    
    private let baseURL             : URL!
    private let lightURL            : URL!
    private let airConditionerURL   : URL!
    
    private init() {
        self.baseURL            = BaseURL.BETA
        self.lightURL           = URL(string: "lights", relativeTo: self.baseURL)!
        self.airConditionerURL  = URL(string: "airconditioners", relativeTo: self.baseURL)!
    }
    
//    **MARK: LIGHTS RELATED ENDPOINTS HANDLER
    
    func getAllLights(completionHandler: @escaping (_ allLights: NSArray, _ error: String) -> Void) {
        let retrier     = Retrier()
        let request     = manager.request(self.lightURL)
        
        manager.retrier = retrier
        retrier.addRetryInfo(request: request)
        
        request.response { _ in
            retrier.deleteRetryInfo(request: request)
            }.validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let _ = response.result.value as? NSArray else {
                        print("ERROR: Response is in the wrong type")
                        return
                    }
                    
                    completionHandler(response.result.value as! NSArray, "")
                case .failure(let error):
                    print(error.localizedDescription)
                    if let response = response.response {
                        print(response)
                    }
                    completionHandler([], "ERROR")
                }
        }
    }

    func updateAllLights(lights: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        var urlRequest          = URLRequest(url: self.lightURL)
        urlRequest.httpMethod   = "POST"
        urlRequest.httpBody     = lights.data(using: .utf8)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let retrier = Retrier()
        let request = manager.request(urlRequest)
        
        manager.retrier = retrier
        retrier.addRetryInfo(request: request)
        
        request.response { _ in
            retrier.deleteRetryInfo(request: request)
        }.validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(true)
                print(response)
            case .failure(let error):
                completionHandler(false)
                print(error.localizedDescription)
                if let response = response.response {
                    print(response)
                }
            }
        }
    }
    
//    **MARK: AIR CONDITIONERS RELATED ENDPOINTS HANDLER

    func getAllAirConditioners(completionHandler: @escaping (_ allAirConditioners: NSArray, _ error: String) -> Void) {
        let retrier = Retrier()
        let request = manager.request(self.airConditionerURL)
        
        manager.retrier = retrier
        retrier.addRetryInfo(request: request)
        
        request.response { _ in
            retrier.deleteRetryInfo(request: request)
            }.validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let _ = response.result.value as? NSArray else {
                        print("ERROR: Response is in the wrong type")
                        return
                    }
                    
                    completionHandler(response.result.value as! NSArray, "")
                case .failure(let error):
                    print(error.localizedDescription)
                    if let response = response.response {
                        print(response)
                    }
                    completionHandler([], "ERROR")
                }
        }
    }
    
    func updateAllAirConditioners(allAirConditioners: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        var urlRequest          = URLRequest(url: self.airConditionerURL)
        urlRequest.httpMethod   = "POST"
        urlRequest.httpBody     = allAirConditioners.data(using: .utf8)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let retrier = Retrier()
        let request = manager.request(urlRequest)
        
        manager.retrier = retrier
        retrier.addRetryInfo(request: request)
        
        request.response { _ in
            retrier.deleteRetryInfo(request: request)
            }.validate().responseJSON { response in
                switch response.result {
                case .success:
                    completionHandler(true)
                    print(response)
                case .failure(let error):
                    completionHandler(false)
                    print(error.localizedDescription)
                    if let response = response.response {
                        print(response)
                    }
                }
        }
    }
    
    private struct BaseURL {
        static let BETA = URL(string: "http://210.211.109.180/imsmart/api/index.php/")
    }
}
