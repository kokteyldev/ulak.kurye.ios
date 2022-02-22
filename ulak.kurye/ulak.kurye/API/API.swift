//
//  RequestManager.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation
import Alamofire

struct API {
    static let baseURL: String = Session.shared.baseURL()
    
    static func config(completion:@escaping (Result<Config, Error>) -> Void) {
        performRequest(route: APIRouter.config) { (result:(Result<Response<Config?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let config = response.data {
                    completion(.success(config!))
                } else {
                    completion(.failure(CustomError.noData.error))
                }
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func sendFeedback(message: String, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.sendFeedback(message: message)) { (result:(Result<Response<Bool?>, Error>)) in
            switch result {
            case Result.success(_):
                completion(.success(true))
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func preLogin(phoneNumber: String, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.preLogin(phoneNumber: phoneNumber)) { (result:(Result<Response<Bool?>, Error>)) in
            switch result {
            case Result.success(_):
                completion(.success(true))
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func login(code: String, phoneNumber: String, completion:@escaping(Result<LoginResponse, Error>) -> Void) {
        performRequest(route: APIRouter.login(code: code, phoneNumber: phoneNumber)) { (result:(Result<Response<LoginResponse?>, Error>)) in
            
            switch result {
            case Result.success(let response):
                if let loginResponse = response.data, loginResponse?.tokenString != nil {
                    completion(.success(loginResponse!))
                } else {
                    completion(.failure(CustomError.noData.error))
                }
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func me(completion:@escaping (Result<User, Error>) -> Void) {
        performRequest(route: APIRouter.me) { (result:(Result<Response<User?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let user = response.data {
                    completion(.success(user!))
                } else {
                    completion(.failure(CustomError.noData.error))
                }
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func updateProfile(name: String?, surname: String?, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.updateProfile(name: name, surname: surname)) { (result:(Result<Response<Bool?>, Error>)) in
            switch result {
            case Result.success(_):
                completion(.success(true))
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}

extension API {
    private static func performRequest<T:Codable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<Response<T>, Error>) -> Void) {
        
        APILogger.log(route)
        
         AF.request(route).response { response in
            if let error = response.error {
                completion(Result.failure(error))
                return
            }

            switch response.result {
            case let .success(data):
                Log.d("Response status code: \(response.response?.statusCode ?? 0)")
                
                if response.response?.statusCode == 401 {
                    Session.shared.logout()
                    PreLoginVC.presentAsRoot()
                    return
                }
                
                guard let data = data else {
                    completion(Result.failure(CustomError.noResponseData.error))
                    return
                }
                
                guard let responseModel = try? decoder.decode(Response<T>.self, from: data) else {
                    completion(Result.failure(CustomError.invalidData.error))
                    return
                }

                if responseModel.meta.flag != "success" {
                    let error = NSError.error(Constants.errorDomain, message: responseModel.meta.message, code: responseModel.meta.code)
                    completion(Result.failure(error))
                    return
                }
                
                completion(Result.success(responseModel))
            case let .failure(error):
                completion(Result.failure(error))
            }
        }
    }
}
