//
//  smartSubViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/23.
//

import Foundation
import UIKit


class smartSubViewController:BaseViewController{
    var stepSize:Double = 0.0
    var beforeBorg:Int = 0
    var afterBorg:Int = 0
    override func viewDidLoad() {
    }
    @IBAction func startTest(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? borgScaleViewController
        vc?.stepSize = stepSize
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
}
