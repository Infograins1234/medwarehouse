//
//  ActiveQuoteTableViewCell.swift
//  MedWarehouse
//
//  Created by mac on 18/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ActiveQuoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAction: UIButton!
    @IBOutlet weak var btnwithDraw: UIButton!
    
    var onClickView:(() ->()) = {}
    var onClickWithdraw: (() ->()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnViewAction.layer.cornerRadius = 10
        btnwithDraw.layer.cornerRadius = 10
    }
    
    var data: GetRequestModel? {
        didSet {
            self.lblProduct?.text = self.data?.description
            if let arr = self.data?.added?.components(separatedBy: " "), let date = arr.first {
                self.lblDate?.text = date
            }else {
                self.lblDate?.text = ""
            }
            
            //self.lblDate?.text = self.data?.added
            self.lblTitle?.text = self.data?.status
        }
    }
    
    @IBAction func btnwithDrawnAction(_ sender: Any) {
        self.onClickWithdraw()
    }
    @IBAction func btnViewAction(_ sender: Any) {
        self.onClickView()
    }
    
}
