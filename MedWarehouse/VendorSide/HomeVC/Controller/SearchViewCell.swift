//
//  SearchViewCell.swift
//  MedWarehouse
//
//  Created by Apple on 14/06/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var uioVwBox: UIView!
    @IBOutlet weak var lblProductName: UILabel?
    @IBOutlet weak var lblCompanyName: UILabel?
    @IBOutlet weak var lblCompanyCountry: UILabel?
    @IBOutlet weak var lblVendorCategory: UILabel?
    @IBOutlet weak var lblOnFloor: UILabel?
    @IBOutlet weak var lblAvability: UILabel?
    @IBOutlet weak var lblExpiryMonths: UILabel?
    @IBOutlet weak var tfquantity: UITextField!
    @IBOutlet weak var btncheck: UIButton?
    var id : String?
    var isChecked = true
    //MARK:- Variable Action(s)
    //MARK:-
//    var onChangeProductInformationAction:((_ data: ProductOrder) ->()) = { _ in}
//    var medicalProductOrder = ProductOrder(product_id: "", quantity: "")
    var onClickAction:(() ->()) = {}
    var productId : String?
    
    //MARK:- View LifeCycle Method(s)
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.onChangeProductInformationAction(self.medicalProductOrder)
//        tfquantity?.addTarget(self, action: #selector(SearchStockTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }
    @IBAction func btncheckAction(_ sender: UIButton) {
        self.onClickAction()
    }
//    @objc func textFieldDidChange(_ textField: UITextField) -> Bool {
//        if self.tfquantity == textField{
//            self.medicalProductOrder.quantity = textField.text
//
//        } else if self.lblProductName == textField {
//            self.medicalProductOrder.productOrder = textField.text
//        }
//
//
//        return true
//    }
    var data: RideHistory? {
        didSet {
//            self.medicalProductOrder = ProductOrder(product_id:  data?.id ?? "", quantity: tfquantity.text ?? "")
            self.lblProductName?.text = self.data?.name
            self.lblCompanyName?.text = self.data?.vendors_company_name
            self.lblCompanyCountry?.text = self.data?.vendors_company_country
            self.lblVendorCategory?.text = self.data?.vendor_category
            self.lblOnFloor?.text = self.data?.on_floor
            self.lblAvability?.text = self.data?.availability
            self.lblExpiryMonths?.text = self.data?.expiry_months
            self.tfquantity?.text = self.data?.quantity
            self.id = data?.id
            
        }
    }
}
