import UIKit

//MARK: 用NSHomeDirectory()找在電腦上儲存的位置
enum UserDefaultKey: String {
    case adminAuthorization = "ADMIN_AUTHORIZATION"
    case adminRefreshToken = "ADMIN_REFRESH_TOKEN"
    case adminUserID = "ADMIN_USER_ID"
    case adminExpireIn = "EXPIRE_IN"
    case adminRoles = "ROLES"
    case borgUuid = "BORG_UUID"
    
}

class UserDefaultUtil: NSObject {
    static var shared = UserDefaultUtil()
    
    var adminAuthorization: String? {
        get{
            return getObject(classType: String(), key: .adminAuthorization)
        }
        set(authorization){
            update(object: authorization, key: .adminAuthorization)
        }
    }
    
    var adminRefreshToken: String? {
        get{
            return getObject(classType: String(), key: .adminRefreshToken)
        }
        set(refreshToken){
            update(object: refreshToken, key: .adminRefreshToken)
        }
    }
    
    var adminUserID: String? {
        get{
            return getObject(classType: String(), key: .adminUserID)
        }
        set(userID){
            update(object: userID, key: .adminUserID)
        }
    }

    //MARK: timeIntervalSince1970
    var adminExpireIn: Double? {
        get{
            return getObject(classType: Double(), key: .adminExpireIn)
        }
        set(expiredIn){
            update(object: expiredIn, key: .adminExpireIn)
        }
    }
    
    var adminRoles: String? {
        get{
            return getObject(classType: String(), key: .adminRoles)
        }
        set(adminRoles){
            update(object: adminRoles, key: .adminRoles)
        }
    }
    
    var borgUuid: String? {
        get{
            return getObject(classType: String(), key: .borgUuid)
        }
        set(borgUuid){
            update(object: borgUuid, key: .borgUuid)
        }
    }

    private func update(object: Any?, key: UserDefaultKey) {
        let userDefaults = UserDefaults.standard
        if let object = object {
            userDefaults.set(object, forKey: key.rawValue)
        } else {
            userDefaults.removeObject(forKey: key.rawValue)
        }
        userDefaults.synchronize()
    }
    
    private func getObject<T>(classType: T, key: UserDefaultKey) -> T? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key.rawValue) as? T
    }
}
