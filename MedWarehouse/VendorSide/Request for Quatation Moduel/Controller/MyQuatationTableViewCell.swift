//
//  MyQuatationTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 03/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MyQuatationTableViewCell: UITableViewCell {
   
    @IBOutlet weak var txtQuantity : UITextField?
    @IBOutlet weak var txtDilevered : UITextField?
    @IBOutlet weak var txtPrice : UITextField?
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnCounterOffer: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    var onClickAcceptRequest: (() ->()) = {}
    var onClickCounter: (() ->()) = {}
    var onClickChatAction: (() ->()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   toMakeEditable(toggle: false)
    }
    
    var data: GetQuatationModel? {
        didSet {
            self.lblMsg.text = self.data?.message
            self.txtQuantity?.text = self.data?.rt_quantity
            self.txtPrice?.text = self.data?.price_per_unit
            if let arr = self.data?.rt_delivery_date?.components(separatedBy: " "), let date = arr.first {
                self.txtDilevered?.text = date
            }else {
                self.txtDilevered?.text = ""
            }
        }
    }
    @IBAction func btncounterOfferAction(_ sender: Any) {
        onClickCounter()
    }
    @IBAction func btnAcceptAction(_ sender: Any) {
        onClickAcceptRequest()
    }
    
    @IBAction func btnchatAction(_ sender: Any) {
        onClickChatAction()
    }
    
}

