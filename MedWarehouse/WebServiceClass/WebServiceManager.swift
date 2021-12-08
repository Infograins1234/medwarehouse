//
//  WebServiceManager.swift
//  MedWarehouse
//
//  Created by Apple on 12/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Alamofire
import KRProgressHUD
import SVProgressHUD
var AuthToken : String = ""

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

let objWebServiceManager = WebServiceManager.sharedObject()

class WebServiceManager: NSObject {
    
    //MARK: - Shared object
    fileprivate var window = UIApplication.shared.keyWindow
    
    private static var sharedNetworkManager: WebServiceManager = {
        let networkManager = WebServiceManager()
        return networkManager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> WebServiceManager {
        return sharedNetworkManager
    }
    
    private let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        print(configuration.timeoutIntervalForRequest)
        configuration.timeoutIntervalForRequest = 300
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    public func requestPostWithTokenInHeader(strURL:String, params : [String:Any], showIndicator:Bool, success:@escaping(String) ->Void, failure:@escaping (Error) ->Void) {
        if !NetworkReachabilityManager()!.isReachable{
            self.showNetworkAlert()
            return
        }
        AuthToken = ""
        let url = BaseURL + strURL
        let headers = ["x-api-key" : "13!4#8%4&5(@R400t%33","token":AuthToken]
        print(url)
        print("ServiceURL = \(url)")
        print(url)
        print("Params = \(params)")
        print("AuthToken = \(AuthToken)")
        Global.displayLoader(showIndicator, show: true)
        manager.retrier = OAuth2Handler()
        manager.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            DispatchQueue.main.async {
                Global.displayLoader(showIndicator, show: false)
                if responseObject.result.isSuccess {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        // Session Expire
                        let dict = dictionary as! Dictionary<String, Any>
                        if dict["status"] as? String ?? "" == "success"{
                            if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                                self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                            }
                        }
                        print("Response = \(dictionary)")
                        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                        let decoded = String(data: jsonData, encoding: .utf8)!
                        /////
                        success(decoded)
                    }catch (let error){
                        print("Error in json serialization = \(error.localizedDescription)")
                    }
                }
                else if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    //                    print("Error = \(error)")
                    //                    failure(error)
                    print("Error in json serialization = \(error.localizedDescription)")
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP error : \(str)")
                }
            }
            
            
        }
    }
    
    
    public func requestPost(strURL:String, params : [String:Any], showIndicator:Bool, success:@escaping(NSDictionary) ->Void, failure:@escaping (Error) ->Void) {
        if !NetworkReachabilityManager()!.isReachable{
            self.showNetworkAlert()
            return
        }
        AuthToken = ""
        //        if SharedPreference.getUserData().token != nil{
        //            AuthToken = SharedPreference.getUserData().token!
        //        }
        let url = BaseURL + strURL
        let headers = ["token":AuthToken]
        print(url)
        print("ServiceURL = \(url)")
        print(url)
        print("Params = \(params)")
        print("AuthToken = \(AuthToken)")
        Global.displayLoader(showIndicator, show: true)
        manager.retrier = OAuth2Handler()
        Global.displayLoader(showIndicator, show: true)
        
        manager.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            DispatchQueue.main.async {
                Global.displayLoader(showIndicator, show: false)
                if responseObject.result.isSuccess {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        // Session Expire
                        let dict = dictionary as! Dictionary<String, Any>
                        if dict["status"] as? String ?? "" == "success"{
                            if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                                self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                            }
                        }
                        print("Response = \(dictionary)")
                        // let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                        //  let decoded = String(data: jsonData, encoding: .utf8)!
                        /////
                        success(dictionary)
                    }catch (let error){
                        print("Error in json serialization = \(error.localizedDescription)")
                    }
                }
                else if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    //                    print("Error = \(error)")
                    //                    failure(error)
                    print("Error in json serialization = \(error.localizedDescription)")
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP error : \(str)")
                }
            }
        }
    }
    
    
    
    public func requestPostWithoutProgress(strURL:String, params : [String:Any], showIndicator:Bool, success:@escaping(String) ->Void, failure:@escaping (Error) ->Void) {
        if !NetworkReachabilityManager()!.isReachable{
            self.showNetworkAlert()
            return
        }
        AuthToken = ""
        //               if SharedPreference.getUserData().token != nil{
        //                   AuthToken = SharedPreference.getUserData().token!
        //               }
        let url = BaseURL + strURL
        let headers = ["token":AuthToken]
        print(url)
        print("ServiceURL = \(url)")
        print(url)
        print("Params = \(params)")
        print("AuthToken = \(AuthToken)")
        manager.retrier = OAuth2Handler()
        //  GlobalObj.displayLoader(showIndicator, show: true)
        manager.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            DispatchQueue.main.async {
                //  GlobalObj.displayLoader(showIndicator, show: false)
                if responseObject.result.isSuccess {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        // Session Expire
                        let dict = dictionary as! Dictionary<String, Any>
                        if dict["status"] as? String ?? "" == "success"{
                            if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                                self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                            }
                        }
                        print("Response = \(dictionary)")
                        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                        let decoded = String(data: jsonData, encoding: .utf8)!
                        /////
                        success(decoded)
                    }catch (let error){
                        print("Error in json serialization = \(error.localizedDescription)")
                    }
                }
                else if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print("Error in json serialization = \(error.localizedDescription)")
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP error : \(str)")
                }
            }
            
            
        }
    }
    
    
    public func requestGet(strURL:String, params : [String : AnyObject]?, showIndicator:Bool , success:@escaping(NSDictionary) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            self.showNetworkAlert()
            return
        }
        AuthToken = ""
        //       if SharedPreference.getUserData().token != nil{
        //           AuthToken = SharedPreference.getUserData().token!
        //       }
        let headers: HTTPHeaders = [
            "token" : AuthToken
        ]
        let strURL = (BaseURL + strURL)
        let urlString = strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("url....\(strURL)")
        print("header....\(headers)")
        Global.displayLoader(showIndicator, show: true)
        Alamofire.request(urlString, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            Global.displayLoader(showIndicator, show: false)
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    // Session Expire
                    let dict = dictionary as! Dictionary<String, Any>
                    if dict["status"] as? String ?? "" == "success"{
                        if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                            self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                        }
                    }
                    print("Response = \(dictionary)")
                    //                    let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                    //                    let decoded = String(data: jsonData, encoding: .utf8)!
                    success(dictionary)
                }catch{
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                //self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                let str = String(decoding: responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    
    public func requestPostMultipartData(strURL:String, params : [String:Any],showIndicator:Bool, success:@escaping(String) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            self.showNetworkAlert()
            return
        }
        AuthToken = ""
        //        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.token){
        //            AuthToken = token
        //        }
        let strURL = BaseURL+strURL
        let url = strURL.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let headers = ["authToken" : AuthToken,
                       "Content-Type":"multipart/form-data",
                       "x-api-key" : "13!4#8%4&5(@R400t%33"]
        print("header is \(headers)")
        Global.displayLoader(showIndicator, show: true)
        manager.retrier = OAuth2Handler()
        manager.upload(multipartFormData:{ multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }},
                       usingThreshold:UInt64.init(),
                       to:url,
                       method:.post,
                       headers:headers,
                       encodingCompletion: { encodingResult in
                        Global.displayLoader(showIndicator, show: false)
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { responseObject in
                                if responseObject.result.isSuccess {
                                    do {
                                        let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        // Session Expire
                                        let dict = dictionary as! Dictionary<String, Any>
                                        if dict["status"] as? String ?? "" == "success"{
                                            if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                                                self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                                            }
                                        }
                                        print("Response = \(dictionary)")
                                        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                                        let decoded = String(data: jsonData, encoding: .utf8)!
                                        success(decoded)
                                    }catch{
                                        let error : Error = responseObject.result.error!
                                        failure(error)
                                        let str = String(decoding: responseObject.data!, as: UTF8.self)
                                        print("PHP ERROR : \(str)")
                                    }
                                }
                                if responseObject.result.isFailure {
                                    let error : Error = responseObject.result.error!
                                    failure(error)
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            failure(encodingError)
                        }
        })
    }
    
    
    
    func callingAPIWithCustomHeader(username:String,password: String,url: String)  {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }
    
    //MARK: - Convert String to Dict
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
    
    func isNetworkAvailable() -> Bool{
        if !NetworkReachabilityManager()!.isReachable{
            return false
        }else{
            return true
        }
    }
    
    func showNetworkAlert(){
        let alert = UIAlertController(title: "No network", message: "Please check your internet connection.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        //alert.show()
    }
    
    func showAlertWithTitle(_title: String, _message: String){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        // alert.show()
    }
}

//MARK :- retrier

class OAuth2Handler : RequestRetrier {
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if error.localizedDescription.count > 0 && request.retryCount < 5{
            if error.localizedDescription == "The request timed out."{
                completion(false, 0.0) // don't retry
            }else{
                print("Retrying..\(String(describing: request.request?.url!)))")
                completion(true, 5.0)  // retry after 5 second
            }
        }else{
            completion(false, 0.0) // don't retry
        }
    }
}

extension WebServiceManager{
    public func uploadImage(strUrl:String,para:[String:Any],image:[ImageInfo], showIndicator:Bool,succes:@escaping(NSDictionary)->Void,Failler:@escaping(_ error:Error)->Void) {
        let completeURl = BaseURL+strUrl
        AuthToken = ""
//        if SharedPreference.getUserData().token != nil{
//            AuthToken = SharedPreference.getUserData().token!
//        }
//        let headers: HTTPHeaders = [
//            "token" : AuthToken
//        ]
        let headers = ["token":AuthToken]
        Global.displayLoader(showIndicator, show: true)
        print("header is \(headers)")
        print("url is \(completeURl)")
        
        Alamofire.upload(multipartFormData: { (multiPartFormData) in
            for imgData in image {
                if let imagedata = imgData.data {
                    let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
                    let someInt:Int = Int(randomNum)
                    
                    var strImageName = imgData.imageName
                    if strImageName == nil {
                        strImageName = "\(someInt)"+".png"
                    }
                    multiPartFormData.append(imagedata, withName: imgData.name,fileName: strImageName ?? "", mimeType: "image/png")
//                    multiPartFormData.append(imagedata, withName: imgData.name,fileName: imgData.name, mimeType: "image/png")
                }else {
                    
                }
            }
            // import parameters
            for (key, value) in para {
                let stringValue = value as! String
                multiPartFormData.append(stringValue.data(using: .utf8)!, withName: key)
            }
        }, to: completeURl) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    Global.displayLoader(showIndicator, show: false)
                    switch response.result {
                    case .success:
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with:response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            
                            let dict = dictionary as! Dictionary<String, Any>
                            if dict["status"] as? String ?? "" == "success"{
                                if let msg = dict["message"] as? String, msg == "Invalid Auth Token"{
                                    self.showAlertWithTitle(_title: "Alert", _message: "Session expires")
                                }
                            }
                            print("Response = \(dictionary)")
                            // let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                            //  let decoded = String(data: jsonData, encoding: .utf8)!
                            /////
                            succes(dictionary)
                        }catch{
                            let error : Error = response.result.error!
                            let str = String(decoding: response.data!, as: UTF8.self)
                            print("PHP ERROR : \(str)")
                            Failler(error)
                        }
                    case .failure(let error):
                        let responseString:String = String(data: response.data!, encoding: String.Encoding.utf8)!
                        print(responseString)
                        Failler(error)
                        //error(error as NSError)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
//    func uploadAttachment(strUrl: String, paramName: String, params: [String: Any], fileName: String, fileData: Data, mimeType: String, completionHandler: @escaping((_ status: Bool, _ msg: String) -> ())) {
//        Spinner.show("")
//        
//        let url = URL(string: strUrl)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        
//        
//        AF.upload(multipartFormData: { multiPart in
//            for (key, value) in params {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? Int {
//                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? NSArray {
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let string = element as? String {
//                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//                }
//            }
//            multiPart.append(fileData, withName: "file", fileName: fileName, mimeType: mimeType)
//        }, with: request)
//        .uploadProgress(closure: { (progress) in
//            print("Upload Progress: \(progress.fractionCompleted)")
//            let progressPercentage = progress.fractionCompleted * 100
//            print("\(progressPercentage)")
//            //                Spinner.show(progressPercentage.debugDescription)
//            if(progress.fractionCompleted == 1.0){
//                completionHandler(true,"")
//            }
//        })
//        .responseJSON(completionHandler: { result in
//            //Do what ever you want to do with response
//            print("Status code:- ", result.response?.statusCode ?? "")
//            if result.error == nil {
//                if (result.response?.statusCode ?? 0) >= 200 && (result.response?.statusCode ?? 0) <= 250 {
//                    completionHandler(true,"")
//                }else {
//                    Spinner.hide()
//                    //Error
//                    completionHandler(false, "Error_on_upload".localized())
//                }
//            }else {
//                Spinner.hide()
//                completionHandler(false, result.error?.localizedDescription ?? "Error_on_upload".localized())
//            }
//        })
//    }

    
}

struct ImageInfo {
    var data: Data!
    var name: String!
    var imageName: String?
    init(data: Data!, name: String!, _ imageName: String? = nil ) {
        self.data = data
        self.name = name
        self.imageName = imageName
    }
}
