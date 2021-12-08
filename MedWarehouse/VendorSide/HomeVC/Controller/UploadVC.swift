//
//  UploadVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class UploadVC: UIViewController {
    @IBOutlet weak var uiVwName: UIView!
    @IBOutlet weak var uiVwExpiryMonths: UIView!
    @IBOutlet weak var uiVwAvability: UIView!
    @IBOutlet weak var btnUploadSubmit: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtExpiryMonths: UITextField!
    @IBOutlet weak var txtAvailability: UITextField!
    //MARK:- Var(s)
    //MARK:-
    let avability = ["Y","N"]
    var data: RideHistory?
    var avabilityPickerview = UIPickerView()
    //MARK:- View life cycle method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtName.text = self.data?.name
        self.txtExpiryMonths.text = self.data?.expiry_months
        self.txtAvailability.text = self.data?.availability
        txtAvailability.inputView = avabilityPickerview
        txtAvailability.textAlignment = .natural
        avabilityPickerview.delegate = self
        avabilityPickerview.dataSource = self
        avabilityPickerview.tag = 1
        btnUploadSubmit.layer.cornerRadius = 30
        uiVwName.layer.cornerRadius = 30
        uiVwName.layer.masksToBounds = true;
        uiVwName.layer.borderColor = #colorLiteral(red: 0, green: 0.7631549239, blue: 0.8282828331, alpha: 1)
        uiVwName.layer.borderWidth = 1
        
        uiVwExpiryMonths.layer.cornerRadius = 30
        uiVwExpiryMonths.layer.masksToBounds = true;
        uiVwExpiryMonths.layer.borderColor = #colorLiteral(red: 0, green: 0.7631549239, blue: 0.8282828331, alpha: 1)
        uiVwExpiryMonths.layer.borderWidth = 1
        
        uiVwAvability.layer.cornerRadius = 30
        uiVwAvability.layer.masksToBounds = true;
        uiVwAvability.layer.borderColor = #colorLiteral(red: 0, green: 0.7631549239, blue: 0.8282828331, alpha: 1)
        uiVwAvability.layer.borderWidth = 1

    }
    @IBAction func btnsideMenuAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdateSubmitAction(_ sender: Any) {
        if self.isValidation() {
            self.weServiceCallingToUpdateList()
        }
        
    }
}
//MARK:- Api Calling To Register
extension UploadVC {
    func getAllParam() -> [String:Any] {
        var dicparam = [String:Any]()
        dicparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dicparam["product_id"] = self.data?.id
        dicparam["name"] = self.txtName.text ?? ""
        dicparam["expiry_months"] = self.txtExpiryMonths.text ?? ""
        dicparam["availability"] = self.txtAvailability.text ?? ""
        dicparam["on_floor"] = ""
        
        print(dicparam)
        return dicparam
    }
    func weServiceCallingToUpdateList() {
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: Update_product, params:param , showIndicator: true, success: { (response) in
            
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //                      objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
            //
        }) { (error) in
            //
        }
    }
}
//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension UploadVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return avability.count
            
            
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return avability[row]
            
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtAvailability.text = avability[row]
            txtAvailability.resignFirstResponder()
            
        default:
            return
        }
    }
    
}


//MARK:- Validation Method(s)
//MARK:-
extension UploadVC{
    func isValidation() -> Bool {
        guard self.txtName.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Product Name", controller: self)
            return false
        }
        guard self.txtExpiryMonths.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Expiry Month", controller: self)
            return false
        }
        guard self.txtAvailability.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Avability", controller: self)
            return false
        }
        
        
        return true
    }
    
}

