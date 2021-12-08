//
//  SenderTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 21/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblRecieveMessage : UILabel?
    @IBOutlet weak var imgVwMen: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var comment: GetRecieveChatModel? {
        didSet {
          
            self.lblRecieveMessage?.text = self.comment?.body
            if let strImage = self.comment?.files_img, let url = URL(string: strImage) {
                self.imgVwMen?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
