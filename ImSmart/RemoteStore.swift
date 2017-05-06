//
//  RemoteStore.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /25/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class RemoteStore: StoreType {

    static let sharedInstance = RemoteStore()
    
    fileprivate let manager = SessionManager()
    
    fileprivate let baseURL             : URL!
    fileprivate let getLightURL         : URL!
    fileprivate let updateLightURL      : URL!
    fileprivate let airConditionerURL   : URL!
    
    fileprivate init() {
        self.baseURL            = BaseURL.BETA
        self.getLightURL        = URL(string: "lights", relativeTo: self.baseURL)!
        self.updateLightURL     = URL(string: "update/lights", relativeTo: self.baseURL)!
        self.airConditionerURL  = URL(string: "airconditioners", relativeTo: self.baseURL)!
    }
    
//    **MARK: LIGHTS RELATED ENDPOINTS HANDLER
    
    func getAllLights(_ completionHandler: @escaping (_ allLights: [LightModel], _ error: String?) -> Void) {
        let retrier = Retrier()
        let request = requestBuilder(retrier, requestMethod: .GET, url: self.getLightURL)
        
        request.response { _ in
            retrier.deleteRetryInfo(request)
            }.validate().responseArray { (response: DataResponse<[LightModel]>) in
                switch response.result {
                case .success:
                    if let allLightsArray = response.result.value {
                        completionHandler(allLightsArray, nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let response = response.response {
                        print(response)
                    }
                    completionHandler([], "ERROR")
                }
        }
    }

    func updateAllLights(_ lights: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let retrier = Retrier()
        let request = requestBuilder(retrier, requestMethod: .POST, url: self.updateLightURL, requestBody: lights)
        
        request.response { _ in
            retrier.deleteRetryInfo(request)
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

    func getAllAirConditioners(_ completionHandler: @escaping (_ allAirConditioners: [AirConditionerModel], _ error: String?) -> Void) {
        let retrier = Retrier()
        let request = requestBuilder(retrier, requestMethod: .GET, url: self.airConditionerURL)
        
        request.response { _ in
            retrier.deleteRetryInfo(request)
            }.validate().responseArray { (response: DataResponse<[AirConditionerModel]>) in
                switch response.result {
                case .success:
                    if let allAirConditionersArray = response.result.value {
                        completionHandler(allAirConditionersArray, nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let response = response.response {
                        print(response)
                    }
                    completionHandler([], "ERROR")
                }
        }
    }
    
    func updateAllAirConditioners(_ allAirConditioners: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let retrier = Retrier()
        let request = requestBuilder(retrier, requestMethod: .POST, url: self.airConditionerURL, requestBody: allAirConditioners)
        
        request.response { _ in
            retrier.deleteRetryInfo(request)
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
    
    func requestBuilder(_ retrier: Retrier, requestMethod: RequestMethod, url: URL, requestBody: String = "") -> DataRequest {
        if requestMethod != .GET && requestBody.isEmpty {
            print("\nERROR: Missing request body for \(requestMethod.rawValue) \n")
        }
        var urlRequest          = URLRequest(url: url)
        urlRequest.httpMethod   = requestMethod.rawValue

        switch requestMethod {
        case .POST, .PUT, .PATCH:
            urlRequest.httpBody = requestBody.data(using: .utf8)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .GET:
            break
        }
        
        let request     = manager.request(urlRequest)
        manager.retrier = retrier
        retrier.addRetryInfo(request)
        
        return request
    }
    
    enum RequestMethod: String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case PATCH  = "PATCH"
    }
    
    struct BaseURL {
        static let BETA = URL(string: "http://210.211.109.180/imsmart/api/index.php/")
    }
}
