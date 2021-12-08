//
//  AllOrderVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class AllOrderVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnFind: UIButton!
    @IBOutlet weak var txtFilter: UITextField!
    var arrList: [Productlist?]?
    let filter = ["All","processing","complete","cancel"]
    //let filter = ["All","1","2","3"]
    var orderID = ""
    
    var filterPickerview = UIPickerView()
//    var temp : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFilter.delegate     = self
        txtFilter.inputView = filterPickerview
        txtFilter.textAlignment = .natural
        filterPickerview.delegate = self
        filterPickerview.dataSource = self
        filterPickerview.tag = 1
        self.webServiceCallingToAllOrder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSideMenuAction(_ sender: Any) {
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
//MARK:- Tableview DElegate & Datasource Method(s)
//MARK:-
extension AllOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrList?.count ?? 0)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllOrdeCell") as! AllOrdeCell
        let data = self.arrList?[indexPath.row ]
        cell.data = data
        cell.onClicChatAction = {[weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChattVC") as! ChattVC
            cell.data = data
             vc.orderId = data?.order_id ?? ""
            vc.orderStatus = data?.order_status ?? ""
            vc.Productname = data?.product_name ?? ""
            vc.CustomerType = data?.customer_id ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.onClicPdfAction = {[weak self] in
            let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OpenPDFViewVC") as! OpenPDFViewVC
            vc.pdfUrl = data?.pdf_name
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
}

//MARK:- API Calling To AllList
//MARK:-
extension AllOrderVC{
    func getAllParameters() -> [String:Any] {
       
        var dictparam = [String:Any]()
        //dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["filter_type"] = self.txtFilter.text ?? ""
        
        print(dictparam)
        return dictparam
        
    }
    func webServiceCallingToAllOrder(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: All_order, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductlistHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    self.arrList = model.alllist
                    self.tblVw.reloadData()//Success
                    
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
extension AllOrderVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return filter.count
            
            
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return filter[row]
            
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtFilter.text = filter[row]
            txtFilter.resignFirstResponder()
            self.webServiceCallingToAllOrder()
        default:
            return
        }
    }
}
