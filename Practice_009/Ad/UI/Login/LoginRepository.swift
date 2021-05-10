import UIKit
import RxSwift

class LoginRepository {
    static let shared = LoginRepository()
    
    func getLoginResult(email: String, password: String) -> Single<LoginResult> {
        let api = APIManager.shared.getLoginResult(email: email, password: password)
        return api
            .map{ LoginResult(JSON: $0)! }
            .flatMap{ response -> Single<LoginResult> in
                return self.procressToken(loginResult: response)
            }
    }
    
    var localAuthorizationData: Single<(userID: String?, roles: AdminOrUser)> {
        let authorization = UserDefaultUtil.shared.adminAuthorization
        if authorization == nil {
            //MARK: 手機紀錄中沒有
            return Single.error(APIError.init(type: .apiUnauthorizedException, localDesc: "Unauthorized", alertMsg: "Unauthorized"))
        }
        
        //MARK: 如果過期，刪除且用RefreshToken再要一次
        let now = Date()
        let nowTimeStamp = now.timeIntervalSince1970
        
        //MARK: 提早一小時去要
        let adminExpireIn = UserDefaultUtil.shared.adminExpireIn!
        //記得改大於
        if nowTimeStamp + (60 * 60) > adminExpireIn {
            //MARK: 清除Local UserDefault，且重要token
            let refreshToken = UserDefaultUtil.shared.adminRefreshToken!
            setLocalAdminLoginResult(nil)
            //MARK: 重要
            let api = APIManager.shared.getLoginResultWithRefreshToken(refreshToken)
            return api
                    .map{ LoginResult(JSON: $0)! }
                    .flatMap{ response -> Single<LoginResult> in
                        return self.procressToken(loginResult: response)
                    }
                .map({ loginResult in (userID: loginResult.data!.userId, roles: loginResult.data!.roles!) })
        } else {
            //MARK: 沒有過期
            let userID = UserDefaultUtil.shared.adminUserID
            let roles = AdminOrUser(rawValue: UserDefaultUtil.shared.adminRoles!)!
            return Single.just((userID: userID, roles: roles))
        }
    }
    
    private func procressToken(loginResult: LoginResult) -> Single<LoginResult> {
        if loginResult.status == "Success" {
            setLocalAdminLoginResult(loginResult)
        } else {
            setLocalAdminLoginResult(nil)
        }
 
        return Single.just(loginResult)
    }
    
    func setLocalAdminLoginResult(_ loginResult: LoginResult?) {
        if loginResult == nil {
            UserDefaultUtil.shared.adminAuthorization = nil
            UserDefaultUtil.shared.adminRefreshToken = nil
            UserDefaultUtil.shared.adminUserID = nil
            UserDefaultUtil.shared.adminExpireIn = nil
            UserDefaultUtil.shared.adminRoles = nil
            return
        }
        
        UserDefaultUtil.shared.adminAuthorization = loginResult!.data!.session!.token!
        UserDefaultUtil.shared.adminRefreshToken = loginResult!.data!.session!.refreshToken!
        UserDefaultUtil.shared.adminUserID = loginResult!.data!.userId
        UserDefaultUtil.shared.adminRoles = loginResult!.data!.roles!.rawValue
        var now = Date()
        let expireIn = loginResult!.data!.session!.expireIn!
        now.addTimeInterval(expireIn)
        UserDefaultUtil.shared.adminExpireIn = now.timeIntervalSince1970
    }
}
