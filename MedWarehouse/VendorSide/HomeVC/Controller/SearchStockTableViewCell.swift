//
//  SearchStockTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 25/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SearchStockTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txtProductName: UITextField?
    @IBOutlet weak var txtQuantity: UITextField?
   
    //MARK:- Variable Action(s)
    //MARK:-
    var onClickCancelAction:(() ->()) = {}
    var onChangeProductInfoAction:((_ data: Product) ->()) = { _ in}
    var medicalProductName = Product(product_name: "", quantity: "")
    
    //MARK:- View LifeCycle Method(s)
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        txtProductName?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
        txtQuantity?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)

        txtProductName?.delegate = self
        txtQuantity?.delegate = self
        //btnCross.isHidden = true
        // Initialization code
    }
    
    @IBAction func btncancelAction(_ sender: Any) {
        self.onClickCancelAction()
    }
    @objc func textFieldDidChange(_ textField: UITextField) -> Bool {
        if self.txtProductName == textField {
            medicalProductName.product_name = textField.text
            print(medicalProductName.product_name)
        } else {
            medicalProductName.quantity = textField.text
            print(medicalProductName.quantity)
        }
        self.onChangeProductInfoAction(self.medicalProductName)
        return true

    }
}

