//
//  MyQutationListVC.swift
//  MedWarehouse
//
//  Created by mac on 13/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import ObjectMapper
import SideMenu
class MyQutationListVC: UIViewController {
    //MARK:- Iboutlet Method{s)
    //MARK:
   
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtType: UITextField!
    var arrRequestProduct : [GetRequestModel?]?
    var requestid = ""
    let added = ["Type","date_added","soon_to_end"]
    var addedPickerview = UIPickerView()
    //MARK:- View LifeCycle Method{s)
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webServiceCallingToRequestStockList()
        txtType?.inputView = addedPickerview
        txtType?.textAlignment = .natural
        addedPickerview.delegate = self
        addedPickerview.dataSource = self
        addedPickerview.tag = 1
    }
    @IBAction func btnsearchAction(_ sender: Any) {
        self.arrRequestProduct?.removeAll()
        self.getSearchList()
        self.tblVw.reloadData()
        
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

//MARK:- TableView Delegate & DataSource Method(s)
//MARK:-
extension MyQutationListVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequestProduct?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQutationListTableViewCell") as! MyQutationListTableViewCell
        let data = self.arrRequestProduct?[indexPath.row ]
        cell.data = data
        self.requestid = data?.request_id ?? ""
        cell.onClickView = { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "YourRequestDetailVC") as! YourRequestDetailVC
            vc.data = data
            vc.requestid = self?.requestid ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
       
        return cell
    }
}


//MARK:- API Calling To Open(s)
//MARK:-
extension MyQutationListVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtType.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func webServiceCallingToRequestStockList(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: requestforQutation, params: param, showIndicator: false, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseRequestforquatation>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrRequestProduct = model.data
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
//MARK:- API Calling To Withdraw(s)
//MARK:-
extension MyQutationListVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtType?.text ?? ""
        dictparam["search_product"] = self.txtSearch.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func getSearchList(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: request_for_quotation_search, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseRequestforquatation>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrRequestProduct = model.data
                 //   self.arrRequestProduct?.removeAll()
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

//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension MyQutationListVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return added.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return added[row]
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtType?.text = added[row]
            txtType?.resignFirstResponder()
            self.getSearchList()
        default:
            return
        }
    }
}
