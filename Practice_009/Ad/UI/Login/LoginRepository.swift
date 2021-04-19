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
    
    var authorization: Single<String> {
        let authorization = UserDefaultUtil.shared.adminAuthorization
        if authorization == nil {
            //MARK: 手機紀錄中沒有
            return Single.just("")
        }
        
        //MARK: 如果過期，刪除且用RefreshToken再要一次
        let now = Date()
        let nowTimeStamp = now.timeIntervalSince1970
        
        //MARK: 提早一小時去要
        let adminExpireIn = UserDefaultUtil.shared.adminExpireIn!
        if nowTimeStamp + (60 * 60) > adminExpireIn {
            //TODO 清除 and 重要
            setLocalAdminLoginResult(nil)
            //TODO 重要成功
            let api = APIManager.shared.getLoginResultWithRefreshToken()
            return api
                    .map{ LoginResult(JSON: $0)! }
                    .flatMap{ response -> Single<LoginResult> in
                        return self.procressToken(loginResult: response)
                    }
                    .map({ loginResult in loginResult.data!.session!.token! })
            //TODO 重要失敗
            
        } else {
            //MARK: 沒有過期
            return Single.just(authorization!)
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
            return
        }
        
        UserDefaultUtil.shared.adminAuthorization = loginResult!.data!.session!.token!
        UserDefaultUtil.shared.adminRefreshToken = loginResult!.data!.session!.refreshToken!
        UserDefaultUtil.shared.adminUserID = loginResult!.data!.userId!
        var now = Date()
        let expireIn = loginResult!.data!.session!.expireIn!
        now.addTimeInterval(expireIn)
        UserDefaultUtil.shared.adminExpireIn = now.timeIntervalSince1970
    }
}
