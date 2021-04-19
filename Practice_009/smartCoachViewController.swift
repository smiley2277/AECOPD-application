//
//  smartCoachViewController.swift
//  Practice_009
//  測十公尺走幾步的...
//  Created by 鄭郁潔 on 2021/3/15.
//

import Foundation
import UIKit
import CoreLocation
import AVFoundation

class smartCoachViewController: UIViewController, CLLocationManagerDelegate,UITextFieldDelegate{
    let locationManager = CLLocationManager()
    @IBOutlet weak var stepCount: UITextField!
    @IBOutlet weak var restartButton: UIButton!
    var route:[Double] = []
    var lengthOfRoute: Double = 0.0
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        stepCount.delegate = self
        restartButton.titleLabel?.lineBreakMode = .byWordWrapping
        restartButton.setTitle("重新\n開始", for:.normal)
        //GPS location request
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    //GPS location request
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        route.append(contentsOf: [location.coordinate.longitude, location.coordinate.latitude])
        print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)",lengthOfRoute)
        if (route.count > 4){
//            print("calculating")
            lengthOfRoute = distanceCalculate(route: route)
            if(lengthOfRoute >= 10){
//                print("stop")
                playAudio()
                locationManager.stopUpdatingLocation()
                let tenMAlert = UIAlertController(title: "十公尺已完成", message: "您已經走了十公尺，請填寫步數", preferredStyle: .alert)
                tenMAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
                self.present(tenMAlert, animated: true)
                
            }
        }
        
    }
    //GPS location error raise
    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error){
           print("error to collect location")
           print(error)
       }
    //button startCalculate
    @IBAction func startCalculate(_ sender: Any) {
        playAudio()
        locationManager.startUpdatingLocation()
    }
    //calculate distance
    func distanceCalculate(route: [Double])->Double{
        var distance:Double = 0.0
        var startPod:[Double] = [route[0],route[1]]
        var stopPod:[Double]
        var c:Double
        if (route.count > 4){
            for i in Range(2...route.count-2){
                if(i%2 == 0){
                    stopPod = [route[i],route[i+1]]
                    if (i == 2){
                        c = ((sin(startPod[1])*sin(stopPod[1]) + cos(startPod[1])*cos(stopPod[1])*cos(stopPod[0]-startPod[0])))
                    }else{
                        startPod = [route[i-2],route[i-1]]
                        c = ((sin(startPod[1])*sin(stopPod[1]) + cos(startPod[1])*cos(stopPod[1])*cos(stopPod[0]-startPod[0])))
                    }
                    let d = 6371 * acos(c) * Double.pi / 180.0 * 1000 //公尺
                    distance += d
                }
                
            }
        }
        return distance
    }
    
    @IBAction func reStartButton(_ sender: Any) {
        
        lengthOfRoute = 0.0
        route = []
        startCalculate(UIButton.self)
    }
    //play audio
    func playAudio(){
        let url = Bundle.main.url(forResource: "oh-finally-355", withExtension:"mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    @IBAction func finish(_ sender: UIButton) {
        let sc = stepCount.text!
        if (sc == "") {
            let fillInAlert = UIAlertController(title: nil, message: "請填寫步數", preferredStyle: .alert)
            fillInAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(fillInAlert, animated: true)
        }else{
            performSegue(withIdentifier: "stepSizeUnwindSegue", sender: self)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? smartSubViewController
        let sc = stepCount.text!
        if (sc != ""){
            controller?.stepSize = 10/Double(stepCount.text!)!
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        // 只允許輸入數字
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        // let expression = "^[0-9]*([0-9])?$" 只允許輸入數字
        // let expression = "^[A-Za-z0-9]+$" //允許輸入數字及字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
            let finishAlert = UIAlertController(title: "錯誤", message: "請輸入數字", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
            return false
        }
        return true
    }
}
