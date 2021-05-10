//
//  eq5dViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/2.
//

import Foundation
import UIKit

class eq5dViweController: UIViewController{
    @IBOutlet weak var q1Slider: UISlider!
    @IBOutlet weak var q2Slider: UISlider!
    @IBOutlet weak var q3Slider: UISlider!
    @IBOutlet weak var q4Slider: UISlider!
    @IBOutlet weak var q5Slider: UISlider!
    @IBOutlet weak var vasSlider: UISlider!
    @IBOutlet weak var q1Ans: UILabel!
    @IBOutlet weak var q2Ans: UILabel!
    @IBOutlet weak var q3Ans: UILabel!
    @IBOutlet weak var q4Ans: UILabel!
    @IBOutlet weak var q5Ans: UILabel!
    @IBOutlet weak var vasAns: UILabel!
    @IBOutlet weak var suggest: UILabel!
    @IBOutlet weak var eq5dScrollView: UIScrollView!
    var siteDict: [Int: Int] = [0:750,1:564,2:378,3:195,4:0]
    var labelDict: [Int: UILabel] = [:]
    var finishTimes: Int = 0
    func checkButtonStatus(){
        let oneText = q1Ans.text!
        let twoText = q2Ans.text!
        let thrText = q3Ans.text!
        let forText = q4Ans.text!
        let fivText = q5Ans.text!
        let vas = vasAns.text!
        sumAry = [oneText , twoText, thrText,forText, fivText]
        if(vasAns.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[0] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[0] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[0]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[0]!.backgroundColor = UIColor.white
        }
        if(q5Ans.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[0] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[0] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[1]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[1]!.backgroundColor = UIColor.white
        }
        if(q4Ans.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[1] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[1] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[2]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[2]!.backgroundColor = UIColor.white
        }
        if(q3Ans.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[2] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[2] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[3]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[3]!.backgroundColor = UIColor.white
        }
        if(q2Ans.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[3] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[3] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[4]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[4]!.backgroundColor = UIColor.white
        }
        if (q1Ans.text == "請滑動滑桿"){
            let targetRect = CGRect(x: 0, y: siteDict[4] ?? 0, width: 1, height: 1)
            eq5dScrollView.setContentOffset(CGPoint(x: 0, y: siteDict[4] ?? 0), animated: true)
            eq5dScrollView.scrollRectToVisible(targetRect, animated: true)
            labelDict[5]!.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
            summitButton.isUserInteractionEnabled = false
        }else{
            labelDict[5]!.backgroundColor = UIColor.white
        }
        if(sumAry.contains("請滑動滑桿")) || (vas == "請滑動滑桿"){
            summitButton.isUserInteractionEnabled = false
        }else{
            summitButton.isUserInteractionEnabled = true
        }
    }
    @IBAction func q1Change(_ sender: UISlider) {
        sender.value.round()
        q1Ans.text = Int(sender.value).description
        checkButtonStatus()
    }
    @IBAction func q2Change(_ sender: UISlider) {
        sender.value.round()
        q2Ans.text = Int(sender.value).description
        checkButtonStatus()
    }
    @IBAction func q3Change(_ sender: UISlider) {
        sender.value.round()
        q3Ans.text = Int(sender.value).description
        checkButtonStatus()
    }
    @IBAction func q4Change(_ sender: UISlider) {
        sender.value.round()
        q4Ans.text = Int(sender.value).description
        checkButtonStatus()
    }
    @IBAction func q5Change(_ sender: UISlider) {
        sender.value.round()
        q5Ans.text = Int(sender.value).description
        checkButtonStatus()
    }
    @IBAction func vasChange(_ sender: UISlider) {
        sender.value.round()
        vasAns.text = Int(sender.value).description
        checkButtonStatus()
    }
    override func viewDidLoad() {
        suggest.text = "0-100分，越高則對生活越滿意"
        labelDict = [0:vasAns,1:q5Ans,2:q4Ans,3:q3Ans,4:q2Ans,5:q1Ans]
        summitButton.isUserInteractionEnabled = false
    }
    var sumAry:[String] = []
    @IBOutlet weak var summitButton: UIButton!
    @IBAction func summit(_ sender: UIButton) {
            performSegue(withIdentifier: "summitEq5dSeque", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? quesViewController
        controller?.eq5Ary = sumAry
    }
}
