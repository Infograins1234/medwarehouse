//
//  ExportVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
import SwiftCSVExport
class ExportVC: UIViewController {
    var Name = ""
    var Avaibility = ""
    var onFloor = ""
    var ExpiryDate = ""
    var Quantity = ""
    var slug = ""
    var Description = ""
    
    @IBOutlet weak var uiVWButton: UIView!
    @IBOutlet weak var uiVwExport: UIView!
    var data: [RideHistory?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnExportAction(_ sender: Any) {
        self.weServiceCallingToExportList()
        let sFileName = "data.csv"
        let documentaryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentURL = URL(fileURLWithPath: documentaryPath).appendingPathComponent(sFileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first ?? 0 )
        csvWriter?.writeField("Name")
        csvWriter?.writeField("ExpiryDate")
        csvWriter?.writeField("Avaibility")
        csvWriter?.writeField("onFloor")
        csvWriter?.writeField("slug")
        csvWriter?.writeField("quantity")
        csvWriter?.writeField("description")
        csvWriter?.finishLine()
        
        for exportData in data ?? [] {
            csvWriter?.writeField(exportData?.name)
            csvWriter?.writeField(exportData?.expiry_months)
            csvWriter?.writeField(exportData?.availability)
            csvWriter?.writeField(exportData?.on_floor)
            csvWriter?.writeField(exportData?.slug)
            csvWriter?.writeField(exportData?.quantity)
            csvWriter?.writeField(exportData?.description)
            csvWriter?.finishLine()
        }
        csvWriter?.closeStream()
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do {
            try buffer.write(to: documentURL)
        } catch {
            
        }
        
    }
    @IBAction func btnsideMenuAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let vcc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let sidemenu
            = SideMenuNavigationController(rootViewController: vcc)
        sidemenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        present(sidemenu,animated: true)
    }
    
}

//MARK:- API Calling To AllList
//MARK:-
extension ExportVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["name"] = self.Name
        dictparam["expiry_months"] = self.ExpiryDate
        dictparam["availability"] = self.Avaibility
        dictparam["on_floor"] = self.onFloor
        dictparam["slug"] = self.slug
        dictparam["quantity"] = self.Quantity
        dictparam["description"] = self.Description
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToExportList(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: export_product, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //Successp
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}

