//
//  ForgetPasswordVC.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnConfirmEmail: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnConfirmEmail.layer.cornerRadius = 25
        
    }

    @IBAction func btnclickConfirmEmail(_ sender: Any) {
        if self.isValidate() {
            self.webserviceCallingToForgottPassword()
        }
    }
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Validation In TextField
//MARK:-
extension ForgetPasswordVC{
    func isValidate() -> Bool {
        guard self.txtEmail.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Email", controller: self)
            return false
        }
        guard objAppShareData.objValidation.isValidEmail(with: self.txtEmail.text!) else {
                   objAppShareData.showAlertVC(title: "Alert", message: "Please enter the valid  Email", controller: self)
                   return false
               }
        
        return true
    }
}

//MARK:- API Calling To Login
extension ForgetPasswordVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["email"] = self.txtEmail.text
        return dictparam
        
    }
    func webserviceCallingToForgottPassword() {
        let params = getAllParam()
        objWebServiceManager.requestPost(strURL: forgot_password, params: params, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
