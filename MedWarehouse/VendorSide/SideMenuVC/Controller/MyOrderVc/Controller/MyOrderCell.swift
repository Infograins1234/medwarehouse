//
//  MyOrderCell.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {
    
    @IBOutlet weak var uiVwDetails: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInoviceId: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblINvoiceDate: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblSellerCompanyName: UILabel!
    @IBOutlet weak var lblInvoiceNo: UILabel!
    @IBOutlet weak var btnHideAction : UIButton?
    var onClickHideAction:(() ->()) = {}
    var onClickPdfAction:(() ->()) = {}
    var onClickChatAction:(() ->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        uiVwDetails.isHidden = true
        uiVwDetails.layer.cornerRadius = 12
        // Initialization code
    }
    var data: Orderlist? {
        didSet {
            
            //self.lblInoviceId.text = self.data?.invoice_number
            
            if let arr = self.data?.order_date?.components(separatedBy: " "), let date = arr.first {
                self.lblINvoiceDate?.text = date
            }else {
                self.lblINvoiceDate?.text = ""
            }
            //self.lblINvoiceDate.text = self.data?.order_date
            self.lblCountryName.text = self.data?.company_country
           // self.lblOrderNo.text = self.data?.customer_id
            self.lblInvoiceNo.text = data?.invoice_number
        }
    }
    
    
    @IBAction func btnhideViewAction(_ sender: Any) {
        self.onClickHideAction()
       
    }
    
    @IBAction func btnpdfViewAction(_ sender: Any) {
        self.onClickPdfAction()
    }
    
    @IBAction func btnchatNowAction(_ sender: Any) {
        self.onClickChatAction()
    }
    
}
