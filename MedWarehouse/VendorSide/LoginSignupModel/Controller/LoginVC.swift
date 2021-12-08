//
//  LoginVC.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
class LoginVC: UIViewController {
    //MARK:- IBOUTLET ACTION(S)
    //MARK:-
    @IBOutlet weak var imgVwLogo: UIImageView!
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSigninSubmit: UIButton!
    @IBOutlet weak var btneyeAction : UIButton!
    var iconClick = true
    //MARK:- VIEW LIFE CYCLE METHOD(S)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnSigninSubmit.layer.cornerRadius = 25
        if ApplicationPreference.shared.getUserData().id != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
}
//MARK:- BUTTON ACTION(S)
//MARK:-
@available(iOS 13.0, *)
extension LoginVC{
    @IBAction func btnclickForgetPassword(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnclickSignin(_ sender: Any) {
        if self.isValidate() {
            self.webserviceCallingToLogin()
            //           let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnclickSignup(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func iconAction(sender: UIButton) {
        if(iconClick == true) {
            sender.isSelected = true
            txtPassword.isSecureTextEntry = false
        } else {
            sender.isSelected = false
            txtPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
}

//MARK:- Validation In TextField
//MARK:-
extension LoginVC{
    func isValidate() -> Bool {
        guard self.txtEmail.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Email", controller: self)
            return false
        }
        guard objAppShareData.objValidation.isValidEmail(with: self.txtEmail.text!) else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the valid  Email", controller: self)
            return false
        }
        guard self.txtPassword.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Password", controller: self)
            return false
        }
        
        return true
    }
}
//MARK:- API Calling To Login
extension LoginVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["email"] = self.txtEmail.text
        dictparam["password"] = self.txtPassword.text
        print(dictparam)
        return dictparam
        
    }
    func webserviceCallingToLogin() {
        let params = getAllParam()
        objWebServiceManager.requestPost(strURL: login, params: params, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    let data = model.data
                    ApplicationPreference.shared.saveUserData(data:  data)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
//                    objAppShareData.showAlertVC(title: "Alert", message:model.message!, controller: self)
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
