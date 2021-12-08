//
//  Validation.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
let objValidation1 = ValidationClass()
class ValidationClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(with Email: String) -> Bool {
        let emailRegex = "^([a-zA-Z0-9_\\-\\.+-]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4})(\\]?)$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: Email)
    }
    
    
    
    func isNameString(nameStr:String)-> Bool{
        let nameRegEx = "^([A-Za-z](\\.)?+(\\s)?[A-Za-z|\\'|\\.]*){1,7}$"
        let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
        let result = nameTest.evaluate(with: nameStr)
        return result
    }
    
    func isvalidPhone(value: String) -> Bool {
        
        if value.count >= 7 {
            return true
        }else{
            return false
        }
        
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^([0-9]{3}(-)?[0-9]{3}(-)?[0-9]{2,4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func passwordShouldHave(strPwd:String) -> Bool{
        let PWD_REGEX1 = "^(?=.*[A-Z])(?=.*[!@#$.,%^&*])(?=.*[0-9])(?=.*[a-z]).{8,100}$"
        let pwdTest = NSPredicate(format: "SELF MATCHES %@", PWD_REGEX1)
        let result =  pwdTest.evaluate(with: strPwd)
        return result
    }
    
    func isPwdLenth(password: String) -> Bool {
        if password.count < 6 {
            return true
        }else{
            return false
        }
    }
    
    func isConfPwdLenth(confirmPassword : String) -> Bool {
        if confirmPassword.count >= 6{
            return true
        }else{
            return false
        }
    }
    func isPwd(value: String) -> Bool {
        if value.count > 6{
            return true
        }
        else{
            return false
        }
    }
    
    
    func isName(strFullname: String) -> Bool {
        if strFullname.count <= 1
        {
          return false
        }
        else
        {
            let nameRegEx = "^([A-Za-z](\\.)?+(\\s)?[A-Za-z|\\'|\\.]*){1,7}$"
            let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
            let result = nameTest.evaluate(with: strFullname)
            return result
            
        }
    }
    

    
}

