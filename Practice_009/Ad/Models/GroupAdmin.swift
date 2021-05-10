//
//  PatientList.swift
//  Practice_009
//
//  Created by pekkapekka on 2021/5/10.
//

import ObjectMapper

class GroupAdmin: BaseModel {
    var status: String?
    var data: OuterData?
    
    class OuterData: BaseModel {
        var groupName: String?
        var member: [Member] = []
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            groupName <- map["groupName"]
            member <- map["member"]
        }
        
        class Member: BaseModel {
            var uuid: String?
            var identity: String?
            var phone: String?
            var age: Int?
            var roles: AdminOrUser?
            var weight: Int?
            var birthday: String?
            var firstName: String?
            var height: Int?
            var lastName: String?
            var email: String?
            var gender: String?
            var userID: String?

            override func mapping(map: Map) {
                super.mapping(map: map)
                
                uuid <- map["uuid"]
                identity <- map["identity"]
                phone <- map["phone"]
                age <- map["age"]
                roles <- map["roles"]
                weight <- map["weight"]
                birthday <- map["birthday"]
                firstName <- map["first_name"]
                height <- map["height"]
                lastName <- map["last_name"]
                email <- map["email"]
                gender <- map["gender"]
                userID <- map["user_id"]
                
                var rolesString = ""
                rolesString <- map["roles"]
                roles = AdminOrUser.init(rawValue: rolesString)!
            }
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        data <- map["data"]
    }
}
