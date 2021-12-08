//
//  ProductSearchVC.swift
//  MedWarehouse
//
//  Created by Apple on 17/06/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class ProductSearchVC: UIViewController {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var uiSearchbar: UISearchBar!
    @IBOutlet weak var tblVw: UITableView!
    
    //MARK:- Variable Action(s)
    //MARK:-
    var arrProduct : [RideHistory?]?
    var arrFilterProduct : [RideHistory?]?
    var strProductid = ""
    var Name = ""
    var Avaibility = ""
    var onFloor = ""
    var ExpiryDate = ""
    var SearchCountry = [String]()
    var searching = false
    
    //MARK:- View LifeCycle Method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weServiceCallingToAllList()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSideMenuAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Tableview delegate & datasource method(s)
//MARK:-
extension ProductSearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilterProduct?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchViewCell") as! ProductSearchViewCell
        let data = self.arrFilterProduct?[indexPath.row]
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
//MARK:- UISearchBar Delegate Method{s)
//MARK:
extension ProductSearchVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrFilterProduct = self.arrProduct?.filter({($0?.name?.lowercased().contains(searchText.lowercased()))!})
        searching = true
        self.tblVw.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
//MARK:- API Calling To AllList
//MARK:-
extension ProductSearchVC{
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
                    self.arrProduct = model.rideHistory
                    self.arrFilterProduct = model.rideHistory
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
//MARK:- API Calling To AllList
//MARK:-
extension ProductSearchVC{
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
                    //Succe
                    self.weServiceCallingToAllList()
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
extension ProductSearchVC{
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
