//
//  RecieveTableViewCell.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 17/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class RecieveTableViewCell: UITableViewCell {
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
                self.imgVwMen?.sd_setImage(with: url)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//var chatMsg: ChatMessage? {
//    didSet {
//        self.lblName?.text = chatMsg?.sender?.name
//        self.lblDescription?.text = chatMsg?.textMsg
//        if let strImage = self.chatMsg?.sender?.profilePic, let url = URL(string: strImage) {
//            self.imgVwUser?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let strData = self.chatMsg?.createdAt?.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".").first?.replacingOccurrences(of: ".000Z", with: ""), let utcToLocal = strData.utcToLocal(dateStr: strData) {
//            if let date = dateFormatter.date(from:  utcToLocal) {
//                self.lblTime?.text = Date().offset(from: date)
//            }
//        }else {
//            self.lblTime?.text = "Just now"
//        }
//    }
//}
