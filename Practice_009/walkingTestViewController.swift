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


class walkingTestViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var flashSignal: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var restOfTime: UILabel!
    var durationFill: Int = 0
    var speedFill: Float = 0.0
    var trainingSpeed:Float = 0 //外部：km/hr｜內部：BPM 每分鐘幾下
    var trainingDuration:Int = 0 //外部：min｜內部：sec
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
    var stopString: String = ""
    var startString: String = ""
    let dateFormatter = DateFormatter()
    let cookie:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM; connect.sid=s%3AqMQr9uUfeHIHUyqDbiE4OetAxJiNzQYx.3A8bRMYiheV8JU%2BxhWVIJH3KyysgQM%2FntsC4qvIieXc"
    //preprocessing & setting
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? borgScalePostTestViewController
        vc?.stopTime = stopString
    }
    
    override func viewDidLoad() {
        UIApplication.shared.isIdleTimerDisabled = true
        playButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        // using protocol and delegate to receive
        // 導覽列右邊按鈕
        let rightButton = UIBarButtonItem(
            title:"設定",
            style:.plain,
            target:self,
            action:#selector(walkingTestViewController.setting))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = rightButton
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .custom)
        self.setCustomRightBarButtonItems(barButtonItems: [rightButton])
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startTime = dateFormatter.date(from: startString)
        print("viewDidLoad, stopString", startString)
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
    func setStepSize(size: Double)-> Double{
        self.stepSizeLife = size
        return size
    }
    //unit transfer
    func unitTransfer(speed: Float, size: Double)-> Float{
        let transSpeed = 9 * Float(size) / (250 * speed)
        return transSpeed
    }
    func fetchStepSize(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "speedDurationViewController") as! speedDurationViewController
        let info_SS = vc.settingDefault(keyName: "stepSize")
        let info_S = vc.settingDefault(keyName: "speed")
        let info_D = vc.settingDefault(keyName: "duration")
        let info_SFD = vc.settingDefault(keyName: "speedFromD")
        let info_DFD = vc.settingDefault(keyName: "durationFromD")
        if (stepSizeLife <= 0){
            stepSize = (info_SS! as NSString).doubleValue
            stepSize = trunc(stepSize * 10) / 10
            trainingSpeed = (info_S! as NSString).floatValue
            trainingSpeed = trunc(trainingSpeed * 10) / 10
            trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
            trainingDuration = Int((info_D as! NSString).intValue)*60
        }else{
            stepSize = stepSizeLife
            trainingSpeed = (info_S! as NSString).floatValue
            trainingSpeed = trunc(trainingSpeed * 10) / 10
            trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
            trainingDuration = Int((info_D as! NSString).intValue)*60
        }
        
        if (vc.settingDefault(keyName: "mode") == "self"){
            if (info_S != "0") && (info_D != "0"){
                trainingSpeed = (info_S! as NSString).floatValue
                trainingSpeed = trunc(trainingSpeed * 10) / 10
                trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
                trainingDuration = Int((info_D as! NSString).intValue)*60
            }
        }else if(vc.settingDefault(keyName: "mode") == "Doc"){
            if (info_SFD != "0") && (info_DFD != "0"){
                trainingSpeed = (info_SFD! as NSString).floatValue
                trainingSpeed = trunc(trainingSpeed * 10) / 10
                trainingSpeed = unitTransfer(speed: trainingSpeed, size: stepSize)
                trainingDuration = Int((info_DFD as! NSString).intValue)*60
                print("@WTVC, info from backend, ", trainingDuration, trainingSpeed , info_SFD , info_DFD)
            }
            
        }
    }
    //button function
    @IBAction func finish(_ sender: Any) {
        stopCountDown()
        timer = nil
        flashTimer = nil
        stopTime = Date()
        let notificationName = Notification.Name("sendTimestamp")
        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":[startTime, stopTime]])
        //send to borgScalePostTestViewController.swift
        stopString = dateFormatter.string(from: stopTime! as Date)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewCont = storyboard.instantiateViewController(withIdentifier: "borgScalePostTestViewController") as! borgScalePostTestViewController
        viewCont.stopTime = stopString
        viewCont.getTime(time: stopString)
        print("finish, stopString", stopString)
    }
    @IBAction func start(_ sender: Any) {
        fetchStepSize()
        if (stepSize <= 0){
            let finishAlert = UIAlertController(title: "提醒", message: "請至『設定』輸入十公尺走了幾步，或先開啟『生理數據』", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }else{
            print("trainingSpeed \(trainingSpeed)")
            let countDuration = trainingDuration
            countDown(duration: countDuration, speed: trainingSpeed)
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
            pauseFlashing()
            stopTime = Date()
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
            //確認timer 狀態 isValid（若timer啟動,則為true
            timer = nil
            flashTimer = nil
            stopCountDown()
            countDown(duration: countDuration, speed: trainingSpeed)
            flashingTimer(duration: countDuration, speed: trainingSpeed)
        }
    }
    //animation and timers
    func countDown(duration: Int, speed: Float){
        var countDownNum = duration
        timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true, block: { [self] (timer) in
            restOfTime.text = String(countDownNum/60+1)
            countDownNum -= 1
            if (countDownNum % 60 == 0){
                playAudioForMin()
            }
            if countDownNum == 0 {
                restOfTime.text = String(countDownNum)
                stopCountDown()
                let finishAlert = UIAlertController(title: "完成", message: "測驗已完成", preferredStyle: .alert)
                finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                self.present(finishAlert, animated: true)
            }
        })
    }
    func stopCountDown(){
        if ((timer?.isValid) != nil){
            timer.invalidate()
        }
        if ((flashTimer?.isValid) != nil){
            pauseFlashing()
            flashTimer.invalidate()
        }
    }
    func flashingTimer(duration: Int, speed: Float){
        print("speed and timeinterval \(speed)")
        flashTimer = Timer.scheduledTimer(withTimeInterval:CFTimeInterval(speed), repeats: true, block: { [self] (timer) in
            playAudio()
            flashing(setColor: color, trainingSpeed: speed)
        }
        )
    }
    func flashing(setColor: UIColor, trainingSpeed: Float){
        flashSignal.alpha = 1.0
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = CFTimeInterval(trainingSpeed) //一次動畫做幾秒
        animation.repeatDuration = CFTimeInterval(trainingSpeed)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        flashSignal.layer.add(animation, forKey: "")
    }
    func pauseFlashing(){
        let pausedTime : CFTimeInterval = flashSignal.layer.convertTime(CACurrentMediaTime(), from: nil)
        flashSignal.layer.timeOffset = pausedTime
    }
    func playAudio(){
        let url = Bundle.main.url(forResource: "knob-amp19", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    func playAudioForMin(){
        let url = Bundle.main.url(forResource: "stage", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.enableRate = true
        audioPlayer.rate = 1
        audioPlayer.play()
    }
}
