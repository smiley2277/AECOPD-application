//
//  PostQues.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/29.
//

import Foundation
import ObjectMapper

class PostQues: BaseModel {
    var status: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        status <- map["status"]
    }
    
}
