import ObjectMapper

class PostPatientCoachResponse: BaseModel {
    var status: String?
  
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
    }
}
