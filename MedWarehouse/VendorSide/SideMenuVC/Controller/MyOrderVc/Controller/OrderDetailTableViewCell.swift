//
//  OrderDetailTableViewCell.swift
//  MedWarehouse
//
//  Created by mac on 26/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
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
        // Initialization code
    }
    var data: Orderlist? {
        didSet {
            self.lblName.text = self.data?.productlist?.first?.product_name
            //self.lblInoviceId.text = self.data?.invoice_number
            self.lblSellerCompanyName.text = self.data?.productlist?.first?.seller_company_name
            self.lblINvoiceDate.text = self.data?.order_date
            self.lblCountryName.text = self.data?.company_country
            self.lblOrderNo.text = self.data?.customer_id
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
