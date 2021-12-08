//
//  AppSharePrefence.swift
//  MedWarehouse
//
//  Created by Apple on 14/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
class ApplicationPreference {
    
    static let shared = ApplicationPreference()
    lazy var userDefault = UserDefaults.standard
    
    let kfirst_name = "__FIRST_NAME__"
    let Klast_name = "__LAST_NAME__"
    let kId      = "__ID__"
    let kType   = "__type__"
    class func clearAllData(){
//        userDefault.removeObject(forKey: kVerificationCode)
//        userDefault.synchronize()
    }
    
    func saveUserData(data: LoginleModel?) {
        userDefault.setValue(data?.id, forKey: kId)
        userDefault.setValue(data?.first_name, forKey: kfirst_name)
        userDefault.setValue(data?.last_name, forKey: Klast_name)
        userDefault.setValue(data?.type, forKey: kType)
        userDefault.synchronize()
    }
    
    func getUserData() -> LoginleModel {
        let profileModel = LoginleModel()
        profileModel.id = userDefault.value(forKey: kId) as? String
        profileModel.first_name = userDefault.value(forKey: kfirst_name) as? String
        profileModel.last_name = userDefault.value(forKey: Klast_name) as? String
        profileModel.type = userDefault.value(forKey: kType) as? String
        return profileModel
    }
    
    func clearAllData() {
        userDefault.removeObject(forKey: kType)
        userDefault.removeObject(forKey: kId)
        userDefault.removeObject(forKey: kfirst_name)
        userDefault.removeObject(forKey: Klast_name)
        userDefault.synchronize()
    }
}
