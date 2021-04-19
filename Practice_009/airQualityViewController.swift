//
//  airQualityViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/27.
//

import UIKit
import CoreLocation
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
//import CodableCSV

class airQualityViewController: UIViewController, CLLocationManagerDelegate{
//    //site info
//    let siteInfos = SiteInfo.data
//    //GPS location request
//    let locationManager = CLLocationManager()
//    var pm25Set:String = ""
//    override func viewDidLoad(){
//        locationManager.delegate = self
//        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        dump(siteInfos)
//        print(siteInfos)
//        pm25API()
//
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[locations.count - 1]
//        print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
//    }
//    //GPS location error raise
//    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error){
//        print("error to collect location")
//        print(error)
//    }
//
//
//    //fetch environment data
//    func pm25API(){
//        let semaphore = DispatchSemaphore (value: 0)
//        var request = URLRequest(url: URL(string: "https://opendata.epa.gov.tw/api/v1/PM25?%24skip=0&%24top=1000&%24format=json")!,timeoutInterval: Double.infinity)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                semaphore.signal()
//                return
//            }
//            pm25Set = String(data: data, encoding: .utf8)!
////            print(pm25Set)
//            semaphore.signal()
//        }
//        task.resume()
//        semaphore.wait()
//    }
//}
//
//struct SiteInfo: Codable {
//    let City: String
//    let District: String
//    let Sitename: String
//    let Longitude: Float
//    let Latitude: Float
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        City = try container.decode(String.self, forKey: .City)
//        District = try container.decode(String.self, forKey: .District)
//        Sitename = try container.decode(String.self, forKey: .Sitename)
//        Longitude = try container.decode(Float.self, forKey: .Longitude)
//        Latitude = try container.decode(Float.self, forKey: .Latitude)
//    }
}

//extension SiteInfo {
//    static var data: [Self] {
//        var array = [Self]()
//        if let data = NSDataAsset(name: "site_opendata")?.data {
//            let decoder = CSVDecoder {
//                $0.headerStrategy = .firstLine
//            }
//            do {
//                array = try decoder.decode([Self].self, from: data)
//            } catch {
//                print(error)
//            }
//        }
//        return array
//    }
//}

