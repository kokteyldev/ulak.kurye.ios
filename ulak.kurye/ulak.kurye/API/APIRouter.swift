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
    case getOrders
    case sendFeedback(message: String)
    
    private enum Encoding {
        case json
        case string
    }
    
    private var method: HTTPMethod {
        switch self {
        case .config,
             .me,
             .getOrders:
            return .get
        case .preLogin,
             .login,
             .updateProfile,
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
        case .getOrders:
            return "/courier/orders"
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
        return nil
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
             .getOrders,
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
                let queryParameterEncodedValue = (queryParameter.value as AnyObject).addingPercentEncoding(withAllowedCharacters: .alphanumerics)
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
                let queryParameterEncodedValue = (queryParameter.value as AnyObject).addingPercentEncoding(withAllowedCharacters: .alphanumerics)
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
