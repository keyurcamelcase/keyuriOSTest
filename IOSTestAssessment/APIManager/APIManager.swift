//
//  APIManager.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import Foundation
import UIKit
import Alamofire


//var getPostIDFromNotification:String? = nil
//var notyType: NotyType?

let enviroment = Enviroment.live
let OneSignalAppID = "OneSignal App ID"

enum ResponseError {
    case noData
    case worngData
    
    var errorDescription: String {
        switch self {
        case .noData: return "There is no data available, Please contact support team."
        case .worngData: return "Something went wrong, Please try again later!!!"
        }
    }
}

enum Enviroment {
    case dev
    case live
}

extension Enviroment {
    var HTTPProtocol: String {
        switch self {
        case .dev: return "https://jsonplaceholder.typicode.com"
        case .live: return "https://jsonplaceholder.typicode.com"
        }
    }
}

enum BaseUrl {
    case baseUrl
}

extension BaseUrl {
    var baseUrlString : String {
        switch self {
        case .baseUrl: return enviroment.HTTPProtocol
        }
    }
}


enum MethodType : String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

enum ContentType : String {
    case applicationJson = "application/json"
}

enum APIErrorMsg : String {
    case error_msg = "something went wrong"
}

enum UserDefaultKeys : String {
    case userLoginInfo = "userLoginInfo"
    case appsettingdata = "appsettingdata"
    case onboardingscreen = "onboardingscreen"
}



struct StatusCode: Codable {
    let statusCode: Int
}

struct RequestObj {
    var request: URLRequest
    var completion: ((Result<Data,Error>) -> Void)
}


enum ApiError : Error {
    case errorMsg(message:String)
//    case statuscide(statuscode:Int)
    
    var errorDescription:String {
        switch self {
        case let .errorMsg(message): return message
        }
    }
    
}

public typealias Parameters = [String: Any]

class ApiManager {
    
    static let shared = ApiManager()
    
    //    fileprivate init() { self.setupRefreshTokenListener() }
    
    let session = URLSession.shared
    
    var baseUrl:URL?
    
    var arrQueue: Array<RequestObj> = Array<RequestObj>()
    
    
    private var commonHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [
//            "Authorization":ApiManager.shared.getAuthorization
                        "Content-Type":"application/json"
            //            "Content-Type": "application/x-www-form-urlencoded"
        ]
        // Add any other common headers
        return headers
    }
    
    //    private var commonHeadersForMultipart: HTTPHeaders {
    //        var headers: HTTPHeaders = [
    //            "Authorization": ApiManager.shared.getAuthorization,
    //            "Content-Type": "multipart/form-data"
    ////            "Content-Type": "application/x-www-form-urlencoded"
    //        ]
    //        // Add any other common headers
    //        return headers
    //    }
    
    //    func setupRefreshTokenListener() {
    //        let tokenManager = TokenManager.share
    //        tokenManager.refreshTokenSuccess = {
    //            self.callAPIAfterRefreshToken()
    //        }
    //    }
    
    // MARK: - Request Methods
    
    func get<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true,methodType:HTTPMethod = .get, completion: @escaping (Result<T,Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("commonHeaders ==>%@", commonHeaders)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: methodType, parameters: parameters, headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.response)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                    
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    JSN.log("error ==>%@", error)
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
//                    let decoder = JSONDecoder()
//
//                    do {
//                        let errorModel = try decoder.decode(R.self, from: jsonData)
//                        completion(.failure(errorModel))
//                    } catch {
//                        print(error.localizedDescription)
//                    }
                    
                }
            }
    }
    
    func put<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("commonHeaders ==>%@", commonHeaders)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: .put, parameters: parameters, headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.response)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
                }
            }
    }
    
    func patch<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("commonHeaders ==>%@", commonHeaders)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: .patch, parameters: parameters, headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.response)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
                }
            }
    }
    func putRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("parameter ==>%@", parameters)
        JSN.log("commonHeaders ==>%@", commonHeaders)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: .put, parameters: parameters, headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.request?.allHTTPHeaderFields)
                    JSN.log("URL Request ==>%@", response.response?.url)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                }
             
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    JSN.log("error ==>%@", error)
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
                }
            }
    }
    func post<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("parameter ==>%@", parameters)
        JSN.log("commonHeaders ==>%@", commonHeaders)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: .post, parameters: parameters, headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.request?.allHTTPHeaderFields)
                    JSN.log("URL Request ==>%@", response.response?.url)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                }
             
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    JSN.log("error ==>%@", error)
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
                }
            }
    }
    
    // MARK: - POST Request with Form Data
    
    func postFormData<T: Decodable>(endpoint: String, parameters: Parameters? = nil,isShowLoader:Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(BaseUrl.baseUrl.baseUrlString)\(endpoint)"
        JSN.log("URL ==>%@", url)
        JSN.log("parameter ==>%@", parameters)
        if isShowLoader {
            startLoader()
        }
        AF.request(url, method: .post, parameters: parameters,headers: commonHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                stopLoader()
                if let getreasponseData = response.data {
                    JSN.log("URL Request ==>%@", response.response)
                    JSN.log("reasponse ===>%@", String(data: getreasponseData, encoding: .utf8))
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                    if error.responseCode == 401 {
                        self.sessionTimeOutHandel()
                    }
                }
            }
    }
    
    
    func sessionTimeOutHandel(reasponseMSG:String? = "Your session has timed out. Please log in again.") {
        let errorMessage = reasponseMSG ?? "Your session has timed out. Please log in again."
        let alert = UIAlertController(title: "Session Timeout", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            DispatchQueue.main.async {
                
                
            }
        })
        
        // Present the alert
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}



