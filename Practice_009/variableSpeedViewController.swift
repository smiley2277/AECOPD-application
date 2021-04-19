//
//  variableSpeedViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/29.
//

import UIKit
import AVFoundation
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class variableSpeedViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var flashSignal: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var restOfTime: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    var durationFill: Int = 0
    var speedFill: Float = 0.0
    var trainingSpeed:Float = 385 //外部：m/sec｜內部：BPM 每分鐘幾下
    var trainingDuration:Int = 1200 //外部：min｜內部：sec
    var varSpeed: [Float] = [1.5,2,3] //第一個跑的在最後面
    var varDuration: [Int] = [1,1,1] //第一個跑的在最後面
    var stepSize: Double = 0
    var stepSizeLife: Double = 0
    var audioPlayer = AVAudioPlayer()
    weak var timer:Timer!
    weak var flashTimer:Timer!
    var timers:[Timer]?
    //package to backend
    var heartRateSet: String = ""
    var heartRateAry:[Int] = []
    var stepSet: String = ""
    var stepAry:Int = 0
    //animation setting
    let color = UIColor(red: 128/255, green: 100/255, blue: 0, alpha: 1)
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
    var startTime: Date?
    var stopTime: Date?
    let cookie:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM; connect.sid=s%3AqMQr9uUfeHIHUyqDbiE4OetAxJiNzQYx.3A8bRMYiheV8JU%2BxhWVIJH3KyysgQM%2FntsC4qvIieXc"
    weak var delegate: lifestyleViewControllerProtocol?
    let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
    //preprocessing & setting
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
    override func viewDidLoad() {
        playButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        // 導覽列右邊按鈕
        let rightButton = UIBarButtonItem(
            title:"設定",
            style:.plain,
            target:self,
            action:#selector(variableSpeedViewController.setting))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = rightButton
//        fetchStepSize()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchStepSize()
        if (stepSize == 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
            playButton.isUserInteractionEnabled = false
            stopButton.isUserInteractionEnabled = false
            restartButton.isUserInteractionEnabled = false
        }else{
            playButton.isUserInteractionEnabled = true
            stopButton.isUserInteractionEnabled = true
            restartButton.isUserInteractionEnabled = true
        }
    }
    @objc func setting() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "variableSettingViewController") as! variableSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //catch by storyboard
    func setStepSize(size: Double)->Double{
        self.stepSizeLife = size
        return size
    }
    //unit transfer
    func unitTransfer(speed: Float, size: Double)-> Float{
        let transSpeed = speed * 6000 / Float(size)
        return transSpeed
    }
    func aryUnitTransfer(speed: [Float], size: Double)-> [Float]{
        var ary:[Float] = []
        for i in Range(0...speed.count-1){
            let arc = speed[i] * 6000 / Float(size)
            ary.append(arc)
        }
        return ary
    }
    func fetchStepSize(){ // from setting
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "variableSettingViewController") as! variableSettingViewController
        let info_SS = vc.settingDefault(keyName: "stepSize")
        if (stepSizeLife == 0){
            stepSize = (info_SS as! NSString).doubleValue
            stepSize = trunc(stepSize * 10) / 10
            print("@VSVC, info, ", stepSize)
        }else{
            stepSize = stepSizeLife
        }
    }
    
    //button function
    @IBAction func finish(_ sender: Any) {
        realtimeHR(id: "k87j6e7c")
        realtimeStep(id: "k87j6e7c")
        if ((timer?.isValid) != nil){
            stopCountDown()
            timer = nil
        }
        if ((flashTimer?.isValid) != nil){
            pauseFlashing()
            flashTimer = nil
        }
        let notificationName = Notification.Name("sendTimestampByVariable")
        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":[startTime, stopTime]])
    }
    @IBAction func start(_ sender: Any) {
        print("@VSVC, stepSize", stepSize)
        if (stepSize == 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }else{
            var countDownNum = 0
            var durationAry: [Int] = []
            for i in Range(0...varDuration.count-1){
                countDownNum += varDuration[i] * 60
                durationAry.append(countDownNum)
            }
            var speedAry = aryUnitTransfer(speed: varSpeed, size: stepSize)
            startTime = Date()
            print("@VSVC, startTime,", startTime)
            flashingTimer(duration: durationAry, speed: speedAry, sec: countDownNum)
        }
    }
    @IBAction func stop(_ sender: Any) {
        if (stepSize == 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }else{
            stopCountDown()
            stopTime = Date()
            print("@VSVC, stopTime,", stopTime)
            pauseFlashing()
            let finishAlert = UIAlertController(title: "暫停", message: "測驗已終止，請重新開始", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }
    }
    @IBAction func restart(_ sender: Any) {
        if (stepSize == 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }
        else{
            stopCountDown()
            pauseFlashing()
            var countDownNum = 0
            var durationAry: [Int] = []
            for i in Range(0...varDuration.count-1){
                countDownNum += varDuration[i] * 60
                durationAry.append(countDownNum)
            }
            var speedAry = aryUnitTransfer(speed: varSpeed, size: stepSize)
            startTime = Date()
            print("@VSVC, startTime,", startTime)
            flashingTimer(duration: durationAry, speed: speedAry, sec: countDownNum)
        }
    }
    
    
    //animation and timers
    func countDown(duration: [Int]){
        //summary timer
        print("@VSVC, countDOWN")
        var countDownNum: Int = 0
        var durationAry: [Int] = []
        for i in Range(0...duration.count-1){
            countDownNum += duration[i] * 60
            durationAry.append(countDownNum)
        }
        var u = durationAry.count
        timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true, block: { [self] (timer) in
            restOfTime.text = String(countDownNum/60)
            let stageSec = durationAry.firstIndex(where: {  $0 == countDownNum })
            if stageSec != nil{
                u = stageSec!
            }
            let text = String(u+1)
            stageLabel.text = "階段 " + text
            print(countDownNum)
            countDownNum -= 1
            if countDownNum == 0 {
                restOfTime.text = String(countDownNum)
                timer.invalidate()
                pauseFlashing()
                let finishAlert = UIAlertController(title: "完成", message: "測驗已完成", preferredStyle: .alert)
                finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                self.present(finishAlert, animated: true)
            }
        })
    }
    func stopCountDown(){
        if ((timer?.isValid) != nil){
            timer!.invalidate()
            timer = nil
        }
        if ((flashTimer?.isValid) != nil){
            flashTimer!.invalidate()
            flashTimer = nil
        }
    }
    func flashing(setColor: UIColor, trainingSpeed: Float){
        flashSignal.alpha = 1.0
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = CFTimeInterval(60/trainingSpeed) //一次動畫做幾秒
        animation.repeatDuration = CFTimeInterval(60/trainingSpeed) //改成總秒數
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        flashSignal.layer.add(animation, forKey: "")
    }
    func pauseFlashing(){
        let pausedTime : CFTimeInterval = flashSignal.layer.convertTime(CACurrentMediaTime(), from: nil)
        flashSignal.layer.timeOffset = pausedTime
    }
    func flashingTimer(duration: [Int], speed: [Float], sec: Int){
        var countDownNum: Int = sec
        var u = duration.count
        var speedAry = speed
        print("@VSVC, timer", speedAry)
        timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true, block: { [self] (timer) in
            restOfTime.text = String(countDownNum/60 + 1)
            let stageSec = duration.firstIndex(where: { $0 == countDownNum })
            if stageSec != nil{
                u = stageSec!
                let temp = speedAry.first!
                speedAry.remove(at: 0)
                print("stageSec,",speedAry)
                flashTimer?.invalidate()
                pauseFlashing()
                flashTimer = Timer.scheduledTimer(withTimeInterval:CFTimeInterval(60/temp), repeats: true, block: { [self] (timer) in
                    playAudio()
                    flashing(setColor: color, trainingSpeed: temp)
                    print("v,",temp)
                })
            }
            let text = String(u+1)
            stageLabel.text = "階段 " + text
            print("COUNTDOWN,",countDownNum)
            countDownNum -= 1
            if countDownNum == 0 {
                restOfTime.text = String(countDownNum)
                timer.invalidate()
                flashTimer?.invalidate()
                pauseFlashing()
                let finishAlert = UIAlertController(title: "完成", message: "測驗已完成", preferredStyle: .alert)
                finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                self.present(finishAlert, animated: true)
            }
        })
    }
    func playAudio(){
        let url = Bundle.main.url(forResource: "knob-458", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    
    //time to timestamp
    func fetchTime()-> [Int]{
        let startInterval: TimeInterval = startTime!.timeIntervalSince1970
        let stopInterval: TimeInterval = stopTime!.timeIntervalSince1970
        let timeStamp = Int(startInterval)
        let timeStamp2 = Int(stopInterval)
//        print(startTime, startInterval, stopTime, timeStamp2)
        return [timeStamp, timeStamp2]
    }
    
    func realtimeHR(id: String){
        let id:String = "k87j6e7c"
//        let Timestamp = fetchTime()
//        let startTimestamp = Timestamp[0]
//        let stopTimestamp = Timestamp[1]
        let startTimestamp = 1616571000
        let stopTimestamp = 1616571600
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
            heartRateSet = String(data: data, encoding: .utf8)!
            heartRateAry = processingAPIdata(data: heartRateSet)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    func realtimeStep(id: String){
        let id:String = "k87j6e7c"
//        let Timestamp = fetchTime()
//        let startTimestamp = Timestamp[0]
//        let stopTimestamp = Timestamp[1]
        let startTimestamp = 1616569437
        let stopTimestamp = 1616572620
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
            stepSet = String(data: data, encoding: .utf8)!
            stepAry = processingAPIdataWithStep(data: stepSet)
            print("@WTVC. stepSet, ", stepSet, stepAry)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
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
    
    func dataToAry(data:Data) ->[NSArray]?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let ary = json as! [NSArray]
            return ary
        }catch _ {
            print("Error")
            return nil
        }
    }
}
