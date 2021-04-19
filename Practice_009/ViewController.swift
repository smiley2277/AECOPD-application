//
//  ViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/2/25.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var lifestyleButton: UIButton!
    @IBOutlet weak var offlineButton: UIButton!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var quesButton: UIButton!
    @IBOutlet weak var smartButton: UIButton!
    var questionAry: [String: [Int]]  = [:]
    var stepSize: Double = 0.0
    var beforeBorg: [String: Int] = [:]
    var AfterBorg: [String: Int] = [:]
    var scTime: [Int]?
    var scvTime: [Int]?
    var userDefaults: UserDefaults!
    let dateFormatter = DateFormatter()
    let id:String = "k87j6e7c"
    let cookie:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM; connect.sid=s%3AqMQr9uUfeHIHUyqDbiE4OetAxJiNzQYx.3A8bRMYiheV8JU%2BxhWVIJH3KyysgQM%2FntsC4qvIieXc"
    override func viewDidLoad() {
        userDefaults = UserDefaults.standard
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        let storyboard = UIStoryboard(name: "PatientDetailTabList", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PatientDetailTabListViewController") as! PatientDetailTabListViewController
//        //TODO
//        vc.setUserId(userId: "test_id3")
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func offlinePredictClick(_ sender: Any) {
        offlineCheck()
    }
    @IBAction func smartCoachButton(_ sender: Any) {
        //send to smartSubViewController.swift
        let nName = Notification.Name("sendStepsizetoSSVC")
        Foundation.NotificationCenter.default.post(name: nName, object: nil, userInfo: ["PASS":stepSize])
    }
    //time to timestamp
    func fetchTime(timestamp: [Date])-> [Int]{
        let startInterval: TimeInterval = timestamp[0].timeIntervalSince1970
        let stopInterval: TimeInterval = timestamp[1].timeIntervalSince1970
        let timeStamp = Int(startInterval)
        let timeStamp2 = Int(stopInterval)
        return [timeStamp, timeStamp2]
    }
    //timestamp to time
    func fetchdatetime(timeStamp: [Int])-> [String]{
        var date:[String] = []
        for i in Range(0...timeStamp.count-1){
            let timeInterval:TimeInterval = TimeInterval(timeStamp[i])
            let datetime = NSDate(timeIntervalSince1970: timeInterval)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let time = dateFormatter.string(from: datetime as Date)
            date.append(time)
        }
        return date
    }
    func realtimeHR(id: String, timestamp: [Int])-> [Int]{
        let startTimestamp = timestamp[0]
        let stopTimestamp = timestamp[1]
        var heartRateAry: [Int] = []
        let url:String = "https://ntu-med-god.ml/api/getHeartRateBySpecific?id="+id+"&start="+String(startTimestamp)+"&end="+String(stopTimestamp)
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string:url)!,timeoutInterval: Double.infinity)
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            let heartRateSet = String(data: data, encoding: .utf8)!
            heartRateAry = processingAPIdata(data: heartRateSet)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return heartRateAry
    }
    func realtimeStep(id: String, timestamp: [Int])-> Int{
        let startTimestamp = timestamp[0]
        let stopTimestamp = timestamp[1]
        var stepAry: Int = 0
        let url:String = "https://ntu-med-god.ml/api/getStepsBySpecific?id="+id+"&start="+String(startTimestamp)+"&end="+String(stopTimestamp)
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string:url)!,timeoutInterval: Double.infinity)
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            let stepSet = String(data: data, encoding: .utf8)!
            stepAry = processingAPIdataWithStep(data: stepSet)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return stepAry
    }
    
    func processingAPIdataWithStep(data: String)-> Int{
        var proText: String = ""
        var sum: Int = 0
        proText = data.replacingOccurrences(of: "[", with: "")
        proText = proText.replacingOccurrences(of: "]", with: "")
        proText = proText.replacingOccurrences(of: "{", with: "")
        proText = proText.replacingOccurrences(of: "}", with: "")
        let lifeAry = proText.components(separatedBy: ",")
        for i in Range(0...lifeAry.count-1){
            if (lifeAry[i].range(of:"sum") != nil){
                let text = lifeAry[i].split(separator: ":")
                sum = Int(text[1]) ?? 0
            }
        }
        return sum
    }
    func processingAPIdata(data: String)-> [Int]{
        var proText: String = ""
        var numAry: [Int] = []
        proText = data.replacingOccurrences(of: "[", with: "")
        proText = proText.replacingOccurrences(of: "]", with: "")
        proText = proText.replacingOccurrences(of: "{", with: "")
        proText = proText.replacingOccurrences(of: "}", with: "")
        let lifeAry = proText.components(separatedBy: ",")
        for i in Range(0...lifeAry.count-1){
            if (lifeAry[i].range(of:"value") != nil){
                let text = lifeAry[i].split(separator: ":")
                numAry.append(Int(text[1])!)
            }
        }
        return numAry
    }
    override func viewWillAppear(_ animated: Bool) {
        let notificationName = Notification.Name("sendQuesArray")
        NotificationCenter.default.addObserver(self, selector: #selector(catchQuesData(noti:)), name: notificationName, object: nil)
        if (questionAry.count != 0){
            offlineButton.isUserInteractionEnabled = true
        }
        //catch from lifestyleViewController.swift
        let notiName = Notification.Name("sendStepsizetoWT")
        NotificationCenter.default.addObserver(self, selector: #selector(catchStepSize(noti:)), name: notiName, object: nil)
        //catch from borgScaleViewController.swift
        let notifiName = Notification.Name("sendbefBorg")
        NotificationCenter.default.addObserver(self, selector: #selector(catchBefBorg(noti:)), name: notifiName, object: nil)
        //catch from borgScalePostViewController.swift
        let notifName = Notification.Name("sendaftBorg")
        NotificationCenter.default.addObserver(self, selector: #selector(catchAftBorg(noti:)), name: notifName, object: nil)
        //catch frome walkingTestViewController
        let notiNamefortime = Notification.Name("sendTimestamp")
        NotificationCenter.default.addObserver(self, selector: #selector(catchTime(noti:)), name: notiNamefortime, object: nil)
        //catch frome variableSpeedViewController
        let notiNamefortimebyvaria = Notification.Name("sendTimestampByVariable")
        NotificationCenter.default.addObserver(self, selector: #selector(catchTimeVaria(noti:)), name: notiNamefortimebyvaria, object: nil)
        userDefaults.synchronize()
        autoFetchHRStep()
        questionnairePackage()
        refetch()
    }
    func questionnairePackage()-> [String: [Int]]{
        let pacQues:[String: [Int]] = fetchingDefaultForQues(keyName: "Questionnaire")
        return pacQues
    }
    func autoFetchHRStep(){
        var duration: [Int] = []
        var vduration: [Int] = []
        var heartRateForFixed: [Int] = []
        var heartRateForVaria: [Int] = []
        var stepForFixed: Int = 0
        var stepForVaria: Int = 0
        var befBorg: [String: Int] = [:]
        var aftBorg: [String: Int] = [:]
        befBorg = fetchingDefaultForBorg(keyName: "beforeBorg")
        aftBorg = fetchingDefaultForBorg(keyName: "afterBorg")
        duration = fetchingDefatultForArray(keyName: "smartCoachDuration")
        vduration = fetchingDefatultForArray(keyName: "smartCoachVariableDuration")
        if (duration.count != 0){
            heartRateForFixed = realtimeHR(id: id, timestamp: duration)
            stepForFixed = realtimeStep(id: id, timestamp: duration)
            let durationDate = fetchdatetime(timeStamp: duration)
            if (heartRateForFixed.count != 0) && (stepForFixed != 0){
                let pacBorg = [durationDate,befBorg,aftBorg, heartRateForFixed, stepForFixed] as [Any]
                //to backend
//                print("@VC FFFpacBorg,", pacBorg)
            }else{
                let saveFixBorg = [durationDate, befBorg, aftBorg] as [Any]
                let ty = Array(befBorg.keys)
                userDefaults.set(saveFixBorg, forKey: "pacFixBorg"+ty[0])
//                print("@VC saveBorg,", saveFixBorg)
            }
        }
        if (vduration.count != 0){
            heartRateForVaria = realtimeHR(id: id, timestamp: vduration)
            stepForVaria = realtimeStep(id: id, timestamp: vduration)
            let vdurationDate = fetchdatetime(timeStamp: vduration)
            if (heartRateForVaria.count != 0) && (stepForVaria != 0){
                let pacBorg = [vdurationDate,befBorg,aftBorg, heartRateForFixed, stepForFixed] as [Any]
                //to backend
//                print("@VC VVVpacBorg,",pacBorg)
            }else{
                let saveVarBorg = [vdurationDate,befBorg,aftBorg, heartRateForFixed, stepForFixed] as [Any]
                let ty = Array(befBorg.keys)
                userDefaults.set(saveVarBorg, forKey: "pacVarBorg"+ty[0])
//                print("@VC saveVarBorg,", saveVarBorg)
            }
        }
    }
    func refetch(){
        var notUploadBorgKey: String = ""
        var datetimeAry:[Date] = []
        var timestampAry:[Int] = []
        let keyAry = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        for i in Range(0...keyAry.count-1){
            let k = keyAry[i].range(of:"pacFixBorg", options:.regularExpression)
            if (k != nil){
                notUploadBorgKey = keyAry[i]
            }
        }
        if(UserDefaults.standard.object(forKey:notUploadBorgKey) != nil) {
            let t = UserDefaults.standard.value(forKey: notUploadBorgKey) as! [Any]
            let duration = t[0] as! [String]
            let befBorg = t[1] as! [String: Int]
            let aftBorg = t[2] as! [String: Int]
            for i in Range(0...duration.count-1){
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: duration[i])!
                datetimeAry.append(date)
            }
            timestampAry = fetchTime(timestamp: datetimeAry)
            let heartRate = realtimeHR(id: id, timestamp: timestampAry)
            let step = realtimeStep(id: id, timestamp: timestampAry)
            if (heartRate.count != 0) && (step != 0){
                let pacBorg = [duration,befBorg,aftBorg, heartRate, step] as [Any]
//                to backend
            }
            
        }
    }
    
    func fetchingDefatultForArray(keyName: String)-> [Int]{
        var defaulty: [Int] = []
        if (keyName == "smartCoachDuration") || (keyName == "smartCoachVariableDuration") || (keyName == "Questionnaire"){
            defaulty = UserDefaults.standard.array(forKey: keyName)as? [Int] ?? [Int]()
        }
        return defaulty
    }
    func fetchingDefaultForBorg(keyName: String)-> [String: Int]{
        var defaults: [String: Int] = [:]
        if(keyName == "beforeBorg") || (keyName == "afterBorg"){
            defaults = UserDefaults.standard.value(forKey: keyName) as? [String: Int] ?? [:]
        }
        return defaults
    }
    func fetchingDefaultForQues(keyName: String)-> [String: [Int]]{
        var defaults: [String: [Int]] = [:]
        if(keyName == "Questionnaire"){
            defaults = UserDefaults.standard.value(forKey: keyName) as? [String: [Int]] ?? [:]
        }
        return defaults
    }
    @objc func catchTime(noti: Notification){
        scTime = fetchTime(timestamp: (noti.userInfo!["PASS"] as? [Date])!)
        userDefaults.set(scTime, forKey: "smartCoachDuration")
//        print("CatchTime ByNoti @VC, ", scTime)
    }
    @objc func catchTimeVaria(noti: Notification){
        scvTime = fetchTime(timestamp: (noti.userInfo!["PASS"] as? [Date])!)
        userDefaults.set(scvTime, forKey: "smartCoachVariableDuration")
//        print("CatchTimeVariable ByNoti @VC, ", scvTime)
    }
    @objc func catchBefBorg(noti: Notification){
        beforeBorg = noti.userInfo!["PASS"] as! [String: Int]
        userDefaults.set(beforeBorg, forKey: "beforeBorg")
//        print("CatchBB ByNoti @VC, ", beforeBorg)
    }
    @objc func catchAftBorg(noti: Notification){
        AfterBorg = noti.userInfo!["PASS"] as! [String: Int]
        userDefaults.set(AfterBorg, forKey: "afterBorg")
//        print("CatchAB ByNoti @VC, ", AfterBorg)
    }
    @objc func catchStepSize(noti:Notification) {
        stepSize = noti.userInfo!["PASS"] as! Double
    }
    @objc func catchQuesData(noti:Notification) { // 時間不用轉換
        questionAry = noti.userInfo!["PASS"] as! [String: [Int]]
        userDefaults.set(questionAry, forKey: "Questionnaire")
    }
    func offlineCheck(){
        if(questionAry.count==0){
            let scAlert = UIAlertController(title: "提醒", message: "請先填寫問卷，才可以開啟離線預測功能唷", preferredStyle: .alert)
            scAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(scAlert, animated: true)
            offlineButton.isUserInteractionEnabled = false
        }else{
            offlineButton.isUserInteractionEnabled = true
        }
    }
    @IBAction func offlinePredict(_ sender: UIButton) {
        performSegue(withIdentifier: "offlinePredictSeg", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? offlinePredictViewController
//        controller?.questionAry = questionAry
        let vc = segue.destination as? smartSubViewController
        vc?.stepSize = stepSize
    }
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
//        _ = segue.source as? borgScalePostTestViewController
    }

}
