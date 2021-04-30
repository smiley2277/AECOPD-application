import ObjectMapper

class PatientSurvey: BaseModel {
    var status: String?
    var data: OuterData?
    
    class OuterData: BaseModel {
        var data: [Data] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map["data"]
        }
        
        class Data: BaseModel {
            var cat1: Int?
            var cat2: Int?
            var cat3: Int?
            var cat4: Int?
            var cat5: Int?
            var cat6: Int?
            var cat7: Int?
            var cat8: Int?
            var catsum: Int?
            var eq1: Int?
            var eq2: Int?
            var eq3: Int?
            var eq5: Int?
            var eq4: Int?
            var mmrc: Int?
            var timestamp: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                cat1 <- map["cat1"]
                cat2 <- map["cat2"]
                cat3 <- map["cat3"]
                cat4 <- map["cat4"]
                cat5 <- map["cat5"]
                cat6 <- map["cat6"]
                cat7 <- map["cat7"]
                cat8 <- map["cat8"]
                catsum <- map["catsum"]
                eq1 <- map["eq1"]
                eq2 <- map["eq2"]
                eq3 <- map["eq3"]
                eq4 <- map["eq4"]
                eq5 <- map["eq5"]
                mmrc <- map["mmrc"]
                timestamp <- map["timestamp"]
                
                //TODO 確定API傳什麼格式來，做時間格式轉換，對順序做整理
                let date = DateFormat.shared.dateFormatWith(format: "E, d MMM yyyy HH:mm:ss Z", string: timestamp)
                if let date = date {
                    timestamp = DateFormat.shared.dateFormatWith(format: "yyyy年MM月dd日 HH:mm", date: date)
                }
            }
            
            var isNil: Bool {
                return cat8 == nil &&
                cat4 == nil &&
                eq5 == nil &&
                cat7 == nil &&
                cat3 == nil &&
                eq3 == nil &&
                cat6 == nil &&
                cat2 == nil &&
                catsum == nil &&
                eq1 == nil &&
                eq4 == nil &&
                cat5 == nil &&
                cat1 == nil &&
                mmrc == nil &&
                eq2 == nil
            }
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
}
