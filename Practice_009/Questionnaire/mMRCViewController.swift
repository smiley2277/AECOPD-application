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
    override func viewDidLoad() {
        super.viewDidLoad()
        level1.layer.borderColor = UIColor.black.cgColor
        level2.layer.borderColor = UIColor.black.cgColor
        level3.layer.borderColor = UIColor.black.cgColor
        level4.layer.borderColor = UIColor.black.cgColor
        level5.layer.borderColor = UIColor.black.cgColor
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
