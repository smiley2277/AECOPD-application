//
//  smartCoachListViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/9.
//

import Foundation
import UIKit

class smartCoachListViewController: UIViewController {
    var stepSize: Double = 0.0
    var startTime: String = ""
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
    }
}
