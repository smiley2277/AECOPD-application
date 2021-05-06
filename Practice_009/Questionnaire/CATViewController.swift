//
//  CATViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/2/25.
//

import Foundation
import UIKit

class CATViewController: UIViewController{
    
    @IBOutlet weak var sliderOne: UISlider!
    @IBOutlet weak var ansOne: UILabel!
    @IBOutlet weak var sliderTwo: UISlider!
    @IBOutlet weak var ansTwo: UILabel!
    @IBOutlet weak var sliderThree: UISlider!
    @IBOutlet weak var ansThree: UILabel!
    @IBOutlet weak var sliderFour: UISlider!
    @IBOutlet weak var ansFour: UILabel!
    @IBOutlet weak var sliderFive: UISlider!
    @IBOutlet weak var ansFive: UILabel!
    @IBOutlet weak var sliderSix: UISlider!
    @IBOutlet weak var ansSix: UILabel!
    @IBOutlet weak var sliderSeven: UISlider!
    @IBOutlet weak var ansSeven: UILabel!
    @IBOutlet weak var sliderEight: UISlider!
    @IBOutlet weak var ansEight: UILabel!
    @IBOutlet weak var catScrollView: UIScrollView!
    var siteDict: [Int: Int] = [0:121,1:274,2:465,3:682,4:889,5:1103,6:1272,7:1457]
    
    @IBAction func sliderChange1(_ sender: UISlider) {
        sender.value.round()
        ansOne.text = Int(sender.value).description
    }
    @IBAction func sliderChange2(_ sender: UISlider) {
        sender.value.round()
        ansTwo.text = Int(sender.value).description
    }
    @IBAction func sliderChange3(_ sender: UISlider) {
        sender.value.round()
        ansThree.text = Int(sender.value).description
    }
    @IBAction func sliderChange4(_ sender: UISlider) {
        sender.value.round()
        ansFour.text = Int(sender.value).description
    }
    @IBAction func sliderChange5(_ sender: UISlider) {
        sender.value.round()
        ansFive.text = Int(sender.value).description
    }
    @IBAction func sliderChange6(_ sender: UISlider) {
        sender.value.round()
        ansSix.text = Int(sender.value).description
    }
    @IBAction func sliderChange7(_ sender: UISlider) {
        sender.value.round()
        ansSeven.text = Int(sender.value).description
    }
    @IBAction func sliderChange8(_ sender: UISlider) {
        sender.value.round()
        ansEight.text = Int(sender.value).description
    }
    @IBOutlet weak var sum: UILabel!
    
    @IBOutlet weak var countButton: UIButton!
    @IBAction func countSum(_ sender: Any) {
        var totalScore = 0
        let  ansArray = [ansOne.text,ansTwo.text,ansThree.text,ansFour.text,ansFive.text,ansSix.text,ansSeven.text,ansEight.text]
        if (ansArray.contains("請滑動滑桿")){
            for i in Range(0...ansArray.count-1){
                if (ansArray[i] == "請滑動滑桿"){
                    print(siteDict[i])
                    let targetRect = CGRect(x: 0, y: siteDict[i] ?? 0, width: 1, height: 1)
//                    catScrollView.setContentOffset(CGPointMake(targetRect, <#CGFloat#>), animated:YES)
                    catScrollView.scrollRectToVisible(targetRect, animated: true)
                }
            }
            countButton.isUserInteractionEnabled = false
        }else{
            for i in ansArray{
                let num:Int? = Int(i!) ?? 0
                totalScore += num!
            }
        }
        sum.text = String(totalScore)
        let oneText = ansOne.text!
        let twoText = ansTwo.text!
        let thrText = ansThree.text!
        let forText = ansFour.text!
        let fivText = ansFive.text!
        let sixText = ansSix.text!
        let sevText = ansSeven.text!
        let eigText = ansEight.text!
        let sumText = sum.text!
        sumAry = [oneText , twoText, thrText,forText, fivText, sixText, sevText, eigText, sumText]
        if sumAry.contains("請滑動滑桿"){
            summitButton.isUserInteractionEnabled = false
        }else{
            summitButton.isUserInteractionEnabled = true
        }

    }
    var sumAry:[String] = []
    
    @IBOutlet weak var summitButton: UIButton!
    @IBAction func summit(_ sender: UIButton) {
        performSegue(withIdentifier: "summitCATSegue", sender: self)
    }
    
    override func viewDidLoad() {
        sum.layer.cornerRadius = 15
        sum.layer.masksToBounds = true
        summitButton.isUserInteractionEnabled = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? quesViewController
        controller?.catAry = sumAry
    }
    
}


