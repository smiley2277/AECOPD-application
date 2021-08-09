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


class variableSpeedViewController: BaseViewController, UITextFieldDelegate {
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

    let dateFormatter = DateFormatter()
    var startTime: Date?
    var stopTime: Date?
    var startString: String = ""
    var stopString: String = ""
    let cookie:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM; connect.sid=s%3AqMQr9uUfeHIHUyqDbiE4OetAxJiNzQYx.3A8bRMYiheV8JU%2BxhWVIJH3KyysgQM%2FntsC4qvIieXc"
    weak var delegate: lifestyleViewControllerProtocol?
    let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
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
        // 導覽列右邊按鈕
        let rightButton = UIBarButtonItem(
            title:"設定",
            style:.plain,
            target:self,
            action:#selector(variableSpeedViewController.setting))
        // 加到導覽列中
        self.navigationItem.rightBarButtonItem = rightButton
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .custom)
        self.setCustomRightBarButtonItems(barButtonItems: [rightButton])
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startTime = dateFormatter.date(from: startString)
        print("@VSVC startSting", startString)
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
        let transSpeed = 9 * Float(size) / (250 * speed)
        return transSpeed
    }
    func aryUnitTransfer(speed: [Float], size: Double)-> [Float]{
        var ary:[Float] = []
        for i in Range(0...speed.count-1){
            let arc = 9 * Float(size) / (250 * speed[i])
            ary.append(arc)
        }
        return ary
    }
    func fetchStepSize(){ // from setting
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "variableSettingViewController") as! variableSettingViewController
        let info_SS = vc.settingDefault(keyName: "stepSize")
        let info_SP = vc.settingDefaultForFloatAry(keyName: "speedV")
        let info_DD = vc.settingDefaultForAry(keyName: "durationV")
        
        let info_SPFD = vc.settingDefaultForFloatAry(keyName: "speedVFromD")
        let info_DDFD = vc.settingDefaultForAry(keyName: "durationVFromD")
//        print("@VSVC, info, ", info_SP, info_SPFD)
        if (stepSizeLife == 0){
            stepSize = (info_SS! as NSString).doubleValue
            stepSize = trunc(stepSize * 10) / 10
            print("@VSVC, info, ", stepSize)
        }else{
            stepSize = stepSizeLife
        }
        //怪怪的
        if (vc.settingDefault(keyName: "mode") == "self"){
//            print(vc.settingDefault(keyName: "mode"))
            if (info_SP != []) && (info_DD != []){
                varSpeed = info_SP!
                varDuration = info_DD!
                print("@VSVC, info, ", varSpeed, varDuration , info_SP , info_DD)
            }
        }else if (vc.settingDefault(keyName: "mode") == "Doc"){
            print(vc.settingDefault(keyName: "mode"))
            if (info_SPFD != []) && (info_DDFD != []){
                varSpeed = info_SPFD!
                varDuration = info_DDFD!
                print("@VSVC, info from backend, ", varSpeed, varDuration , info_SPFD , info_DDFD)
            }
        }
        
    }
    
    //button function
    @IBAction func finish(_ sender: Any) {
        stopCountDown()
        timer = nil
        flashTimer = nil
        stopTime = Date()
        let notificationName = Notification.Name("sendTimestampByVariable")
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
            print(varSpeed)
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
//            print("@VSVC, stopTime,", stopTime)
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
            flashingTimer(duration: durationAry, speed: speedAry, sec: countDownNum)
        }
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
        animation.duration = CFTimeInterval(trainingSpeed) //一次動畫做幾秒
        animation.repeatDuration = CFTimeInterval(trainingSpeed) //改成總秒數
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
        timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true, block: { [self] (timer) in
            restOfTime.text = String(countDownNum/60+1)+" : "+String(countDownNum%60)
            let stageSec = duration.firstIndex(where: { $0 == countDownNum })
            if stageSec != nil{
                u = stageSec!
                let temp = speedAry.first!
                speedAry.remove(at: 0)
                flashTimer?.invalidate()
                pauseFlashing()
                playAudioForStage()
                flashTimer = Timer.scheduledTimer(withTimeInterval:CFTimeInterval(temp), repeats: true, block: { [self] (timer) in
                    playAudio()
                    flashing(setColor: color, trainingSpeed: temp)
                    
                })
            }
            let text = String(u+1)
            stageLabel.text = "階段 " + text
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
        let url = Bundle.main.url(forResource: "knob-amp19", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func playAudioForStage(){
        let url = Bundle.main.url(forResource: "stage", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.enableRate = true
        audioPlayer.rate = 1
        audioPlayer.play()
    }
}
