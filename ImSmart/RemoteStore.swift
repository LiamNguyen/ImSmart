//
//  RemoteStore.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /25/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import Alamofire

class RemoteStore {
    static let sharedInstance = RemoteStore()
    
    private let manager = SessionManager()
    
    private init() {
        
    }
    
    func getAllLights(completionHandler: @escaping ((_ allLights: NSArray) -> Void)) {
        let url = URL(string: "\(BaseURL.BETA.rawValue)/lights")
        
        guard let _ = url else {
            print("ERROR: URL error")
            return
        }
        let retrier     = Retrier()
        let request     = manager.request(url!)
        
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
                
                completionHandler(response.result.value as! NSArray)
            case .failure(let error):
                print(error.localizedDescription)
                if let response = response.response {
                    print(response)
                }
            }
        }
    }

    func updateAllLights(lights: String, completionHandler: @escaping ((_ success: Bool) -> Void)) {
        let url = URL(string: "\(BaseURL.BETA.rawValue)/lights")
        
        guard let _ = url else {
            print("ERROR: URL error")
            return
        }
        
        var urlRequest          = URLRequest(url: url!)
        urlRequest.httpMethod   = "PUT"
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
    
    private enum BaseURL: String {
        case BETA = "http://210.211.109.180/imsmart/api/index.php"
    }
}
