//
//  AppShareData.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
let objAppShareData =  AppShareData()
class AppShareData: NSObject{
   let objValidation : ValidationClass = ValidationClass()
    func showAlertVC(title : String,message:String,controller:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let subView = alertController.view.subviews.first!
        let alertContentView = subView.subviews.first!
        alertContentView.backgroundColor = UIColor.gray
        alertContentView.layer.cornerRadius = 20
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
    }
   func displayAlertWithHandlerwithSheetStyle(with title: String?, message: String?, buttons: [String], viewobj:UIViewController,buttonStyles: [UIAlertAction.Style], handler: @escaping (String) -> Void) {
       DispatchQueue.main.async {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
           for i in 0 ..< buttons.count {
               let style: UIAlertAction.Style = buttonStyles.indices.contains(i) ? buttonStyles[i] : .default
               let buttonTitle = buttons[i]
               let action = UIAlertAction(title: buttonTitle, style: style) { (_) in
                   handler(buttonTitle)
               }
               alertController.addAction(action)
           }
           viewobj.present(alertController, animated: true)
       }
   }
   
}
