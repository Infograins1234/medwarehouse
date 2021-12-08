//
//  HomeVC.swift
//  MedWarehouse
//
//  Created by Apple on 26/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class HomeVC: UIViewController {
    
    @IBOutlet weak var imgVwContent: UIImageView!
    @IBOutlet weak var tblVw: UITableView!
    var arrList: [RideHistory?]?
    var strProductid = ""
    var strSampleurl : String?
    var name = ""
    var avaibility = ""
    var onFloor = ""
    var expiryDate = ""
    var quantity = ""
    var slug = ""
    var Description = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weServiceCallingToAllList()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnsampleDownloadAction(_ sender: Any) {
        
        let sFileName = "SampleDocument.csv"
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
        csvWriter?.closeStream()
        objAppShareData.showAlertVC(title: "Alert", message: "Successfully Download SampleDocument", controller: self)
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
    
    @IBAction func btnclickAddAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnclickImportAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImportProductVC") as! ImportProductVC
        vc.data = arrList
        vc.strSampleurl = self.strSampleurl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnclickExportAction(_ sender: Any) {
        let vc = self.storyboard? .instantiateViewController(withIdentifier: "ExportVC") as! ExportVC
        vc.data = arrList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnclickSearchAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductSearchVC") as! ProductSearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Tableview delegate & datasource method(s)
//MARK:-
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        let data = self.arrList?[indexPath.row]
        cell.data = data
       
        cell.onClickEditAction = {[weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UploadVC") as! UploadVC
            vc.data = data
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.onClickDeleteAction = { [weak self] in
            self?.strProductid = data?.id ?? ""
            self?.deleteAction()
          
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- API Calling To AllList
//MARK:-
extension HomeVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToAllList(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: all_product, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //Success
                   
                    self.arrList = model.rideHistory
                    self.strSampleurl = model.sample_document
                    self.tblVw.reloadData()
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:- API Calling To DeleteProduct
//MARK:-
extension HomeVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["product_id"] = self.strProductid
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToDeleteProduct(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: Delete_product, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrList?.removeAll()
                    self.weServiceCallingToAllList()
                    self.tblVw.reloadData()
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:- Delete Alert Action(s)
//MARK:-
extension HomeVC{
    func deleteAction() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete product", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("Yes Pressed")
            self.weServiceCallingToDeleteProduct()
            
            
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("NO Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}

