//
//  walkingTestViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/18.
//

import UIKit
import AVFoundation
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class walkingTestViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var flashSignal: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var restOfTime: UILabel!
    var durationFill: Int = 0
    var speedFill: Float = 0.0
    var trainingSpeed:Float = 385 //外部：km/hr｜內部：BPM 每分鐘幾下
    var trainingDuration:Int = 1200 //外部：min｜內部：sec
    var stepSize: Double = 0
    var stepSizeLife: Double = 0
    var audioPlayer = AVAudioPlayer()
    weak var timer:Timer!
    weak var flashTimer:Timer!
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
    //preprocessing & setting
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
    override func viewDidLoad() {
        playButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        //using protocol and delegate to receive
        //        delegate?.SendStepSize(size: 3)
        // 導覽列右邊按鈕
        let rightButton = UIBarButtonItem(
            title:"設定",
            style:.plain,
            target:self,
            action:#selector(walkingTestViewController.setting))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = rightButton
        
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
        let vc = storyboard.instantiateViewController(withIdentifier: "speedDurationViewController") as! speedDurationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //catch by storyboard
    func setStepSize(size: Double)->Double{
        self.stepSizeLife = size
        return size
    }
//    func setSpeed(speed: Float)->Float{
//        self.speedFill = speed
//        return speed
//    }
//    func setDuration(duration: Int)->Int{
//        self.durationFill = duration
//        return duration
//    }
    //unit transfer
    func unitTransfer(speed: Float, size: Double)-> Float{
        let transSpeed = speed * 100 / (Float(size)/6)
        return transSpeed
    }
    func fetchStepSize(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "speedDurationViewController") as! speedDurationViewController
        let info_SS = vc.settingDefault(keyName: "stepSize")
        let info_S = vc.settingDefault(keyName: "speed")
        let info_D = vc.settingDefault(keyName: "duration")
        if (stepSizeLife <= 0){
            stepSize = (info_SS as! NSString).doubleValue
            stepSize = trunc(stepSize * 10) / 10
            trainingSpeed = (info_S as! NSString).floatValue
            trainingSpeed = trunc(trainingSpeed * 10) / 10
            trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
            trainingDuration = Int((info_D as! NSString).intValue)*60
            print("@WTVC, info, ", stepSize, trainingSpeed, trainingDuration)
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
        let notificationName = Notification.Name("sendTimestamp")
        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":[startTime, stopTime]])
    }
    @IBAction func start(_ sender: Any) {
        fetchStepSize()
        print("@WTVC, stepSize", stepSize)
        if (stepSize <= 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }else{
            if (durationFill != 0) || (speedFill != 0.0){
                if (durationFill > 0 ) && (speedFill > 0.0){
                    trainingSpeed = speedFill
                    trainingDuration = durationFill
                    trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
                    trainingDuration = trainingDuration * 60
                } else if (durationFill > 0 ) {
                    trainingDuration = durationFill
                    trainingDuration = trainingDuration * 60
                } else if (speedFill > 0.0){
                    trainingSpeed = speedFill
                    trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
                }
            }
            let countDuration = trainingDuration
            countDown(duration: countDuration, speed: trainingSpeed)
            startTime = Date()
            flashingTimer(duration: countDuration, speed: trainingSpeed)
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
            print("@WTVC, stopTime,", stopTime)
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
            let countDuration = trainingDuration
            //確認timer 狀態 isValid（若timer啟動,則為true）
            if ((timer?.isValid) != nil){
                stopCountDown()
                timer = nil
            }
            if ((flashTimer?.isValid) != nil){
                pauseFlashing()
                flashTimer = nil
            }
            countDown(duration: countDuration, speed: trainingSpeed)
            flashingTimer(duration: countDuration, speed: trainingSpeed)
        }
    }
    
    
    
    //animation and timers
    func countDown(duration: Int, speed: Float){
        var countDownNum = duration
        timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true, block: { [self] (timer) in
            restOfTime.text = String(countDownNum/60)
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
        timer!.invalidate()
        timer = nil
        flashTimer!.invalidate()
        flashTimer = nil
    }
    func flashingTimer(duration: Int, speed: Float){
        var countDownNum = duration
        flashTimer = Timer.scheduledTimer(withTimeInterval:CFTimeInterval(60/speed), repeats: true, block: { [self] (timer) in
            playAudio()
            flashing(setColor: color, trainingSpeed: speed)
            countDownNum -= 1
            if countDownNum == 0{
                restOfTime.text = String(duration)
                timer.invalidate()
                pauseFlashing()
                let finishAlert = UIAlertController(title: "完成", message: "測驗已完成", preferredStyle: .alert)
                finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                self.present(finishAlert, animated: true)
            }
        }
        )
    }
    func flashing(setColor: UIColor, trainingSpeed: Float){
        flashSignal.alpha = 1.0
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = CFTimeInterval(60/trainingSpeed) //一次動畫做幾秒
        animation.repeatDuration = CFTimeInterval(60/trainingSpeed)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        flashSignal.layer.add(animation, forKey: "")
    }
    func pauseFlashing(){
        let pausedTime : CFTimeInterval = flashSignal.layer.convertTime(CACurrentMediaTime(), from: nil)
        flashSignal.layer.timeOffset = pausedTime
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
        return [timeStamp, timeStamp2]
    }
    
    func realtimeHR(id: String){
        let id:String = "k87j6e7c"
        let Timestamp = fetchTime()
        let startTimestamp = Timestamp[0]
        let stopTimestamp = Timestamp[1]
//        let startTimestamp = 1616571000
//        let stopTimestamp = 1616571600
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
        let Timestamp = fetchTime()
        let startTimestamp = Timestamp[0]
        let stopTimestamp = Timestamp[1]
//        let startTimestamp = 1616569437
//        let stopTimestamp = 1616572620
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
    
}
