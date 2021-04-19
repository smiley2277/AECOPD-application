
import UIKit

struct APIError: Error {
    enum ErrorType {
        case apiFailException
        case apiFailForUserException
        case apiForbiddenException
        case apiUnauthorizedException
        case noInternetException
        case otherException
        case requestTimeOut
    }
    internal let type:ErrorType
    internal let localizedDescription:String
    internal let alertMsg:String
    
    init(type: ErrorType, localDesc: String, alertMsg: String) {
        self.type = type
        self.localizedDescription = localDesc
        self.alertMsg = alertMsg
    }
    
    init(statusCode: Int?, errorCode: Int , localDesc: String, alertMsg: String) {
        switch statusCode {
        case 401:
            self.init(type: .apiUnauthorizedException, localDesc: localDesc, alertMsg: alertMsg)
            
        case 403:
            self.init(type: .apiForbiddenException, localDesc: localDesc, alertMsg: alertMsg)
            
        case 400:
            self.init(type: .apiFailException, localDesc: localDesc, alertMsg: alertMsg)
            
        case 412:
            self.init(type: .apiFailForUserException, localDesc: localDesc, alertMsg: alertMsg)
            
        case 500:
            self.init(type: .apiFailException, localDesc: localDesc, alertMsg: alertMsg)
            
        case nil:
            if (errorCode == URLError.notConnectedToInternet.rawValue) {
                self.init(type: .noInternetException, localDesc: localDesc, alertMsg: alertMsg)
                
            } else if errorCode == URLError.timedOut.rawValue {
                self.init(type: .requestTimeOut, localDesc: localDesc, alertMsg: alertMsg)
            } else {
                self.init(type: .apiFailException, localDesc: localDesc, alertMsg: alertMsg)
            }
            
        default:
            self.init(type: .apiFailException, localDesc: localDesc, alertMsg: alertMsg)
            
        }
    }
}

