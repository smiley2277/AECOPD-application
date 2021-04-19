import ObjectMapper

class PatientBorgAndCoach: NSObject {
    var speed: Int?
    var time: Int?
    var preborg: Int?
    var postborg: Int?
    var prebeat: Int?
    var postbeat: Int?
    var timestamp: String?
    var date: Date?
    var isBorg: Bool = false
    
    init(patientBorgData: PatientBorg.OuterData.Data) {
        preborg = patientBorgData.preborg
        postborg = patientBorgData.postborg
        prebeat = patientBorgData.prebeat
        postbeat = patientBorgData.postbeat
        timestamp = patientBorgData.timestamp
        date = patientBorgData.date
        isBorg = true
    }
    
    init(patientCoachData: PatientCoach.OuterData.Data) {
        time = patientCoachData.time
        speed = patientCoachData.speed
        timestamp = patientCoachData.timestamp
        date = patientCoachData.date
        isBorg = false
    }
}

