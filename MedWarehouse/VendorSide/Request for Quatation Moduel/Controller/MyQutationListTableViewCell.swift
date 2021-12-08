//
//  MyQutationListTableViewCell.swift
//  MedWarehouse
//
//  Created by mac on 13/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MyQutationListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblProductName : UILabel?
    @IBOutlet weak var uiVw : UIView?
    var onClickView:(() ->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var data: GetRequestModel? {
        didSet {
            self.lblProductName?.text = self.data?.rt_description
//            self.lblDate?.text = self.data?.added
        }
    }
  
    @IBAction func btnviewAction(_ sender: Any) {
        self.onClickView()
    }
}
