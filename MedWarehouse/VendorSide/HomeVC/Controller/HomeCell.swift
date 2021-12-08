//
//  HomeCell.swift
//  MedWarehouse
//
//  Created by Apple on 17/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblAva: UILabel!
    @IBOutlet weak var lblFloor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    
    //MARK:- Var(s)
    //MARK:-
    var onClickEditAction:(() ->()) = {}
    var onClickDeleteAction:(() ->()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        self.onClickEditAction()
    }
    @IBAction func btndeleteAction(_ sender: Any) {
        self.onClickDeleteAction()
    }
    var data: RideHistory? {
        didSet {
            self.lblProduct.text = self.data?.name
            self.lblAva.text = self.data?.availability
            self.lblFloor.text = self.data?.on_floor
            self.lblDate.text = self.data?.expiry_months
            self.lblSearch.text = self.data?.searched
            
        }
    }
}
