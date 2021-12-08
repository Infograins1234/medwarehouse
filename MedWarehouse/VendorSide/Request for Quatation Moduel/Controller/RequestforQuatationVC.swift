//
//  RequestforQuatationVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 26/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import SideMenu
class RequestforQuatationVC: UIViewController {
    //MARK:- Iboutlet Method{s)
    //MARK:
    @IBOutlet weak var txtDateAdded: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var lblActiveQuote: UILabel!
    @IBOutlet weak var uiVwDate: ViewLayerSetup!
    @IBOutlet weak var lblOpenQuote: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var txtLastDate : UITextField?
    // @IBOutlet weak var uiVwSwitch: UIView!
    @IBOutlet weak var uiSearchbar: UISearchBar!
    @IBOutlet weak var uiVwOpenQuate: ViewLayerSetup!
    @IBOutlet weak var uiVwActiveQuate: ViewLayerSetup!
    @IBOutlet weak var uiVwAdd: ViewLayerSetup!
    @IBOutlet weak var uiVwSearch : UIView?
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var btnActiveQuote: UIButton?
    @IBOutlet weak var btnOpenQuote: UIButton?
    var arrRequestProduct : [GetRequestModel?]?
    var requestid : String?
    var id : String?
    let avability = ["Type","date_added","soon_to_end"]
    var avabilityPickerview = UIPickerView()
    var searching = false
    var vendorID = ""
    var rs_vendor_id : String?
    var isForOpenCode = false
    //MARK:- View LifeCycle Method{s)
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        initialConfig()
    }
    
}

//MARK:- Initial Function Method{s)
//MARK:
extension RequestforQuatationVC {
    func initialConfig() {
        // self.webServiceCallingToRequestStockList()
        self.webServiceCallingToRequestStockList()
        //  uiVwSwitch.isHidden = false
        txtLastDate?.inputView = avabilityPickerview
        txtLastDate?.textAlignment = .natural
        self.uiVwActiveQuate?.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.7176470588, blue: 0.7882352941, alpha: 0.5578881089)
        self.uiVwOpenQuate?.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.7176470588, blue: 0.7882352941, alpha: 1)
        lblActiveQuote.textColor = .white
        avabilityPickerview.delegate = self
        avabilityPickerview.dataSource = self
        avabilityPickerview.tag = 1
        uiVwAdd.isHidden = true
        
    }
}
//MARK:- Initial Function Method{s)
//MARK:
extension RequestforQuatationVC {
    @IBAction func btnbackAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let vcc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let sidemenu
            = SideMenuNavigationController(rootViewController: vcc)
        sidemenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        present(sidemenu,animated: true)
    }
    
    @IBAction func btnopenQuoteAction(_ sender: Any) {
        self.webServiceCallingToRequestStockList()
        self.uiVwActiveQuate?.backgroundColor = .clear
        self.uiVwOpenQuate?.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.7176470588, blue: 0.7882352941, alpha: 1)
        //uiVwSwitch.isHidden = false
        uiVwDate.isHidden = false
        uiVwAdd.isHidden = true
        arrRequestProduct?.removeAll()
        self.tblVw.reloadData()
        self.isForOpenCode = false
        // self.lblOpenQuote.textColor = .white
        self.uiVwSearch?.isHidden = false
        self.tblVw?.reloadData()
        
    }
    
    @IBAction func btnactiveQuoteAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActiveQuoteVC") as! ActiveQuoteVC
        vc.requestid = self.requestid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnsearchAction(_ sender: Any) {
        self.getSearchList()
    }
    @IBAction func btnncancelAction(_ sender: Any) {
        self.webServiceCallingToRequestStockList()
        
    }
}
//MARK:- TableView Delegate & DataSource Method(s)
//MARK:-
extension RequestforQuatationVC :  UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequestProduct?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestforQuatationTableViewCell") as! RequestforQuatationTableViewCell
        cell.onClickView = { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "QuatationSubmissionVC") as! QuatationSubmissionVC
            vc.data = cell.data
//            vc.requestid = self?.requestid ?? ""
//            vc.id     = self?.id
//            vc.VendorID = self?.vendorID
//            vc.rs_vendor_id = self?.rs_vendor_id
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let data = self.arrRequestProduct?[indexPath.row ]
        cell.data = data
        self.requestid = data?.request_id
        self.id       = data?.id
        self.vendorID = data?.vendor_id ?? ""
        self.rs_vendor_id = data?.rs_vendor_id ?? ""
        return cell
    }
}

//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension RequestforQuatationVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return avability.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return avability[row]
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtLastDate?.text = avability[row]
            txtLastDate?.resignFirstResponder()
            self.webServiceCallingToRequestStockList()
        default:
            return
        }
    }
    
}
//MARK:- API Calling To Open(s)
//MARK:-
extension RequestforQuatationVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtLastDate?.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func webServiceCallingToRequestStockList(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: request_for_quotation, params: param, showIndicator: true, success: { (response) in
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
//MARK:- API Calling To Active(s)
//MARK:-
extension RequestforQuatationVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtDateAdded?.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func getActiveList(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: request_quotes_submission_data, params: param, showIndicator: true, success: { (response) in
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
//MARK:- UISearchBar Delegate Method{s)
//MARK:
extension RequestforQuatationVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrRequestProduct = self.arrRequestProduct?.filter({($0?.description?.lowercased().contains(searchText.lowercased()))!})
        searching = true
        self.tblVw.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

//MARK:- API Calling To Withdraw(s)
//MARK:-
extension RequestforQuatationVC{
    func getAll() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtLastDate?.text
        dictparam["search_name"] = self.txtSearch.text
        print(dictparam)
        return dictparam
        
    }
    func getSearchList(){
        let param = getAll()
        objWebServiceManager.requestPost(strURL: request_for_quotation_data_search, params: param, showIndicator: true, success: { (response) in
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
