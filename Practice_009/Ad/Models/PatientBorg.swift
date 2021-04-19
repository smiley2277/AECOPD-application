import ObjectMapper

class PatientBorg: BaseModel {
    var status: String?
    var data: OuterData?
    
    class OuterData: BaseModel {
        var data: [Data] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map["data"]
        }

        class Data: BaseModel {
            var borgUUID: String?
            var preborg: Int?
            var postborg: Int?
            var prebeat: Int?
            var postbeat: Int?
            var timestamp: String?
            var date: Date?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                borgUUID <- map["borg_uuid"]
                preborg <- map["preborg"]
                postborg <- map["postborg"]
                prebeat <- map["prebeat"]
                postbeat <- map["postbeat"]
                timestamp <- map["timestamp"]
                //TODO 確定API傳什麼格式來，做時間格式轉換，對順序做整理
                date = DateFormat.shared.dateFormatWith(format: "E, d MMM yyyy HH:mm:ss Z", string: timestamp)
                //"Tue, 25 May 2010 12:53:58 +0000"
                if let date = date {
                    timestamp = DateFormat.shared.dateFormatWith(format: "yyyy年MM月dd日 HH:mm", date: date)
                }
            }
        }
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
}
