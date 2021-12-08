//
//  ProfileTableViewCell.swift
//  MedWarehouse
//
//  Created by Chandan Dubey on 04/07/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var lblimgName: UILabel?
    @IBOutlet weak var lblimgUpdateName: UILabel?
    @IBOutlet weak var uiVwChooseImage: UIView!
    @IBOutlet weak var uiVwImage: UIView!
    var onClickUpdateProfileAction:(() ->()) = {}
    var data: String? {
        didSet {
            self.lblimgName?.text = self.data
            self.lblimgUpdateName?.text = self.data
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // uiVwChooseImage.isHidden = true
        // Initialization code
    }
    
    @IBAction func btnselectGalleryImgActioon(_ sender: Any) {
        self.onClickUpdateProfileAction()
    }
}
