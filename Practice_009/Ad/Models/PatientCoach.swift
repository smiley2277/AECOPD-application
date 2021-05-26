import ObjectMapper

class PatientCoach: BaseModel {
    var status: String?
    var data: OuterData?
    
    class OuterData: BaseModel {
        var data: [Data] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map["data"]
        }
        
        class Data: BaseModel {
            var speed: Double?
            var time: Double?
            var timestamp: String?
            var borgUUID: String?
            //MARK: for UI
            var date: Date?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                speed <- map["speed"]
                time <- map["time"]
                timestamp <- map["timestamp"]
                //TODO 確定API傳什麼格式來，做時間格式轉換，對順序做整理
                date = DateFormat.shared.dateFormatWith(format: "E, d MMM yyyy HH:mm:ss Z", string: timestamp)
                if let date = date {
                    timestamp = DateFormat.shared.dateFormatWith(format: "yyyy年MM月dd日 HH:mm", date: date)
                }
                
                borgUUID <- map["borg_uuid"]
            }
        }

    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
    
}
