//
//  QuatationTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 26/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class QuatationTableViewCell: UITableViewCell, UITextFieldDelegate {
    //MARK:- Ibaction Method(s)
    //MARK:-
    @IBOutlet weak var lblmsgQutaton: UILabel!
    @IBOutlet weak var tfDeliveredDate: UITextField!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel?
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfPriceSymbol: UITextField!
    @IBOutlet weak var btnCheck : UIButton?
    @IBOutlet weak var lblDelievieryDate: UILabel!
    @IBOutlet weak var txtQuantity: UITextField!
    var onClickAction:(() ->()) = {}
    let added = ["£","$","€"]
    var addedPickerview = UIPickerView()
    var onChangeProductInfoAction:((_ data: QuoteSubmit) ->()) = { _ in}
    var quoteSubmitProductName = QuoteSubmit(product_name: "", quantity: "", priceperUnit: "", deliveryDate: "", message: "", request_id: "", request_items_id: "",currency: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupDatePicker()
        txtQuantity.delegate = self
        tfPrice.delegate = self
        txtQuantity.delegate = self
        tfPriceSymbol?.inputView = addedPickerview
        tfPriceSymbol?.textAlignment = .natural
        addedPickerview.delegate = self
        addedPickerview.dataSource = self
        addedPickerview.tag = 1
        txtQuantity?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
        tfPrice?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
        tfDeliveredDate?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }
    func getTotal() {
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) -> Bool {
        if self.tfPrice == textField{
            self.quoteSubmitProductName.price_unit = textField.text
            print(quoteSubmitProductName.price_unit)
            self.data?.price_unit = textField.text
        } else if self.txtQuantity == textField {
            self.quoteSubmitProductName.quantity = textField.text
    
        } else if self.tfDeliveredDate == textField {
            self.quoteSubmitProductName.deliveryDate = textField.text
        } else if self.lblmsgQutaton == textField {
            self.quoteSubmitProductName.product_name = textField.text
            print(quoteSubmitProductName.product_name)
        } else {

        }
        self.onChangeProductInfoAction(self.quoteSubmitProductName)
        self.setTotalPrice()
        return true
    }
    var data: ResQuoteSubmitModel? {
        didSet {
            self.quoteSubmitProductName = QuoteSubmit(product_name: data?.description ?? "", quantity: data?.quantity ?? "", priceperUnit: self.tfPrice.text ?? "", deliveryDate: tfDeliveredDate.text ?? "" , message: "", request_id: data?.request_items_id ?? "", request_items_id: data?.request_items_id ?? "",currency : "")
            self.lblmsgQutaton?.text = self.data?.description
            self.lblQuantity?.text = self.data?.quantity
            self.txtQuantity.text = self.data?.quantity
            //self.tfDeliveredDate.text = self.data?.delivery_date
            if let arr = self.data?.delivery_date?.components(separatedBy: " "), let date = arr.first {
                self.lblDelievieryDate?.text = date
            }else {
                self.lblDelievieryDate?.text = ""
            }
            
            self.setTotalPrice()
        }
    }
    @IBAction func btncheckAction(_ sender: UIButton) {
        self.onClickAction()
    }
    
    func setTotalPrice() {
        if let quantity = Int(self.data?.quantity ?? "0") , let priceUnit = Int(self.data?.price_unit ?? "0") {
            let totalPrice = quantity * priceUnit
            self.lblTotalPrice.text = totalPrice.description
        }
    }
}

//MARK:-
//MARK:- Opening in Datepicker
extension QuatationTableViewCell{
    func openDatePicker()  {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        tfDeliveredDate.inputAccessoryView = toolbar
        
    }
    @objc func cancelBtnClick(){
        tfDeliveredDate.resignFirstResponder()
    }
    
    @objc func doneBtnClick(){
        if let datePicker = tfDeliveredDate.inputView as? UIDatePicker{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "YYYY/MM/dd"
            tfDeliveredDate.text = dateFormatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        tfDeliveredDate.resignFirstResponder()
        
    }
    @objc func datePickerHandler(datePicker:UIDatePicker) {
        print(datePicker.date )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        if datePicker.tag == 0 {
            tfDeliveredDate.text = dateFormatter.string(from: datePicker.date)
            self.quoteSubmitProductName.deliveryDate =  dateFormatter.string(from: datePicker.date)
        }
    }
}
//MARK:- OPEN DATEPICKER(S)
extension QuatationTableViewCell{
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker.tag = 0
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.tfDeliveredDate.inputView = datePicker
    }
}
//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension QuatationTableViewCell: UIPickerViewDelegate,UIPickerViewDataSource{
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
            tfPriceSymbol?.text = added[row]
            tfPriceSymbol?.resignFirstResponder()
            
        default:
            return
        }
    }
}
