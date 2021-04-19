
import Foundation
import UIKit

let APITimeout: Double = 30.0

let WEB_HOST = "https://copd-smart-coach.ml/v1"

enum APIUrl {
    case userApi(type: UserApi)
    case authApi(type: AuthApi)
    case tokenApi(type: TokenApi)
    
    enum UserApi: String {
        case coach = "coach"
        case survey = "survey"
        case borg = "borg"
        
        static func urlWith(type: UserApi, append: String, userId: String? = nil) -> String {
            let base = WEB_HOST
            return "\(base)/user/\(userId ?? "")/\(type.rawValue)\(append)"
        }
    
        func url () -> String {
            return APIUrl.UserApi.urlWith(type: self, append: "", userId: "")
        }
        
        func url(append: String, userId: String? = nil) -> String {
            return APIUrl.UserApi.urlWith(type: self, append: append, userId: userId)
        }
    }
    
    enum AuthApi: String {
        case normal = ""
        
        static func urlWith(type: AuthApi, append: String) -> String {
            let base = WEB_HOST
            return "\(base)/auth/\(type.rawValue)\(append)"
        }
    
        func url () -> String {
            return APIUrl.AuthApi.urlWith(type: self, append: "")
        }
        
        func url(append: String, userId: String? = nil) -> String {
            return APIUrl.AuthApi.urlWith(type: self, append: append)
        }
    }
    
    
    enum TokenApi: String {
        case normal = ""
        
        static func urlWith(type: TokenApi, append: String) -> String {
            let base = WEB_HOST
            return "\(base)/token/\(type.rawValue)\(append)"
        }
    
        func url () -> String {
            return APIUrl.TokenApi.urlWith(type: self, append: "")
        }
        
        func url(append: String, userId: String? = nil) -> String {
            return APIUrl.TokenApi.urlWith(type: self, append: append)
        }
    }
}

