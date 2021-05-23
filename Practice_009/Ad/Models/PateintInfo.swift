//
//  PateintInfo.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/5/23.
//

import ObjectMapper

class PatientInfo: BaseModel {
    var status: String?
    var data: OuterData?
    
    class OuterData: BaseModel {
        var data: [Data] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map["data"]
        }

        class Data: BaseModel {
            var user_id: String?
            override func mapping(map: Map) {
                super.mapping(map: map)
                user_id <- map["user_id"]
                print("user_id in PatientInfo,\(user_id)")
            }
        }
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
}
