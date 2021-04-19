import ObjectMapper

class LoginResult: BaseModel {
    var data: Data?
    var status: String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
        status <- map["status"]
    }
    
    class Data: BaseModel {
        var session: Session?
        //MARK: 對醫生，不需要帶到網址上，帶欲查詢的用戶的userID，所以暫時不用記到UserDefault
        var userId: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            session <- map["session"]
            userId <- map["user_id"]
        }
        
        class Session: BaseModel {
            //MARK: 單位是秒，代表效期，可能是一天
            var expireIn: Double?
            var refreshToken: String?
            var token: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                expireIn <- map["expire_in"]
                refreshToken <- map["refresh_token"]
                token <- map["token"]
            }
        }
    }
}
