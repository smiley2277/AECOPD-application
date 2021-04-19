//
//  smartCoachListViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/9.
//

import Foundation
import UIKit

//protocol  smartCoachListViewControllerProtocol : NSObjectProtocol{
//    func onBindW(w: Int)
//}

class smartCoachListViewController: UIViewController {
    var stepSize: Double = 0.0
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
    @IBAction func walkingTest(_ sender: Any) {
        //send to walkingTestViewController.swift by storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "walkingTestViewController") as! walkingTestViewController
        vc.setStepSize(size: stepSize)
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
    }
    override func viewDidLoad() {
    }
}

//extension smartCoachListViewController: smartCoachListViewControllerProtocol {
//    func onBindW(w: Int) {
//
//    }
//}
