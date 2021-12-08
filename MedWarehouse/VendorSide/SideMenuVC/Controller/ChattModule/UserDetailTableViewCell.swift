//
//  UserDetailTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 18/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlet(s)
    //MARK:-
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblMsg  : UILabel?
    @IBOutlet weak var lblOrderId : UILabel?
    
    //MARK:- Variable(s)
    //MARK:-
    var onClickNextAction: (() -> ()) = {}
    
    //MARK:- View Life Cycle(s)
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnnextAction(_ sender: Any) {
        self.onClickNextAction()
    }
    
    var data: GetUserlist? {
        didSet {
            
            self.lblMsg?.text = self.data?.body
            self.lblOrderId?.text = self.data?.order_id
            self.lblName?.text = self.data?.sender_fname
        }
    }
}
