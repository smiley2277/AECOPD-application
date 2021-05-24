//
//  ViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/2/25.
//

import UIKit

class ViewController: BaseViewController{
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
//    let id:String = "k87j6e7c"
    let userId = UserDefaultUtil.shared.adminUserID
    let cookie:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM"
    private var presenter: userMainPresenterProtocol?
    override func viewDidLoad() {
        userDefaults = UserDefaults.standard
        let dics = userDefaults.dictionaryRepresentation()
//        for key in dics {
//            userDefaults.removeObject(forKey: key.key)
//        }
//        userDefaults.synchronize()
        presenter = userMainPresenter(delegate: self)
//        print(UserDefaults.standard.dictionaryRepresentation())
        
    }
    @IBAction func sync(_ sender: Any) {
        autoFetchHRStep()
        refetch()
    }
    @IBAction func offlinePredictClick(_ sender: Any) {
        offlineCheck()
    }
    @IBAction func smartCoachButton(_ sender: Any) {
        //send to smartSubViewController.swift
        let nName = Notification.Name("sendStepsizetoSSVC")
        Foundation.NotificationCenter.default.post(name: nName, object: nil, userInfo: ["PASS":stepSize])
    }
    func dateDifference(dateA:Date, dateB:Date) -> Double {
        let interval = dateB.timeIntervalSince(dateA)
        return interval //unit: sec
    }
    //string to timestamp
    func fetchTimefromString(timestamp: [String])-> [Int]{
        // 轉成UTC-> 轉成Unix timestamp
        var timeint: [Int] = []
        for i in (0...timestamp.count-1){
            //TO UTC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.timeZone = TimeZone(identifier: "uUTC")
            let dateDate = dateFormatter.date(from: timestamp[i])
            //UTC datetime to timestamp
            let startInterval: TimeInterval = dateDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            let timeStamp = Int(startInterval)
            timeint.append(timeStamp)
        }
        return timeint
    }
    //time to timestamp
    func fetchTime(timestamp: [Date])-> [Int]{
        // 轉成UTC-> 轉成Unix timestamp
        var timeint: [Int] = []
        for i in (0...timestamp.count-1){
            //TO UTC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            let dateString = dateFormatter.string(from: timestamp[i] as Date)
            //to Date
            let dateDate = dateFormatter.date(from: dateString)
            //UTC datetime to timestamp
            let startInterval: TimeInterval = dateDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            let timeStamp = Int(startInterval)
            timeint.append(timeStamp)
        }
        return timeint
    }
    //timestamp to time
    func fetchdatetime(timeStamp: [Int])-> [String]{
        var date:[String] = []
        for i in Range(0...timeStamp.count-1){
            let timeInterval:TimeInterval = TimeInterval(timeStamp[i])
            let datetime = Date(timeIntervalSince1970: timeInterval)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let time = dateFormatter.string(from: datetime)
            date.append(time)
        }
        return date
    }
    //time format from string
    func fetchdatetimeformat(timeStamp: [Date])-> [String]{
        var date:[String] = []
        for i in Range(0...timeStamp.count-1){
            dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
            let time = dateFormatter.string(from: timeStamp[i])
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
        print(numAry)
        if (numAry.count > 2){
            for i in Range(0...numAry.count-1){
                if (0 < i) && (i < numAry.count-1){
                    print(numAry[i], i)
                    numAry.remove(at: i)
                }
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
//        autoFetchHRStep()
    }
    func autoFetchHRStep(){
        var duration: [Int] = []
        var heartRateForFixed: [Int] = []
        var heartRateForVaria: [Int] = []
        var stepForFixed: Int = 0
        var stepForVaria: Int = 0
        var befBorg: [String: Int] = [:]
        var aftBorg: [String: Int] = [:]
        var realDate: [String] = []
        befBorg = fetchingDefaultForBorg(keyName: "beforeBorg")
        aftBorg = fetchingDefaultForBorg(keyName: "afterBorg")
        if (befBorg != [:]) || (aftBorg != [:]) {
            print(befBorg, befBorg)
            let befDatetime = Array(befBorg.keys)
            let aftDatetime = Array(aftBorg.keys)
            let postborg = Array(aftBorg.values)[0]
            let preborg = Array(befBorg.values)[0]
            realDate.append(befDatetime[0])
            realDate.append(aftDatetime[0])
            print("autoFetchHRStep befDatetime & aftDatetime:",befDatetime, aftDatetime)
            duration = fetchTimefromString(timestamp: realDate) // to timestamp
            realDate = fetchdatetime(timeStamp: duration) // to long format string
            let fixInt = fetchingDefatultForArray(keyName: "smartCoachDuration")
            let varInt = fetchingDefatultForArray(keyName: "smartCoachVariableDuration")//timestamp
            if (fixInt.count != 0){
                heartRateForFixed = realtimeHR(id: userId ?? "", timestamp: duration)
                stepForFixed = realtimeStep(id: userId ?? "", timestamp: duration)
                if (heartRateForFixed.count != 2) && (stepForFixed != 0){
                    let pacBorg = [postborg, preborg, heartRateForFixed[1], heartRateForFixed[0], stepForFixed, realDate[0]] as [Any]
                    presenter?.postBorg(userId: userId!, postbeat: heartRateForFixed[1], postborg: postborg, prebeat: heartRateForFixed[0], preborg: preborg, step: stepForFixed, timestamp: realDate[0])
                    print("@VC FFFpacBorg,", pacBorg)
                }else{
                    let nonSyncAlert = UIAlertController(title: "提醒", message: "請先同步您的手錶，以便取得最新資訊", preferredStyle: .alert)
                    nonSyncAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                    self.present(nonSyncAlert, animated: true)
                    let saveFixBorg = [realDate[0], realDate[1], postborg, preborg] as [Any]
                    userDefaults.set(saveFixBorg, forKey: "pacFixBorg"+realDate[0])
                }
            }
            if (varInt.count != 0){
                heartRateForVaria = realtimeHR(id: userId ?? "", timestamp: duration)
                stepForVaria = realtimeStep(id: userId ?? "", timestamp: duration)
                if (heartRateForVaria.count != 2) && (stepForVaria != 0){
                    let pacBorg = [realDate[0], postborg, preborg, heartRateForVaria, stepForVaria] as [Any]
                    presenter?.postBorg(userId: userId!,postbeat: heartRateForVaria[1], postborg: postborg, prebeat: heartRateForVaria[0], preborg: preborg, step: stepForVaria, timestamp: realDate[0])
                }else{
                    let nonSyncAlert = UIAlertController(title: "提醒", message: "請先同步您的手錶，以便取得最新資訊", preferredStyle: .alert)
                    nonSyncAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                    self.present(nonSyncAlert, animated: true)
                    let saveVarBorg = [realDate[0], realDate[1], postborg, preborg] as [Any]
                    userDefaults.set(saveVarBorg, forKey: "pacVarBorg"+realDate[0])
                }
            }
        }
    }
    func refetch(){
        var notUploadBorgKey: [String] = []
        var datetimeAry:[Date] = []
        var timestampAry:[Int] = []
        let keyAry = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        for i in Range(0...keyAry.count-1){
            let k = keyAry[i].range(of:"pacFixBorg", options:.regularExpression)
            if (k != nil){
                notUploadBorgKey.append(keyAry[i])
            }
        }
        if (notUploadBorgKey.count > 0){
            for idx in (0...notUploadBorgKey.count-1){
                if(UserDefaults.standard.object(forKey:notUploadBorgKey[idx]) != nil) {
                    print("============================= :", notUploadBorgKey[idx])
                    print(UserDefaults.standard.object(forKey:notUploadBorgKey[idx]))
                    let t = UserDefaults.standard.value(forKey: notUploadBorgKey[idx]) as! [Any]
                    var duration: [String] = []
                    let befBorg = Int(t[2] as! NSNumber)
                    let aftBorg = Int(t[3] as! NSNumber)
                    duration.append(t[0] as! String)
                    duration.append(t[1] as! String)
                    for i in Range(0...duration.count-1){
                        let date = dateFormatter.date(from: duration[i]) ?? Date()
                        datetimeAry.append(date)
                    }
                    timestampAry = fetchTime(timestamp: datetimeAry) //unix timestamp
                    if (timestampAry[0] > timestampAry[1]){
                        duration = duration.reversed()
                        timestampAry = timestampAry.reversed()
                    }
                    let heartRate = realtimeHR(id: userId ?? "", timestamp: timestampAry)
                    let step = realtimeStep(id: userId ?? "", timestamp: timestampAry)
                    print("==> HR & step:",duration, timestampAry, heartRate, step)
                    if (heartRate.count > 1) { //&& (step != 0)
                        let pacBorg = [datetimeAry[0] ,duration, befBorg, aftBorg, heartRate, step] as [Any]
                        print(pacBorg)
                        let datetimeLongAry = fetchdatetime(timeStamp: timestampAry)
                        presenter?.postBorg(userId: userId!, postbeat: heartRate[1], postborg: aftBorg, prebeat: heartRate[0], preborg: befBorg, step: step, timestamp: datetimeLongAry[0])
                        userDefaults.removeObject(forKey: notUploadBorgKey[idx])
                    }
                    datetimeAry = []
                }
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
        let dateFromBorg = noti.userInfo!["PASS"] as! [Date]
        let interval = dateDifference(dateA:dateFromBorg[0], dateB:dateFromBorg[1])
        if  (interval < 120){
            let timeAlert = UIAlertController(title: "提醒", message: "請至少走超過10分鐘：）", preferredStyle: .alert)
            timeAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(timeAlert, animated: true)
        }else{
            scTime = fetchTime(timestamp: (dateFromBorg))
            userDefaults.set(scTime, forKey: "smartCoachDuration")
            print("CatchTime ByNoti @VC, ", scTime)
            
        }
    }
    @objc func catchTimeVaria(noti: Notification){
        let dateFromBorg = noti.userInfo!["PASS"] as! [Date]
        let interval = dateDifference(dateA:dateFromBorg[0], dateB:dateFromBorg[1])
        if (interval < 120){
            let timeAlert = UIAlertController(title: "提醒", message: "請至少走超過10分鐘：）", preferredStyle: .alert)
            timeAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(timeAlert, animated: true)
        }else{
            scvTime = fetchTime(timestamp: dateFromBorg)
            userDefaults.set(scvTime, forKey: "smartCoachVariableDuration")
            print("CatchTimeVariable ByNoti @VC, ", scvTime)
        }
    }
    @objc func catchBefBorg(noti: Notification){
        beforeBorg = noti.userInfo!["PASS"] as! [String: Int]
        userDefaults.set(beforeBorg, forKey: "beforeBorg")
        print("CatchBB ByNoti @VC, ", beforeBorg)
    }
    @objc func catchAftBorg(noti: Notification){
        AfterBorg = noti.userInfo!["PASS"] as! [String: Int]
        userDefaults.set(AfterBorg, forKey: "afterBorg")
        print("CatchAB ByNoti @VC, ", AfterBorg)
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
        let vc = segue.destination as? smartSubViewController
        vc?.stepSize = stepSize
    }
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
//        _ = segue.source as? borgScalePostTestViewController
    }
}

extension ViewController: userMainViewProtocol {
    func onBindMainResult(mainResult: PostBorg) {
        UserDefaultUtil.shared.borgUuid = mainResult.data!.borg_uuid!
    }
}
