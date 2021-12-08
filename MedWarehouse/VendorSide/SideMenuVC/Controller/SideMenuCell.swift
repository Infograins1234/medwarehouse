//
//  SideMenuCell.swift
//  MedWarehouse
//
//  Created by Apple on 26/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var imgVw: UIImageView!
       @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
