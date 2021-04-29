//
//  lifestyleViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/11.
//

import CoreLocation
import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol  lifestyleViewControllerProtocol : NSObjectProtocol{
    func SendStepSize(size: Int) 
}
class lifestyleViewController: UIViewController, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    var date:Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    var protext = ""
    var lifedata:String = ""
    var hrdata:String = ""
    var airdata:String = ""
    // let userId = UserDefaultUtil.shared.adminUserID
    var userId:String = "k87j6e7c"
    var threeAPI:String = ""
    var hrAPI:String = ""
    var distanceNum: Double = 0.0
    var stepNum: Double = 0.0
    let cookies:String = "connect.sid=s%3AYEvBjFbMRdHNXmM1Y8HpbLJ7dj-685MD.J%2F56QcPFHOqtyy2F3yo%2FdLjCO35KUQdeSNl1%2BC5rYtM"
    var locationAry: [Double] = []
    var siteDic: Dictionary<String, [Double]>?
    var site: String = ""
    var airDic: Dictionary<String,String> = [:]
    var weaSiteDic: Dictionary<String, [Double]>?
    var weaSite: String = ""
    var weatherData: String = ""
    var weathDic: Dictionary<String,String> = [:]
    
    //GPS location request
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        locationAry = []
        locationAry.append(contentsOf: [location.coordinate.longitude, location.coordinate.latitude])
        self.site = calculateSite(siteDic: siteDic!, lonLat: locationAry)
        self.airDic = fetchAirData(text: self.airdata, siSt: self.site)
        pm25Label.text = airDic["PM2.5_AVG"]
        if (airDic["Pollutant"] != ""){
            polluLabel.text = airDic["Pollutant"]
        }else{
            polluLabel.text = "無"
        }
        aqiLabel.text = airDic["AQI"]
        statusLabel.text = airDic["Status"]
        self.weaSiteDic = fetchWeathsite(text: self.weatherData)
        self.site = calculateWeaSite(siteDic: self.weaSiteDic!, lonLat: locationAry)
        fetchWeath(text: self.weatherData, siSt: self.site)
    }
    //GPS location error raise
    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error){
           print("error to collect location")
           print(error)
       }
    
    func getCSVData(doc: String) -> Array<String> {
        let path = Bundle.main.path(forResource: doc, ofType: "csv")
        do {
            let content = try String(contentsOfFile: path!)
            let parsedCSV: [String] = content.components(separatedBy: "\n")
            return parsedCSV
        }
        catch {
            return []
        }
    }
    //site array processing
    func calSite(siteAry:[Any])-> Dictionary<String, [Double]>{
        var copySite = siteAry
        var siteDic: Dictionary<String, [Double]> = [:]
        for i in Range(0...copySite.count-1){
            var proText: [String] = []
            copySite[i] = (copySite[i] as AnyObject).replacingOccurrences(of: "\r", with: "")
            proText = (copySite[i] as AnyObject).components(separatedBy: ",")
            if (proText[2] != "Sitename"){
                let lon = (proText[3] as NSString).doubleValue
                let lat = (proText[4] as NSString).doubleValue
                siteDic[proText[2]] = [lon, lat]}
        }
        return siteDic
    }
    func calculateSite(siteDic: Dictionary<String, [Double]>, lonLat: [Double])-> String{
        var site: String = ""
        var disAry: Dictionary<Double, String> = [:]
        for i in siteDic.keys{
            let siteLonLat = siteDic[i]
            disAry[sqrt(pow(siteLonLat![0]-lonLat[0], 2) + pow(siteLonLat![1]-lonLat[1], 2))] = i
        }
        let sortedByValueDictionary = disAry.keys.sorted(by:{ $0 < $1 })
        site = disAry[sortedByValueDictionary[0]]!
        return site
    }
    //weather site array processing
    func calWeaSite(siteAry:[Any])-> Dictionary<String, [Double]>{
        var copySite = siteAry
        var siteDic: Dictionary<String, [Double]> = [:]
        for i in Range(0...copySite.count-1){
            var proText: [String] = []
            copySite[i] = (copySite[i] as AnyObject).replacingOccurrences(of: "\r", with: "")
            proText = (copySite[i] as AnyObject).components(separatedBy: ",")
            if (proText[1] != "Sitename"){
                let lon = (proText[2] as NSString).doubleValue
                let lat = (proText[3] as NSString).doubleValue
                siteDic[proText[1]] = [lon, lat]}
        }
        return siteDic
    }
    func calculateWeaSite(siteDic: Dictionary<String, [Double]>, lonLat: [Double])-> String{
        var site: String = ""
        var disAry: Dictionary<Double, String> = [:]
        for i in siteDic.keys{
            let siteLonLat = siteDic[i]
            disAry[sqrt(pow(siteLonLat![0]-lonLat[0], 2) + pow(siteLonLat![1]-lonLat[1], 2))] = i
        }
        let sortedByValueDictionary = disAry.keys.sorted(by:{ $0 < $1 })
        site = disAry[sortedByValueDictionary[0]]!
        return site
    }
    //get air quality data
    func getAir(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://data.epa.gov.tw/api/v1/aqx_p_432?limit=1000&api_key=bc53fb6e-d2ad-460d-a9f4-8df1eaa999a2")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.airdata = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    //get lifestyle data
    func getThree(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string:threeAPI)!,timeoutInterval: Double.infinity)
        request.addValue(cookies, forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [self]  data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.lifedata = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    //get heart rate data
    func getHeart(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: hrAPI)!,timeoutInterval: Double.infinity)
        request.addValue(cookies, forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.hrdata = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    //get weather data
    func getWeather(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0001-001?Authorization=CWB-76CAC058-E86F-4915-AEF5-0170A2E044D7&obsTime="+self.protext+"&elementName=TEMP,HUMD")!,timeoutInterval: Double.infinity)
        request.addValue("TS01dbf791=0107dddfefbd1f8690e3643fda5da3217042a34bf5eaad71b488a0de8137504613bee5420dde004d236032ddf86678af7fca6f6728", forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            self.weatherData = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
    }
    //fetch weather site data
    func fetchWeathsite(text: String)-> Dictionary<String, [Double]>{
        var Dict: Dictionary<String, [Double]> = [:]
        let airAry = text.components(separatedBy: "]")
        for comp in airAry{
            let temprange = comp.range(of:"TEMP", options:.regularExpression)
            if (temprange != nil) {
                //site processing
                var compr = comp.replacingOccurrences(of: "\"", with: "")
                compr = compr.replacingOccurrences(of: "}", with: "")
                compr = compr.replacingOccurrences(of: "{", with: "")
                compr = compr.replacingOccurrences(of: "[", with: "")
                let sigSiteAry = compr.components(separatedBy: ",")
                var lon:Double = 0.0
                var lat:Double = 0.0
                for i in Range(0...sigSiteAry.count-1){
                    let j = sigSiteAry[i].components(separatedBy: ":")
                    if (j[0] == "lon"){
                        lon = (j[1] as NSString).doubleValue
                    }else if (j[0] == "lat"){
                        lat = (j[1] as NSString).doubleValue
                    }else if (j[0] == "locationName"){
                        Dict[j[1]] = [lon, lat]
                    }
                }
            }
        }
        return Dict
    }
    //fetch weather data
    func fetchWeath(text: String, siSt: String){
//        var Dict: Dictionary<String, [Double]> = [:]
        var TEMP: Double = 0.0
        var HUMD: Double = 0.0
        let airAry = text.components(separatedBy: "]")
        for comp in airAry{
            let temprange = comp.range(of:"TEMP", options:.regularExpression)
            let lonarange = comp.range(of:siSt, options:.regularExpression)
            if (temprange != nil) && (lonarange != nil){
                var protext = comp.replacingOccurrences(of: "\"", with: "")
                protext = protext.replacingOccurrences(of: "}", with: "")
                protext = protext.replacingOccurrences(of: "{", with: "")
                protext = protext.replacingOccurrences(of: "[", with: "")
                let sigSiteAry = protext.components(separatedBy: ",")
                for i in Range(0...sigSiteAry.count-1){
                    let j = sigSiteAry[i].components(separatedBy: ":")
                    if(j[j.count-1] == "TEMP"){
                        let TEMPARY = sigSiteAry[i+1].components(separatedBy: ":")
                        TEMP = (TEMPARY[1] as NSString).doubleValue
                    }else if (j[j.count-1] == "HUMD"){
                        let HUMDARY = sigSiteAry[i+1].components(separatedBy: ":")
                        HUMD = (HUMDARY[1] as NSString).doubleValue
                        HUMD = HUMD*100
                    }
                }
            }
        }
        tempLabel.text = String(TEMP)
        humidLabel.text = String(HUMD)
        
    }
    //fetch air quality data
    func fetchAirData(text: String, siSt: String)-> Dictionary<String, String>{
        let range = text.range(of:siSt, options:.regularExpression)
        var Dict: Dictionary<String, String> = [:]
        if range != nil {
            let airAry = text.components(separatedBy: "{")
            for comp in airAry{
                let siterange = comp.range(of:siSt, options:.regularExpression)
                let daterange = comp.range(of:self.protext, options: .regularExpression)
                if (siterange != nil) && (daterange != nil) {
                    let sigSiteAry = comp.components(separatedBy: ",")
                    for i in Range(0...sigSiteAry.count-2){
                        var j = sigSiteAry[i].replacingOccurrences(of: "\"", with: "")
                        j = j.replacingOccurrences(of: "}", with: "")
                        j = j.replacingOccurrences(of: "}", with: "")
                        let component = j.components(separatedBy: ":")
                        Dict[component[0]] = component[1]
                        
                    }
                }
            }
        }
        return Dict
    }
    //fetch heart rate data
    func fetchHrData(text: String){
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
            if(spltAry[idx] == "mean"){
                let tra = lround(Double(spltAry[idx+1]) ?? 0)
                hrLabel.text = String(tra)
            }
        }
    }
    
    //fetch lifestyle data
    func fetchLifData(text: String) {
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
            if (spltAry[idx] == "calories") {
                let tra = lround(Double(spltAry[idx+7]) ?? 0)
                calLabel.text = String(tra)
            }else if (spltAry[idx] == "distance") {
                let tra = lround(Double(spltAry[idx+7]) ?? 0)
                disLabel.text = String(tra)
                distanceNum = Double(spltAry[idx+7]) ?? 0
            }else if (spltAry[idx] == "floors"){
                let tra = lround(Double(spltAry[idx+7]) ?? 0)
                frLabel.text = String(tra)
            }else if (spltAry[idx] == "steps"){
                let tra = lround(Double(spltAry[idx+7]) ?? 0)
                stpLabel.text = String(tra)
                stepNum = Double(spltAry[idx+7]) ?? 0
            }
        }
    }
    
    @IBOutlet weak var hrLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var disLabel: UILabel!
    @IBOutlet weak var frLabel: UILabel!
    @IBOutlet weak var stpLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var polluLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    override func viewDidLoad() {
        //GPS location request
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //calculate site
        let siteAry = getCSVData(doc: "site_opendata")
        siteDic = calSite(siteAry: siteAry)
        let weaSiteAry  = getCSVData(doc: "weather_site")
        weaSiteDic = calWeaSite(siteAry: weaSiteAry)
        
        //date format processing
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: date)
        protext = dateFormatString.replacingOccurrences(of: "年", with: "-")
        protext = protext.replacingOccurrences(of: "月", with: "-")
        protext = protext.replacingOccurrences(of: "日", with: "")
        dateLabel.text = dateFormatString
        
        //API processing & fetching
        threeAPI = "https://ntu-med-god.ml/api/getUserFitbitByRange?id="+self.userId+"&start="+self.protext+"&end="+self.protext
        hrAPI = "https://ntu-med-god.ml/api/getHeartRateMeanByRange?id="+self.userId+"&start="+self.protext+"&end="+self.protext
        getThree()
        getHeart()
        getAir()
        getWeather()
        fetchLifData(text: self.lifedata)
        fetchHrData(text: self.hrdata)
        countStepSize()
        
    }
    
    //pass the value
    func countStepSize(){
        let stepsize = lround(distanceNum*100000 / stepNum)
        print("life_counteSize,", stepsize)
        //send to ViewController.swift
        let notificationName = Notification.Name("sendStepsizetoWT")
        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":Double(stepsize)]) 
    }
}

extension lifestyleViewController: lifestyleViewControllerProtocol {
    func SendStepSize(size: Int) {
    }
}
