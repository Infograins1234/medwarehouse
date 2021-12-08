//
//  ViewDetailVC.swift
//  MedWarehouse
//
//  Created by Apple on 10/06/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ViewDetailVC: UIViewController {
var dismissPopupController:(() ->()) = {}
    @IBOutlet weak var uiVwDetailBox: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var lblSellerCountry: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblItemNo: UILabel!
     var onClicPdfAction:(() ->()) = {}
     var data: Orderlist?
      override func viewDidLoad() {
        super.viewDidLoad()
        self.lblItemNo.text = self.data?.customer_id
        self.lblProductName.text = self.data?.productlist?.first?.product_name
        self.lblSellerName.text = self.data?.productlist?.first?.seller_company_name
        self.lblSellerCountry.text = self.data?.company_country
        uiVwDetailBox.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    @IBAction func btnbackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.dismissPopupController()
    }
    @IBAction func btncancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.dismissPopupController()
    }
   @IBAction func btnopenPdfAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    self.onClicPdfAction()
   }
}
