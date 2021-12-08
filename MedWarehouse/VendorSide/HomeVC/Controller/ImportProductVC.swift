//
//  ImportProductVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import SideMenu
import MobileCoreServices
import UniformTypeIdentifiers

@available(iOS 11.0, *)
class ImportProductVC: UIViewController {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnAddSubmit: UIButton!
    var strSampleurl : String?
    var data: [RideHistory?]?
    var names : String?
    var arrImageInfo: [ImageInfo] = []
    var name = ""
    var avaibility = ""
    var onFloor = ""
    var expiryDate = ""
    var quantity = ""
    var slug = ""
    var Description = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddSubmit.layer.cornerRadius = 30
        
    }
    @IBAction func btnclickSideMenuAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let vcc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let sidemenu
            = SideMenuNavigationController(rootViewController: vcc)
        sidemenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        present(sidemenu,animated: true)
    }
    @available(iOS 14.0, *)
    @IBAction func btnclickAddAction(_ sender: Any) {
        generateImportCsv()
    }
}

//MARK :- UiDocumentPicker Delegate Method(s)
//MARK:-
@available(iOS 11.0, *)
extension ImportProductVC : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("a file was Selected")
        let rows = NSArray(contentsOfCSVURL: url, options: CHCSVParserOptions.sanitizesFields)!
        for row in rows {
            print(row)
            let double = row
            
            self.weServiceCallingToImportList()
        }
    }
}
//MARK :- UiDocumentPicker Delegate Method(s)
//MARK:-
extension ImportProductVC{
    func getAllParam() -> [String:Any] {
        var dicparam = [String:Any]()
        
        dicparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dicparam["file"] = ""
        
        print(dicparam)
        return dicparam
    }
    func weServiceCallingToImportList() {
        
        let params = getAllParam()
        objWebServiceManager.uploadImage(strUrl: import_product, para: params, image: arrImageInfo, showIndicator: true, succes: { (response) in
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.name = self.name
                    vc.quantity = self.quantity
                    vc.avaibility = self.avaibility
                    vc.slug = self.slug
                    vc.Description = self.Description
                    vc.expiryDate = self.expiryDate
                    vc.onFloor = self.onFloor
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (error) in
            objAppShareData.showAlertVC(title: "Alert", message: error.localizedDescription, controller: self)
        }
        
        
    }
}

//MARK :- UiDocumentPicker Delegate Method(s)
//MARK:-
@available(iOS 14.0, *)
extension ImportProductVC {
    func generateImportCsv() {
        let supportedFiles: [UTType] = [UTType.data]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false
        present(controller, animated: true, completion: nil)
    }
}
