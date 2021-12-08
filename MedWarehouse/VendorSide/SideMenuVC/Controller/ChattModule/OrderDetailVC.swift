//
//  OrderDetailVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 18/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductAvability: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    var data: Orderlist?
    var orderId = ""
    var orderDate = ""
    var orderStatus = ""
    var Productname = ""
    var ProductAvability = ""
    var CustomerType = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblOrderId.text = self.orderId
        self.lblOrderDate.text = self.orderDate
        self.lblOrderStatus.text = self.orderStatus
        self.lblProductName.text = self.Productname
        self.lblProductAvability.text = self.ProductAvability
        self.lblOrderType.text = self.CustomerType
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
