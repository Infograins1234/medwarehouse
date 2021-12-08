//
//  Global.swift
//  MedWarehouse
//
//  Created by Apple on 12/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
class Global {
     // MARK: - Loading-
        static let shared = Global()
    static func displayLoader(_ shouldDisplay: Bool, show: Bool) {
            if shouldDisplay {
                if show {
                    // display loader
                    Global.presentIndicator()
                } else {
                    // hide loader
                    Global.dismissIndicator()
                }
            }
        }
        
        //Present Loader
      static  func presentIndicator() {
            DispatchQueue.main.async {
               UIApplication.shared.windows.first?.isUserInteractionEnabled = false
                KRProgressHUD.show()
            }
        }
        
        //MARK:-Loader Function
      static  func dismissIndicator() {
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.isUserInteractionEnabled = true
                KRProgressHUD.dismiss()
            }
        }
    //MARK:- Alert with completion handler and alert style
    func displayAlertWithHandler(with title: String?, message: String?, buttons: [String], viewobj:UIViewController,buttonStyles: [UIAlertAction.Style] = [], handler: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
