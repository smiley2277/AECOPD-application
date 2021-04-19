import ObjectMapper

class BaseModel: NSObject, Mappable {
    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
    }
}
