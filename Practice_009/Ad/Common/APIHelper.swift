import Foundation
import UIKit
import RxSwift
import ObjectMapper

class APIHelper: NSObject{
    static let shared = APIHelper()
    
    func getJson(forResource: String) -> Single<[String:Any]> {
        
        let testBundle = Bundle.main

        let path = testBundle.path(forResource: forResource, ofType: "json")
        
        let json:NSString
        do{
            json = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            let jsonObj: [String:Any] = convertToDictionary(text: json as String)!
            return Single.just(jsonObj)
        }catch{
            print("No save file")
        }
        
        //should not get in here
        return Single.error(NSError(domain: "getJson", code: 0, userInfo: [:]))
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
