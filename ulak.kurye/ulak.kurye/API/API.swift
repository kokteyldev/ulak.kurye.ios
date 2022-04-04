//
//  RequestManager.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation
import Alamofire

struct API {
    static let baseURL: String = Constants.API.apiURL
    
    // MARK: - App
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
    
    // MARK: - Auth
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
    
    static func updateCardNumber(cardNumber: String, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.updateCardNumber(cardNumber: cardNumber)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    static func updateLocation(lat: Double, lng: Double, batteryLevel: Double, accuracy: Double, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.updateLocation(lat: lat, lng: lng, batteryLevel: batteryLevel, accuracy: accuracy)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    static func updateNotificationId(oneSignalId: String?, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.updateNotificationId(oneSignalId: oneSignalId)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    static func updateUserSettings(isNotificationAllowed: Bool, isPoolNotificationAllowed: Bool, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.updateUserSettings(isNotificationAllowed: isNotificationAllowed, isPoolNotificationAllowed: isPoolNotificationAllowed)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    // MARK: - Orders
    static func getOrder(orderUUID: String, completion:@escaping (Result<Order, Error>) -> Void) {
        performRequest(route: APIRouter.getOrder(orderUUID: orderUUID)) { (result:(Result<Response<[Order]?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let orderResponse = response.data, orderResponse!.count > 0 {
                    completion(.success(orderResponse![0]))
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
    
    static func getOrders(status: String, completion:@escaping (Result<GetOrderResponse, Error>) -> Void) {
        performRequest(route: APIRouter.getOrders(status: status)) { (result:(Result<Response<GetOrderResponse?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let orderResponse = response.data {
                    completion(.success(orderResponse!))
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
    
    static func getPoolOrders(latitude: Double, longtitude: Double, completion:@escaping (Result<[Order], Error>) -> Void) {
        performRequest(route: APIRouter.getPoolOrders(latitude: latitude, longtitude: longtitude)) { (result:(Result<Response<[Order]?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let orders = response.data {
                    completion(.success(orders!))
                } else {
                    completion(.success([]))
                }
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func getOrderAgreements(orderUUID: String, completion:@escaping (Result<GetAggrementsResponse, Error>) -> Void) {
        performRequest(route: APIRouter.getOrderAggrements(orderUUID: orderUUID)) { (result:(Result<Response<GetAggrementsResponse?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let agreementResponse = response.data {
                    completion(.success(agreementResponse!))
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
    
    static func getOrderActions(orderUUID: String, agreementUUID: String, completion:@escaping (Result<GetOrderActionsResponse, Error>) -> Void) {
        performRequest(route: APIRouter.getOrderActions(orderUUID: orderUUID, agreementUUID: agreementUUID)) { (result:(Result<Response<GetOrderActionsResponse?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let agreementResponse = response.data {
                    completion(.success(agreementResponse!))
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
    
    //MARK: - Notifications
    static func getNotifications(page: Int, notification_type: Int, completion:@escaping (Result<SystemNotificationResponse, Error>) -> Void) {
        performRequest(route: APIRouter.getNotifications(page: page, notification_type: notification_type)) {
            (result:(Result<Response<SystemNotificationResponse>, Error>)) in
            switch result {
            case Result.success(let response):
                if let notificationsResponse = response.data {
                    completion(.success(notificationsResponse))
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
    
    static func talkTo(orderUUID: String, to: String, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.talkTo(orderUUID: orderUUID, to: to)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    // MARK: - Actions
    static func runTakeAction(orderUUID: String, agreementUUID: String, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.runTakeAction(orderUUID: orderUUID, agreementUUID: agreementUUID)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    static func runOrderAction(actionName: String, params: [String: String], completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.runOrderAction(actionName: actionName, parameters: params)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    // MARK: - Wallets
    static func getWallet(walletUUID: String, completion:@escaping (Result<WalletResponse?, Error>) -> Void) {
        performRequest(route: APIRouter.getWallet(walletUUID: walletUUID)) { (result:(Result<Response<WalletResponse?>, Error>)) in
            switch result {
            case Result.success(let response):
                if let walletResponse = response.data {
                    completion(.success(walletResponse))
                } else {
                    completion(.success(nil))
                }
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    static func transferBalance(walletUUID: String, amount: Double, completion:@escaping (Result<Bool, Error>) -> Void) {
        performRequest(route: APIRouter.transferBalance(walletUUID: walletUUID, amount: amount)) { (result:(Result<Response<Bool?>, Error>)) in
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
    
    // MARK: - Utils    
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
