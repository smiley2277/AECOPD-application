
import RxSwift
import Alamofire
import Reachability
import CoreLocation
import RxCocoa

class APIManager: NSObject {
    static let shared = APIManager()
    let reachability = try! Reachability()

    var isReachable = Variable(true)
   // var ref: DatabaseReference! = Database.database().reference()
    
    private var context = 0
    
    lazy var requestManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: config)
    }()
    
    override init() {
        super.init()
        
        let reachabilityManager = NetworkReachabilityManager.init(host:"www.apple.com")
        let isInternetReachable = (reachabilityManager?.isReachable) ?? false
        
        self.isReachable.value = isInternetReachable
        reachability!.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.isReachable.value = false
            }
        }
        
        reachability!.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.isReachable.value = true
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            #if DEBUG
            print("Error")
            #endif
        }
    }
    
    
    fileprivate func manager(method: HTTPMethod, appendUrl: String, url: APIUrl, parameters: [String: Any]?, appendHeaders: [String: String]?, userId: String? = nil) -> Single<[String:Any]> {
        
        return Single.create { (single) -> Disposable in
            
            let param = (parameters) ?? [String:Any]()
            let headers: HTTPHeaders = self.getHttpHeadersWith(method: method, appendHeaders: appendHeaders)
            let requestUrl: String = self.getRequestUrlWith(url: url, appendUrl: appendUrl, userId: userId)
            let encode: ParameterEncoding = self.getEncodeWith(method: method)
            
            self.printRequest(requestUrl, headers, param, method)
            
            if (self.isReachable.value == false) {
                let err = APIError.init(type: .noInternetException, localDesc: "The Internet connection appears to be offline.", alertMsg: "")
                single(.error(err))
                return Disposables.create()
            }
            
            self.requestManager
                .request(requestUrl, method: method, parameters: param, encoding: encode, headers: headers)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        if (value is [String:Any]) {
                            self.printResponse(requestUrl, value, method)
                            
                            single(.success(value as! [String:Any]))
                        } else {
                            let err = APIError.init(type: .otherException, localDesc: "It's success.But AlertMsg doesn't exist.", alertMsg: "")
                            self.printErrorResponse(requestUrl, response, err, alertMsg: "", method)
                            single(.error(err))
                        }
 
                    case .failure(let error):
                        
                        var json: [String : String] = [:]
                        
                        if let data = response.data {
                            do{
                                json = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: String] ?? [:])
                            }catch{
                                json["Message"] = ""
                            }
                        }
                        
                        let alertMsg = json["Message"] ?? ""
                        
                        self.printErrorResponse(requestUrl, response, error, alertMsg: alertMsg, method)
                        
                        let localDesc = (error as NSError).localizedDescription
                        let errorCode = (error as NSError).code
                        let statusCode = response.response?.statusCode ?? nil
                        let err: APIError = APIError(statusCode: statusCode, errorCode: errorCode, localDesc: localDesc, alertMsg: alertMsg)
                        single(.error(err))
                    }
                })
            return Disposables.create()
        }
    }
    
    
    private func getRequestUrlWith(url: APIUrl, appendUrl: String, userId: String? = nil) -> String {
        let encodeUrl = appendUrl
        var requestUrl = ""
        
        switch url {
        case .userApi(let type):
            requestUrl = type.url(append: "",userId: userId)
        case .authApi(let type):
            requestUrl = type.url(append: "",userId: userId)
        case .tokenApi(type: let type):
            requestUrl = type.url(append: "",userId: userId)
        case .testApi(let type):
            requestUrl = type.url(append: "",userId: userId)
        }

        requestUrl =  (requestUrl + encodeUrl ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return requestUrl
    }
    

    
    private func getEncodeWith(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
          
        case .post:
            return JSONEncoding.default
            
        case .put:
            return JSONEncoding.default
            
        default:
            return URLEncoding.default
        }
    }
    
    private func getHttpHeadersWith(method: HTTPMethod, appendHeaders: [String: String]?) -> HTTPHeaders{

        var headers: HTTPHeaders = [
           "X-API-KEY": "MyToken"
        ]

        if let authorization = UserDefaultUtil.shared.adminAuthorization {
            headers["Authorization"] = "\(authorization)"
        }

        appendHeaders?.forEach({ header in
            headers[ header.key ] =  header.value
        })

        return headers
    }
}

extension APIManager {
    
    //TODO 接到一半
    func getLoginResult(email: String, password: String) -> Single<[String:Any]> {
        let appendUrl = ""
        let params = ["email": email,
                      "password": password]
        return manager(method: .post, appendUrl: appendUrl, url: APIUrl.authApi(type: .normal) , parameters: params, appendHeaders: nil)
    }
    
    func getLoginResultWithRefreshToken() -> Single<[String:Any]> {
        //MARK: 應確
        let params = ["grant_type": "refresh_token",
                      "refresh_token": "Bearer \(UserDefaultUtil.shared.adminRefreshToken ?? "")"]
        return manager(method: .post, appendUrl: "", url: APIUrl.tokenApi(type: .normal) , parameters: params, appendHeaders: nil)
    }
    
    //TODO 接上Patient List API
    func getPatientList() -> Single<[String:Any]> {
        let appendUrl = ""
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.userApi(type: .coach) ,parameters: nil, appendHeaders: nil)
    }
    
    func getPatientCoach(userId: String, timestamp: String) -> Single<[String:Any]> {
        let appendUrl = "?timestamp=\(timestamp)"
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.userApi(type: .coach) ,parameters: nil, appendHeaders: nil, userId: userId)
    }
    
    func postPatientCoach(userId: String, timestamp: String, speed: String, time: String) -> Single<[String:Any]> {
        let params = ["timestamp": timestamp,
                      "speed": speed,
                      "time": time]
        return manager(method: .post, appendUrl: "", url: APIUrl.userApi(type: .coach) ,parameters: params, appendHeaders: nil, userId: userId)
    }
    
    func getPatientSurvey(userId: String, timestamp: String) -> Single<[String:Any]> {
        let appendUrl = "?timestamp=\(timestamp)"
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.userApi(type: .survey) ,parameters: nil, appendHeaders: nil, userId: userId)
    }
    
    func getPatientBorg(userId: String, timestamp: String) -> Single<[String:Any]> {
        let appendUrl = "?timestamp=\(timestamp)"
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.userApi(type: .borg) ,parameters: nil, appendHeaders: nil, userId: userId)
    }
    
    func getSignUpResult(lastname: String, firstname: String, age: Int, email: String, birthday: String, gender: String, height: Int, weight: Int, phone: String, identity: String, password: String) -> Single<[String:Any]> {
        let appendUrl = ""
        let params = ["lastname": lastname, "firstname": firstname,
                      "age": age, "email": email, "birthday": birthday,
                      "gender": gender, "height": height,
                      "weight": height, "phone": phone,
                      "identity": identity, "password": password] as [String : Any]
        return manager(method: .put, appendUrl: appendUrl, url: APIUrl.authApi(type: .normal) , parameters: params, appendHeaders: nil)
    }
    
    func postBorg(userId: String, postbeat: Int, postborg: Int, prebeat: Int, preborg: Int, step: Int, timestamp: String)-> Single<[String:Any]>{
        let appendUrl = "?timestamp=\(timestamp)"
        let params = ["timestamp": timestamp,
                      "postbeat": postbeat,
                      "postborg": postborg,
                      "prebeat": prebeat,
                      "preborg": preborg,
                      "step": step] as [String : Any]
        return manager(method: .post, appendUrl: appendUrl, url: APIUrl.userApi(type: .borg) , parameters: params, appendHeaders: nil, userId: userId)
    }
    
    func postQues(userId: String, cat1: Int, cat2: Int, cat3: Int, cat4: Int, cat5: Int, cat6: Int, cat7: Int, cat8: Int, catsum: Int, eq1: Int, eq2: Int, eq3: Int, eq4: Int, eq5: Int, mmrc: Int, timestamp: String)-> Single<[String:Any]>{
        let params = ["timestamp": timestamp,
                      "cat1": cat1, "cat2": cat2,
                      "cat3": cat3, "cat4": cat4,
                      "cat5": cat5, "cat6": cat6,
                      "cat7": cat7, "cat8": cat8,
                      "catsum": catsum, "eq1": eq1,
                      "eq2": eq2, "eq3": eq3,
                      "eq4": eq4, "eq5": eq5, "mmrc": mmrc ] as [String : Any]
        return manager(method: .post, appendUrl: "", url: APIUrl.userApi(type: .survey) , parameters: params, appendHeaders: nil, userId: userId)
    }
}

extension APIManager {
    
    private func printRequest(_ requestUrl: String, _ headers: HTTPHeaders, _ params: [String: Any], _ method: HTTPMethod) {
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【呼叫】 The_requestUrl : \(requestUrl)")
        print("* 【呼叫】 Method : \(method)")
        print("* 【呼叫】 Request_headers : ")
        headers.forEach({ header in
            print("   \(header)")
        })

        print("* 【呼叫】 Request_params : ")
        print(params)
        print(getPrettyParams(params) ?? "")
        #endif
    }
    
    private func printResponse(_ requestUrl: String,_ value: (Any), _ method: HTTPMethod){
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【回應】 The_requestUrl : \(requestUrl)")
        print("* 【回應】 Method : \(method)")
        print("* 【回應】 Response_value : ")
        print(getPrettyPrint(value))
        #endif
    }
    
    private func printErrorResponse(_ requestUrl:String, _ response: (DataResponse<Any>), _ error: (Error), alertMsg: String, _ method: HTTPMethod) {
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【回應錯誤】 The_requestUrl : \(requestUrl)")
        print("* 【回應錯誤】 Method : \(method)")
        print("* StatusCode : \(String(describing: response.response?.statusCode))")
        print("* View_OnError : \(String(describing:error))")
        print("* Error.code : \((error as NSError).code)")
        print("* AlertMsg : \(alertMsg)")
        #endif
    }
    
    private func getPrettyPrint(_ responseValue: Any) -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
    
    private func getPrettyParams(_ dict: [String: Any]) -> NSString? {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    }
}
