//
//  ActiveQuoteVC.swift
//  MedWarehouse
//
//  Created by mac on 18/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import SideMenu
class ActiveQuoteVC: UIViewController {
    
    @IBOutlet weak var btnYourActive: UIButton!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var txttype: UITextField!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var uiVwOpenQuate: ViewLayerSetup!
    @IBOutlet weak var uiVwActiveQuate: ViewLayerSetup!
    var arrRequestProduct : [GetRequestModel?]?
    var requestid : String?
    var id : String?
    let added = ["All","active","withdrawn","expired","date_added"]
    var addedPickerview = UIPickerView()
    var searching = false
    var vendorID = ""
    var rs_vendor_id : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txttype?.inputView = addedPickerview
        txttype?.textAlignment = .natural
        addedPickerview.delegate = self
        addedPickerview.dataSource = self
        addedPickerview.tag = 1
        self.uiVwOpenQuate?.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.7176470588, blue: 0.7882352941, alpha: 0.5578881089)
        lblOpen.textColor = .white
        self.uiVwActiveQuate?.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.7176470588, blue: 0.7882352941, alpha: 1)
        getActiveList()
    }
    
    @IBAction func btnsidemenuAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let vcc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let sidemenu
            = SideMenuNavigationController(rootViewController: vcc)
        sidemenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        present(sidemenu,animated: true)
    }
    
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOpenQuoteAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestforQuatationVC") as! RequestforQuatationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnYourActiveAction(_ sender: Any) {
    }
}
//MARK:- TableView Delegate & DataSource Method(s)
//MARK:-
extension ActiveQuoteVC :  UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequestProduct?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveQuoteTableViewCell") as! ActiveQuoteTableViewCell
        cell.onClickView = { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "QuoteDetailVC") as! QuoteDetailVC
            vc.data = cell.data 
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let data = self.arrRequestProduct?[indexPath.row ]
        cell.data = data
        self.requestid = data?.request_id
//        self.id       = data?.id
        self.vendorID = data?.vendor_id ?? ""
        self.rs_vendor_id = data?.rs_vendor_id ?? ""
        cell.onClickWithdraw = { [weak self] in
            self?.id = data?.id ?? ""
            self?.getWithDrawList()
        }
        return cell
        
    }
}

//MARK:- API Calling To Active(s)
//MARK:-
extension ActiveQuoteVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txttype?.text ?? ""
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

//MARK:- API Calling To Withdraw(s)
//MARK:-
extension ActiveQuoteVC{
    func getAll() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_quotes_id"] = self.id
        print(dictparam)
        return dictparam
        
    }
    func getWithDrawList(){
        let param = getAll()
        objWebServiceManager.requestPost(strURL: withDrawRequest, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseRequestforquatation>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                   
                    self.getActiveList()
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
extension ActiveQuoteVC: UIPickerViewDelegate,UIPickerViewDataSource{
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
            txttype?.text = added[row]
            txttype?.resignFirstResponder()
            self.getActiveList()
        default:
            return
        }
    }
}
