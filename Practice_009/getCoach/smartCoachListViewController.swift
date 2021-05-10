//
//  smartCoachListViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/9.
//

import Foundation
import UIKit

class smartCoachListViewController: BaseViewController {
    var stepSize: Double = 0.0
    var startTime: String = ""
    let userId = UserDefaultUtil.shared.adminUserID
    let dateFormatter = DateFormatter()
    var userDefaults: UserDefaults!
    private var presenter: getCoachPresenterProtocol?
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
    @IBAction func walkingTest(_ sender: Any) {
        //send to walkingTestViewController.swift by storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "walkingTestViewController") as! walkingTestViewController
        vc.setStepSize(size: stepSize)
        vc.startString = startTime
        //open walkingTestViewController.swift without segue
        self.navigationController?.pushViewController(vc, animated: true)
        //using protocol and delagate to deliver
//        vc.delegate = self
    }
    @IBAction func variableTest(_ sender: Any) {
        //send to walkingTestViewController.swift by storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "variableSpeedViewController") as! variableSpeedViewController
        vc.setStepSize(size: stepSize)
        vc.startString = startTime
        print("@SCLVC startString,", startTime)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        print(userId)
        userDefaults = UserDefaults.standard
        presenter = getCoachPresenter(delegate: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        if (UserDefaultUtil.shared.borgUuid == nil){
            print("No borg_uuid")
        }else{
            presenter?.getCoach(userId: userId!, borg_uuid: UserDefaultUtil.shared.borgUuid!, timestamp: dateString)
        }
    }
}

extension smartCoachListViewController: getCoachViewProtocol {
    func onBindGetCoachResult(Result: PatientCoach){
        print(Result.data!.data.count)
        if (Result.data!.data.count > 1){
            var sped: [Float] = []
            var dura: [Int] = []
            for i in (0...Result.data!.data.count-1){
                sped.append(Float(Result.data!.data[i].speed!))
                dura.append(Result.data!.data[i].time!)
            }
            print(sped, dura)
            userDefaults.set(sped, forKey: "speedVFromD")
            userDefaults.set(dura, forKey: "durationVFromD")
            userDefaults.synchronize()
        }else if (Result.data!.data.count == 1){
            var speed: Float = 0.0
            var durat: Int = 0
            speed = Float(Result.data!.data[0].speed!)
            durat = Result.data!.data[0].time!
            print(speed, durat)
            userDefaults.set(speed, forKey: "speedFromD")
            userDefaults.set(durat, forKey: "durationFromD")
            userDefaults.synchronize()
        }
    }
}
