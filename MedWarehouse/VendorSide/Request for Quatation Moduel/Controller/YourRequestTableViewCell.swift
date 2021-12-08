//
//  YourRequestTableViewCell.swift
//  MedWarehouse
//
//  Created by mac on 03/12/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class YourRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var lblItemName : UILabel?
    @IBOutlet weak var lblDeliveredBy : UILabel?
    @IBOutlet weak var lblCloseOfSubmission: UILabel!
    @IBOutlet weak var lblQuantity : UILabel?
   
    var onClickAcceptRequest: (() ->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var data: GetQuatationModel? {
        didSet {
            self.lblItemName?.text = self.data?.rt_description
            self.lblQuantity?.text = self.data?.rt_quantity
            if let arr = self.data?.rt_delivery_date?.components(separatedBy: " "), let date = arr.first {
                self.lblDeliveredBy?.text = date
            }else {
                self.lblDeliveredBy?.text = ""
            }
            if let arr = self.data?.rt_closing_date?.components(separatedBy: " "), let date = arr.first {
                self.lblCloseOfSubmission?.text = date
            }else {
                self.lblCloseOfSubmission?.text = ""
            }
           // self.lblDeliveredBy?.text = self.data?.rt_delivery_date
            //self.lblCloseOfSubmission.text = self.data?.rt_closing_date
        }
    }
    @IBAction func btnrequestAcceptAction(_ sender: Any) {
        self.onClickAcceptRequest()
    }
    
}
