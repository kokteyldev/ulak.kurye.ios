//
//  Router.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit
import Alamofire

enum APIRouter {
    case config
    case preLogin(phoneNumber: String)
    case login(code: String, phoneNumber: String)
    case me
    case updateProfile(name: String?, surname: String?)
    case updateCardNumber(cardNumber: String)
    case updateLocation(lat: Double, lng: Double, batteryLevel: Double, accuracy: Double)
    case updateNotificationId(oneSignalId: String?)
    case updateUserSettings(isNotificationAllowed: Bool, isPoolNotificationAllowed: Bool)
    case getOrder(orderUUID: String)
    case getOrders(status: String)
    case getPoolOrders(latitude: Double, longtitude: Double)
    case getOrderAggrements(orderUUID: String)
    case getOrderActions(orderUUID: String, agreementUUID: String)
    case talkTo(orderUUID: String, to: String)
    case runTakeAction(orderUUID: String, agreementUUID: String)
    case runOrderAction(actionName: String, parameters: [String: String])
    case getWallet(walletUUID: String)
    case transferBalance(walletUUID: String, amount: Double)
    case sendFeedback(message: String)
    
    private enum Encoding {
        case json
        case string
    }
    
    private var method: HTTPMethod {
        switch self {
        case .config,
             .me,
             .getOrder,
             .getOrders,
             .getOrderAggrements,
             .getOrderActions,
             .talkTo,
             .getPoolOrders,
             .runTakeAction,
             .runOrderAction,
             .getWallet:
            return .get
        case .preLogin,
             .login,
             .updateProfile,
             .updateCardNumber,
             .updateLocation,
             .updateNotificationId,
             .updateUserSettings,
             .transferBalance,
             .sendFeedback:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .config:
            return "/init"
        case .preLogin:
            return "/auth/login"
        case .login:
            return "/auth/login-verify"
        case .me:
            return "/user/me"
        case .updateProfile:
            return "/user/update-profile"
        case .updateCardNumber:
            return "/ininal/update-card-number"
        case .updateLocation:
            return "/user/update-location"
        case .updateNotificationId:
            return "/user/update-notification-settings"
        case .updateUserSettings:
            return "/user/update-notification-settings"
        case .getOrder:
            return "/courier/order-search"
        case .getOrders:
            return "/courier/orders"
        case .getPoolOrders:
            return "/courier/order-pool"
        case .getOrderAggrements:
            return "/actions/agreements"
        case .getOrderActions:
            return "/actions/available"
        case .talkTo:
            return "/order/talk"
        case .runTakeAction:
            return "/actions/run"
        case .runOrderAction:
            return "/actions/run"
        case .getWallet(let walletUUID):
            return "/wallet/\(walletUUID)"
        case .transferBalance:
            return "/courier/earn-money"
        case .sendFeedback:
            return "/feedback"
        }
    }
    
    private var encoding: Encoding {
        switch self {
        default:
            return .json
        }
    }
    
    private var queryParameters: [String: Any]? {
        switch self {
        case .getOrder(let orderUUID):
            return ["query": orderUUID]
        case .getOrders(let status):
            return ["app_status": status]
        case .getPoolOrders(let latitude, let longtitude):
            return ["lat": latitude, "lng": longtitude]
        case .getOrderAggrements(let orderUUID):
            return ["order_uuid": orderUUID]
        case .getOrderActions(let orderUUID, let agreementUUID):
            return ["order_uuid": orderUUID, "agreement_uuid": agreementUUID]
        case .talkTo(let orderUUID, let to):
            return ["order_uuid": orderUUID, "to": to]
        case .runTakeAction(let orderUUID, let agreementUUID):
            return ["action_name": "take", "order_uuid": orderUUID, "agreement_uuid": agreementUUID]
        case .runOrderAction(let actionName, let paramaters):
            var params = paramaters
            params["action_name"] = actionName
            return params
        default:
            return nil
        }
    }
    
    private var parameters: [String: Any?]? {
        switch self {
        case .preLogin(let phoneNumber):
            return ["phone_number": phoneNumber]
        case .login(let code, let phoneNumber):
            return [
                "code": code,
                "phone_number": phoneNumber
            ]
        case .updateProfile(let name, let surname):
            return [
                "name": name,
                "surname": surname
            ]
        case .updateCardNumber(let cardNumber):
            return [
                "barcode": cardNumber
            ]
        case .updateLocation(let lat, let lng, let batteryLevel, let accuracy):
            return [
                "lat": lat,
                "lng": lng,
                "battery_rate": batteryLevel,
                "accuracy": accuracy
            ]
        case .updateNotificationId(let oneSignalId):
            return [
                "onesignal_id": oneSignalId
            ]
        case .updateUserSettings(let isNotificationAllowed, let isPoolNotificationAllowed):
            return [
                "allow_notification": isNotificationAllowed,
                "allow_pool_notification": isPoolNotificationAllowed
            ]
        case .transferBalance(let walletUUID, let amount):
            return [
                "wallet_uuid": walletUUID,
                "amount": amount
            ]
        case .sendFeedback(let message):
            return ["message": message]
        default:
            return nil
        }
    }
    
    private var headers: [String: String]? {
        switch self {
        case .me,
             .updateProfile,
             .updateCardNumber,
             .updateLocation,
             .updateNotificationId,
             .updateUserSettings,
             .getOrder,
             .getOrders,
             .getPoolOrders,
             .getOrderAggrements,
             .getOrderActions,
             .talkTo,
             .runTakeAction,
             .runOrderAction,
             .getWallet,
             .transferBalance,
             .sendFeedback:
            return [
                "Authorization": "Bearer \(Session.shared.token ?? "")",
                "Accept-Language": Constants.languageCode
            ]
        default:
            return nil
        }
    }
}

extension APIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var endpoint: String = Constants.API.apiURL.appending(path)
        
        if let queryParameters = queryParameters {
            var isFirstParam: Bool = true
            for queryParameter in queryParameters {
                let queryParameterEncodedKey = queryParameter.key.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                let queryParameterEncodedValue = ("\(queryParameter.value)" as AnyObject).addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                if isFirstParam {
                    isFirstParam = false
                    endpoint.append("?\(queryParameterEncodedKey ?? "")=\(queryParameterEncodedValue ?? "")")
                } else {
                    endpoint.append("&\(queryParameterEncodedKey ?? "")=\(queryParameterEncodedValue ?? "")")
                }
            }
        }
        
        var request: URLRequest = URLRequest(url: URL(string: endpoint)!)
        
        request.httpMethod = method.rawValue
        
        // common headers
        request.addValue(Constants.API.apiKey, forHTTPHeaderField: "X-Api-Key")
        
        if encoding == .json {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let parameters = parameters {
            if encoding == .json {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    Log.e("Request body parse: \(error.localizedDescription)")
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            } else if encoding == .string {
                if let postString = parameters.queryString {
                    request.httpBody = postString.data(using: .utf8);
                }
            }
        }
        
        return request
    }
}

extension APIRouter {
    func logString() -> String {
        let path: String = path
        let headers: String = String(describing: headers)
        let httpMethod: String = String(describing: method.rawValue)
        var body: String = ""
        var bodyStrings: [String] = []
        
        if let parameters = parameters {
            for (_, value) in parameters.enumerated() {
                bodyStrings.append("\(value.key): \(type(of: value))(\(value))")
            }
            body = bodyStrings.joined(separator: ", ")
        }
        
        
        var log: String = "[-------------\n\(Constants.API.apiURL.appending(path))]"
        
        if method == .get, let queryParameters = queryParameters {
            var endpoint: String = Constants.API.apiURL.appending(path)
            
            var isFirstParam: Bool = true
            for queryParameter in queryParameters {
                let queryParameterEncodedKey = queryParameter.key.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                let queryParameterEncodedValue = "\(queryParameter.value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                if isFirstParam {
                    isFirstParam = false
                    endpoint.append("?\(queryParameterEncodedKey ?? "")=\(queryParameterEncodedValue ?? "")")
                } else {
                    endpoint.append("&\(queryParameterEncodedKey ?? "")=\(queryParameterEncodedValue ?? "")")
                }
            }
            
            log = log + "\n\(endpoint)"
        }
        
        if !headers.isEmpty {
            log = log + "\n\(headers)"
        }
        
        log = log + "\n[\(httpMethod)]"
        
        if !body.isEmpty {
            log = log + "\n[\(body)]"
        }
        log = log + "\n-------------"
        
        return log
    }
}
