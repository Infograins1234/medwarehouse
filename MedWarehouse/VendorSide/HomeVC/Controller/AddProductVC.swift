//
//  AddProductVC.swift
//  MedWarehouse
//
//  Created by Apple on 26/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper


class AddProductVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtExpiryMonths: UITextField!
    @IBOutlet weak var txtAvailability: UITextField!
    @IBOutlet weak var txtOnFloor: UITextField!
    @IBOutlet weak var btnAddSubmit: UIButton!
    @IBOutlet weak var uiVwName: UIView!
    @IBOutlet weak var uiVwExpiryMonths: UIView!
    @IBOutlet weak var uiVwAvability: UIView!
    @IBOutlet weak var uiVwOnFloor: UIView!
    let avability = ["Y","N"]
    let onfloor = ["Y","N"]
    
    var avabilityPickerview = UIPickerView()
    var onfloorPickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupDatePicker()
        txtAvailability.inputView = avabilityPickerview
        txtOnFloor.inputView = onfloorPickerView
        
        txtAvailability.textAlignment = .natural
        txtOnFloor.textAlignment = .natural
        
        avabilityPickerview.delegate = self
        avabilityPickerview.dataSource = self
        
        onfloorPickerView.delegate = self
        onfloorPickerView.dataSource = self
        
        avabilityPickerview.tag = 1
        onfloorPickerView.tag = 2
        
        btnAddSubmit.layer.cornerRadius = 30
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
        
        
        uiVwOnFloor.layer.cornerRadius = 30
        uiVwOnFloor.layer.masksToBounds = true;
        uiVwOnFloor.layer.borderColor = #colorLiteral(red: 0, green: 0.7631549239, blue: 0.8282828331, alpha: 1)
        uiVwOnFloor.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnclickAdd(_ sender: Any) {
        if self.isValidation() {
            self.webServiseCallingToAddProduct()
            
        }
        
    }
    @IBAction func btnsideMenuAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let vcc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let sidemenu
            = SideMenuNavigationController(rootViewController: vcc)
        sidemenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        present(sidemenu,animated: true)
    }
}
//MARK:- Api Calling To Register
extension AddProductVC {
    func getAllParam() -> [String:Any] {
        var dicparam = [String:Any]()
        dicparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dicparam["name"] = self.txtName.text ?? ""
        dicparam["expiry_months"] = self.txtExpiryMonths.text ?? ""
        dicparam["availability"] = self.txtAvailability.text ?? ""
        dicparam["on_floor"] = self.txtOnFloor.text ?? ""
        dicparam["slug"] = "abc"
        dicparam["quantity"] = "9"
        dicparam["description"] = "jhbjbjkh"
        print(dicparam)
        return dicparam
    }
    func webServiseCallingToAddProduct() {
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: Add_product, params:param , showIndicator: true, success: { (response) in
            
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //                      objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    //                      objAppShareData.showAlertVC(title: "Alert", message:model.message!, controller: self)
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
extension AddProductVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return avability.count
        case 2:
            return onfloor.count
            
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return avability[row]
        case 2:
            return onfloor[row]
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtAvailability.text = avability[row]
            txtAvailability.resignFirstResponder()
        case 2:
            txtOnFloor.text = onfloor[row]
            txtOnFloor.resignFirstResponder()
        default:
            return
        }
    }
    
}
//MARK:- Opening in Datepicker
extension AddProductVC{
    func openDatePicker()  {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        txtExpiryMonths.inputAccessoryView = toolbar
    }
    
    
    @objc func cancelBtnClick(){
        txtExpiryMonths.resignFirstResponder()
    }
    
    @objc func doneBtnClick(){
        if let datePicker = txtExpiryMonths.inputView as? UIDatePicker{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd/MM/YYYY"
            txtExpiryMonths.text = dateFormatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        txtExpiryMonths.resignFirstResponder()
        
    }
    @objc func datePickerHandler(datePicker:UIDatePicker) {
        print(datePicker.date )
        let dateFormatter = DateFormatter()
        if datePicker.tag == 0 {
            dateFormatter.dateFormat = "dd/MM/YYYY"
            txtExpiryMonths.text = dateFormatter.string(from: datePicker.date)
        }else if datePicker.tag == 1 {
            
            
        }
    }
}
//MARK:- OPEN DATEPICKER(S)
extension AddProductVC{
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker.tag = 0
        //        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.txtExpiryMonths.inputView = datePicker
    }
}

//MARK:- Validation Method(s)
//MARK:-
extension AddProductVC{
    func isValidation() -> Bool {
        guard self.txtName.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Product Name", controller: self)
            return false
        }
        guard self.txtExpiryMonths.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Expiry Date ", controller: self)
            return false
        }
        guard self.txtAvailability.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Avability", controller: self)
            return false
        }
        
        guard self.txtOnFloor.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the OnFloor", controller: self)
            return false
        }
        return true
    }
    
}
