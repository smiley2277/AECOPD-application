//
//  OnlinePredictViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/19.
//

import Foundation
import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class OnlinePredictViewController: UIViewController{
    var probData:String = ""
    @IBOutlet weak var comment: UILabel!
    let cookies:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM"
    override func viewDidLoad() {
        getProb()
        extract(text: probData)
    }
    func getProb() {
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://ntu-med-god.ml/api/getUserAECOPDRate?id=k87j6e7c")!,timeoutInterval: Double.infinity)
        request.addValue(cookies, forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.probData = String(data: data, encoding: .utf8)!
//            DispatchQueue.main.async {
//                self.comment.text = self.probData
//            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
    }
    func extract(text: String){
        var proText = ""
        var spltAry:[String] = []
        proText = text.replacingOccurrences(of: "[", with: "")
        proText = proText.replacingOccurrences(of: "]", with: "")
        proText = proText.replacingOccurrences(of: "{", with: "")
        proText = proText.replacingOccurrences(of: "}", with: "")
        let lifeAry = proText.components(separatedBy: ",")
        for i in Range(0...lifeAry.count-1){
            let sigAry = lifeAry[i].components(separatedBy: ":")
            for j in Range(0...sigAry.count-1){
                let sigElem = sigAry[j].replacingOccurrences(of: "\"", with: "")
                spltAry.append(sigElem)
            }
        }
        for idx in Range(0...spltAry.count-1){
            if(spltAry[idx] == "value"){
                comment.text = String(Double(spltAry[idx+1]) ?? 0)
            }
        }
    }
    
}
