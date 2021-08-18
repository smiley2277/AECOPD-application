//
//  mMRCViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/2.
//

import Foundation
import UIKit

class mMRCViewController: UIViewController{
    var mMRCValue = 0
    @IBOutlet weak var level1: UIButton!
    @IBOutlet weak var level2: UIButton!
    @IBOutlet weak var level3: UIButton!
    @IBOutlet weak var level4: UIButton!
    @IBOutlet weak var level5: UIButton!
    let color = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    let checkColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        level1.backgroundColor = color
        level2.backgroundColor = color
        level3.backgroundColor = color
        level4.backgroundColor = color
        level5.backgroundColor = color
//        level5.layer.borderColor = UIColor.black.cgColor
        level1.layer.borderWidth = 2
        level2.layer.borderWidth = 2
        level3.layer.borderWidth = 2
        level4.layer.borderWidth = 2
        level5.layer.borderWidth = 2
        summitButton.isUserInteractionEnabled = false
    }
    @IBOutlet weak var summitButton: UIButton!
    
    @IBAction func level1Check(_ sender: UIButton) {
        level1.setTitle("✓", for: .normal)
        level1.setTitleColor(checkColor, for: UIControlState.normal)
        level2.setTitle("", for: .normal)
        level3.setTitle("", for: .normal)
        level4.setTitle("", for: .normal)
        level5.setTitle("", for: .normal)
        mMRCValue = 0
        summitButton.isUserInteractionEnabled = true

        
    }
    
    @IBAction func level2Check(_ sender: UIButton) {
        level1.setTitle("", for: .normal)
        level2.setTitle("✓", for: .normal)
        level2.setTitleColor(checkColor, for: UIControlState.normal)
        level3.setTitle("", for: .normal)
        level4.setTitle("", for: .normal)
        level5.setTitle("", for: .normal)
        mMRCValue = 1
        summitButton.isUserInteractionEnabled = true
    }
    
    @IBAction func level3Check(_ sender: UIButton) {
        level1.setTitle("", for: .normal)
        level2.setTitle("", for: .normal)
        level3.setTitle("✓", for: .normal)
        level3.setTitleColor(checkColor, for: UIControlState.normal)
        level4.setTitle("", for: .normal)
        level5.setTitle("", for: .normal)
        mMRCValue = 2
        summitButton.isUserInteractionEnabled = true
    }
    @IBAction func level4Check(_ sender: UIButton) {
        level1.setTitle("", for: .normal)
        level2.setTitle("", for: .normal)
        level3.setTitle("", for: .normal)
        level4.setTitle("✓", for: .normal)
        level4.setTitleColor(checkColor, for: UIControlState.normal)
        level5.setTitle("", for: .normal)
        mMRCValue = 3
        summitButton.isUserInteractionEnabled = true
    }
    
    @IBAction func level5Check(_ sender: UIButton) {
        level1.setTitle("", for: .normal)
        level2.setTitle("", for: .normal)
        level3.setTitle("", for: .normal)
        level4.setTitle("", for: .normal)
        level5.setTitle("✓", for: .normal)
        level5.setTitleColor(checkColor, for: UIControlState.normal)
        mMRCValue = 4
        summitButton.isUserInteractionEnabled = true
    }
    var sumAry:[Int] = []
    
    @IBAction func summit(_ sender: UIButton) {
        sumAry = [mMRCValue]
        performSegue(withIdentifier: "summitmMRCSeque", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? quesViewController
        controller?.mrcAry = sumAry
    }
    
}
