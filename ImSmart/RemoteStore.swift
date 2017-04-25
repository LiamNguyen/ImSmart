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
        let url     = URL(string: "\(BaseURL.UAT.rawValue)/lights")
        
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
            
            let light = Helper.parseJSONToLightCellViewModel(data: data!, lightViewModel: lightViewModel)
            completionHandler(light)
        }.resume()
    }
    
    private enum BaseURL: String {
        case UAT = "http://210.211.109.180/imsmart/api/index.php"
    }
}
