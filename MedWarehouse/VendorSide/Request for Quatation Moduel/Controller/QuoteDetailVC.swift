//
//  QuoteDetailVC.swift
//  MedWarehouse
//
//  Created by mac on 18/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper

class QuoteDetailVC: UIViewController {
    
    @IBOutlet weak var lblQuoteDetail: UILabel?
    @IBOutlet weak var lblMsgNotification: UILabel?
    @IBOutlet weak var lblCounterOffer: UILabel?
    @IBOutlet weak var btnCounter: UIButton?
    @IBOutlet weak var lblDescription: UILabel?
    @IBOutlet weak var txtmsg: UITextField?
    @IBOutlet weak var lblDelieveryDate: UILabel?
    @IBOutlet weak var lblQuantity: UILabel?
    @IBOutlet weak var txtdelieveredby: UITextField?
    @IBOutlet weak var txtPrice: UITextField?
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var txtPriceSymbol: UITextField?
    @IBOutlet weak var txtQuantity: UITextField?
    @IBOutlet weak var lblAccept: UILabel!
    let added = ["£","$","€"]
    var addedPickerview = UIPickerView()
    var data: GetRequestModel?
    var requestid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        // Do any additional setup after loading the view.
        lblMsgNotification?.isHidden = true
        self.getData()
        txtPriceSymbol?.inputView = addedPickerview
        txtPriceSymbol?.textAlignment = .natural
        addedPickerview.delegate = self
        addedPickerview.dataSource = self
        addedPickerview.tag = 1
        toMakeEditable(toggle: false)
        btnCounter?.layer.cornerRadius = 12
    }
    @IBAction func btnacceptAction(_ sender: Any) {
        if self.lblAccept?.text == "Accept"{
            self.toMakeEditable(toggle: true)
            self.webServiceCallingToAcceptRequest()
        }else{
            self.lblAccept?.text = "Accepted"
            self.toMakeEditable(toggle: false)
            
        }
    }
}
//MARK:- Initial Function(s)
//MARK:-
extension QuoteDetailVC{
    func toMakeEditable(toggle:Bool) {
        self.txtdelieveredby?.isUserInteractionEnabled = toggle
        self.txtQuantity?.isUserInteractionEnabled = toggle
        self.txtPrice?.isUserInteractionEnabled = toggle
    }
}

//MARK:- Button Function(s)
//MARK:-
extension QuoteDetailVC{
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btncounterUpdate(_ sender: Any) {
        if self.lblCounterOffer?.text == "Counter Offer"{
            self.lblCounterOffer?.text = "Submit Offer"
            self.toMakeEditable(toggle: true)
        }else{
            self.lblCounterOffer?.text = "Submit Offer"
            self.toMakeEditable(toggle: false)
            self.getCounterDataUpdate()
        }
        
    }
}

//MARK:- API Calling To Withdraw(s)
//MARK:-
extension QuoteDetailVC{
    func getAllPara() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = data?.request_id
        print(dictparam)
        return dictparam
        
    }
    func getData(){
        let param = getAllPara()
        objWebServiceManager.requestPost(strURL: request_quotes_details, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseQuoteslModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.lblQuoteDetail?.text = model.data?.last?.rs_note
                    self.lblDescription?.text = model.data?.last?.rt_description
                    //self.lblDelieveryDate?.text = model.data?.last?.rt_delivery_date
                    if let arr = model.data?.last?.rt_delivery_date?.components(separatedBy: " "), let date = arr.first {
                        self.lblDelieveryDate?.text = date
                    } else {
                        self.lblDelieveryDate?.text = ""
                    }
                    self.lblQuantity?.text = model.data?.last?.quantity
                    if let arr = model.data?.last?.rt_delivery_date?.components(separatedBy: " "), let date = arr.first {
                        self.txtdelieveredby?.text = date
                    } else {
                        self.txtdelieveredby?.text = ""
                    }
                    // self.txtdelieveredby?.text = model.data?.last?.delivery_by
                    self.txtQuantity?.text = model.data?.last?.quantity
                    self.txtPrice?.text = model.data?.last?.price_per_unit
                    self.requestid = model.data?.last?.id
                }
                if model.data?.first?.statusMsg == "active" {
                    self.toMakeEditable(toggle: true)
                }
                
            }
        }) { (error) in
            //
        }
    }
}

//MARK:- API Calling To CounterUpdate(s)
//MARK:-
extension QuoteDetailVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = self.requestid
        dictparam["delivery_by"] = self.txtdelieveredby?.text
        dictparam["price_per_unit"] = self.txtPrice?.text
        dictparam["quantity"] = self.txtQuantity?.text
        print(dictparam)
        return dictparam
        
    }
    func getCounterDataUpdate(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: request_quotes_counter_offer_update, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseQuoteslModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.lblMsgNotification?.isHidden = false
                    self.lblCounterOffer?.text = "Counter Offer"
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestforQuatationVC") as! RequestforQuatationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:-
//MARK:- Opening in Datepicker
extension QuoteDetailVC{
    func openDatePicker()  {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        txtdelieveredby?.inputAccessoryView = toolbar
        
    }
    @objc func cancelBtnClick(){
        txtdelieveredby?.resignFirstResponder()
    }
    
    @objc func doneBtnClick(){
        if let datePicker = txtdelieveredby?.inputView as? UIDatePicker{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "YYYY/MM/dd"
            txtdelieveredby?.text = dateFormatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        txtdelieveredby?.resignFirstResponder()
        
    }
    @objc func datePickerHandler(datePicker:UIDatePicker) {
        print(datePicker.date )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        if datePicker.tag == 0 {
            txtdelieveredby?.text = dateFormatter.string(from: datePicker.date)
            
        }
    }
}
//MARK:- OPEN DATEPICKER(S)
extension QuoteDetailVC{
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker.tag = 0
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.txtdelieveredby?.inputView = datePicker
    }
}
//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension QuoteDetailVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return added.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return added[row]
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtPriceSymbol?.text = added[row]
            txtPriceSymbol?.resignFirstResponder()
            
        default:
            return
        }
    }
}
//MARK:- API Calling To AllList
//MARK:-
extension QuoteDetailVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = self.requestid
        dictparam["request_quotes_id"] = data?.id
        print(dictparam)
        return dictparam
        
    }
    func webServiceCallingToAcceptRequest(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: acceptVendorRequest, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseMyQuatationModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //Success
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
