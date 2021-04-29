//
//  PostBorg.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/29.
//

import Foundation
import ObjectMapper

class PostBorg: BaseModel {
    var status: String?
    var data: Data?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
    class Data: BaseModel {
        var borg_uuid: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            borg_uuid <- map["borg_uuid"]
        }
    }
}
