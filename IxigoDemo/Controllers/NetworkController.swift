//
//  NetworkController.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController: NSObject {
    
    static var shared = NetworkController(isBackground: false)
    var manager : Alamofire.SessionManager
    var configuration : URLSessionConfiguration
    
    init(isBackground: Bool) {
        #if DEBUG
        configuration = URLSessionConfiguration.default
        #else
        configuration = URLSessionConfiguration.default
        #endif
        
        configuration.timeoutIntervalForRequest = 60
        
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    var numberOfRequests = 0
    
    func startNetworkIndicator() {
        if numberOfRequests == 0 {
            Utils.performMain {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        numberOfRequests += 1
    }
    
    func stopNetworkIndicator() {
        numberOfRequests -= 1
        
        if numberOfRequests < 0 {
            numberOfRequests = 0
        }
        
        Utils.performAfter(0.5) {
            if self.numberOfRequests == 0 {
                Utils.performMain {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    
    @discardableResult
    func startRequest(urlString: String, params: [String: Any], httpMethod : String, completion: @escaping (SwiftResult<[String: Any], NSError>) -> Void) -> DataRequest {
        var method = HTTPMethod.get
        var encoding: ParameterEncoding = URLEncoding.default
        
        if httpMethod == "POST" {
            method = HTTPMethod.post
            encoding = JSONEncoding.default
        } else if httpMethod == "PUT" {
            method = HTTPMethod.put
        } else if httpMethod == "DELETE" {
            method = HTTPMethod.delete
        } else if httpMethod == "GET" {
            method = HTTPMethod.get
        }
        
        let alamofireRequest = manager.request(urlString, method: method, parameters: params.count > 0 ? params : nil, encoding: encoding, headers: nil)
        
        if NetworkReachabilityManager()!.isReachable {
            startNetworkIndicator()
            
            alamofireRequest.response { (dataResponse) in
                self.stopNetworkIndicator()
                
                if let error = dataResponse.error {
                    completion(.failure(error as NSError))
                } else {
                    var jsonObject = [String: Any]()
                    
                    if let data = dataResponse.data {
                        do {
                            jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                            completion(.success(jsonObject))
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            completion(.success([:]))
                        }
                    }
                }
                
            }
        } else {
            completion(.failure(networkError))
        }
        
        return alamofireRequest
    }
    
    @discardableResult
    func GET(_ endPoint: String, parameters: [String : Any], completion: @escaping (SwiftResult<[String: Any], NSError>) -> Void) -> DataRequest {
        
        return startRequest(urlString: kBaseURL + endPoint, params: parameters, httpMethod: "GET", completion: { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
