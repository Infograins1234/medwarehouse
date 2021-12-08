//
//  AllOrdeCell.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class AllOrdeCell: UITableViewCell {
    @IBOutlet weak var uiVwDetails: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblAdded: UILabel!
    @IBOutlet weak var lblModified: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCompanyCountry: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var uiVwOrderid: UIView!
     var onClicPdfAction:(() ->()) = {}
    var onClicChatAction:(() ->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        uiVwDetails.layer.cornerRadius = 12
        uiVwOrderid.layer.cornerRadius = 17.5
        // Initialization code
        
    }
    @IBAction func btnpdfDownloadAction(_ sender: Any) {
        self.onClicPdfAction()
    }
    @IBAction func btnchatNowAction(_ sender: Any) {
        self.onClicChatAction()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    var data: Productlist? {
               didSet {
                  self.lblProductName.text = self.data?.product_name
                if let arr = self.data?.added?.components(separatedBy: " "), let date = arr.first {
                    self.lblAdded?.text = date
                }else {
                    self.lblAdded?.text = ""
                }
                if let arr = self.data?.modified?.components(separatedBy: " "), let date = arr.first {
                    self.lblModified?.text = date
                }else {
                    self.lblModified?.text = ""
                }
                  // self.lblAdded.text = self.data?.added
                //self.lblModified.text = self.data?.modified;
                self.lblCompanyName.text = self.data?.vc_company_name
                  self.lblCompanyCountry.text = self.data?.v_companycountry
                self.lblOrderId.text = self.data?.order_id
               }
           }
}
