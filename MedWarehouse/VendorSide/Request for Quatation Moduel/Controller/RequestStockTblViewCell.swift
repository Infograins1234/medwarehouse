//
//  RequestStockTblViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 25/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class RequestStockTblViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var tfDeliveredDate: UITextField!
    @IBOutlet weak var tfCloseSubmissionDate: UITextField!
    
    
    //MARK:- Variable Action(s)
    //MARK:-
    var onClickCancelAction:(() ->()) = {}
    var onClickTextAction:(() ->()) = {}
    var onChangeProductInfoAction:((_ data: ProductDate) ->()) = { _ in}
    var medicalProductName = ProductDate(product_name: "", quantity: "", closeofSubmission : "" , deliveryDate : "" )
    var date : String?
    
    //MARK:- View LifeCycle Method(s)
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        tfProductName?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
        tfQuantity?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
        setupDate()
        tfProductName.delegate = self
        tfQuantity.delegate = self
        tfDeliveredDate.delegate = self
        tfCloseSubmissionDate.delegate = self
        
    }
    
    @IBAction func btnCancelAction(_ sender : Any) {
        self.onClickCancelAction()
    }
    @objc func textFieldDidChange(_ textField: UITextField) -> Bool {
        if self.tfProductName == textField{
            self.medicalProductName.product_name = textField.text
            
        } else if self.tfQuantity == textField {
            self.medicalProductName.quantity = textField.text
            
        } else if self.tfDeliveredDate == textField {
            self.medicalProductName.deliveryDate =  (textField.text)
            print(medicalProductName.deliveryDate!)
        } else if self.tfCloseSubmissionDate == textField {
            self.medicalProductName.closeSubmission =  (textField.text)
            print(medicalProductName.closeSubmission!)
        }
        
        self.onChangeProductInfoAction(self.medicalProductName)
        return true
    }
}
//MARK:- Opening in Datepicker
extension RequestStockTblViewCell{
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
            self.medicalProductName.deliveryDate =  dateFormatter.string(from: datePicker.date)
        }else if datePicker.tag == 1 {
            tfCloseSubmissionDate.text = dateFormatter.string(from: datePicker.date)
            self.medicalProductName.closeSubmission =  dateFormatter.string(from: datePicker.date)
            
        }
    }
}
//MARK:- OPEN DATEPICKER(S)
extension RequestStockTblViewCell{
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker.tag = 1
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.tfCloseSubmissionDate.inputView = datePicker
        
        let datePicker1 = UIDatePicker()
        datePicker1.datePickerMode = .date
        datePicker1.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker1.tag = 0
        datePicker1.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.tfDeliveredDate.inputView = datePicker1
    }
}


//MARK:- Opening in Datepicker
extension RequestStockTblViewCell{
    func openDate()  {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        tfCloseSubmissionDate.inputAccessoryView = toolbar
        
    }
    
    
    @objc func cancelBtn(){
        tfCloseSubmissionDate.resignFirstResponder()
    }
    
    @objc func doneBtn(){
        if let datePicker = tfCloseSubmissionDate.inputView as? UIDatePicker{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "YYYY/MM/dd"
            tfCloseSubmissionDate.text = dateFormatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        tfCloseSubmissionDate.resignFirstResponder()
        
    }
    @objc func datePicker(datePickers:UIDatePicker) {
        print(datePickers.date )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        if datePickers.tag == 0 {
            tfDeliveredDate.text = dateFormatter.string(from: datePickers.date)
            self.medicalProductName.deliveryDate =  dateFormatter.string(from: datePickers.date)
        }else if datePickers.tag == 1 {
            tfCloseSubmissionDate.text = dateFormatter.string(from: datePickers.date)
            self.medicalProductName.closeSubmission =  dateFormatter.string(from: datePickers.date)
            
        }
    }
}
//MARK:- OPEN DATEPICKER(S)
extension RequestStockTblViewCell{
    func setupDate() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker.tag = 1
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.tfCloseSubmissionDate.inputView = datePicker
        
        let datePicker1 = UIDatePicker()
        datePicker1.datePickerMode = .date
        datePicker1.addTarget(self, action: #selector(self.datePickerHandler(datePicker:)), for: .valueChanged)
        datePicker1.tag = 0
        datePicker1.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker1.preferredDatePickerStyle = .wheels
        }
        self.tfDeliveredDate.inputView = datePicker1
    }
}
