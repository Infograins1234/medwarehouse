//
//  RequestforQuatationTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 26/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class RequestforQuatationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblProductName : UILabel?
    @IBOutlet weak var lblDate : UILabel?
    @IBOutlet weak var lblCountry : UILabel?
    @IBOutlet weak var lblType : UILabel?
   
    var onClickWithdraw: (() ->()) = {}
    @IBOutlet weak var btnView: UIButton!
    var onClickView:(() ->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        btnView.layer.cornerRadius = 10
       // self.uiVwWithdram?.isHidden = true
       
        // Initialization code
    }
    var data: GetRequestModel? {
        didSet {
            self.lblProductName?.text = self.data?.description
            if let arr = self.data?.added?.components(separatedBy: " "), let date = arr.first {
                self.lblDate?.text = date
            }else {
                self.lblDate?.text = ""
            }
            
            self.lblType?.text = self.data?.requestor_type
            self.lblCountry?.text = self.data?.requestor_countory
           
        }
    }
   
    @IBAction func btnviewAction(_ sender: Any) {
        self.onClickView()
    }
    
//    @IBAction func btnwithdrawAction(_ sender: Any) {
//        self.onClickWithdraw()
//    }
    
    @IBAction func btnHideAction(_ sender: Any) {
    }
    

}
