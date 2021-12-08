//
//  MyOrderVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class MyOrderVC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var txtFilter : UITextField?
    
    var arrList: [Orderlist?]?
    var cellHeights = [IndexPath: CGFloat]()
    var arrData: [productdetail?]?
    var arrIndexPath : [Int]?
    let filter = ["oldest","newest","completed"]
    var filterPickerview = UIPickerView()
    var dismissPopupView:(() ->()) = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weServiceCallingToMYOrder()
        txtFilter?.inputView = filterPickerview
        txtFilter?.textAlignment = .natural
        filterPickerview.delegate = self
        filterPickerview.dataSource = self
        filterPickerview.tag = 1
        
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
//MARK:-
//MARK:-
extension MyOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList?[section]?.productlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell") as! MyOrderCell
        let orderData = arrList?[indexPath.section]
        let productData = orderData?.productlist?[indexPath.row]
        cell.data = orderData
        cell.lblName.text = productData?.product_name
        cell.lblSellerCompanyName.text = productData?.seller_company_name
        cell.lblOrderNo.text = productData?.product_id
        cell.onClickPdfAction = { [weak self] in
            let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OpenPDFViewVC") as! OpenPDFViewVC
                       vc.pdfUrl = orderData?.pdf_name
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.onClickHideAction = { [weak self] in
            if cell.uiVwDetails.tag == 0 {
                cell.uiVwDetails.tag = 1
                cell.uiVwDetails.isHidden = true
                self?.tblVw.reloadData()
            }
            else if cell.uiVwDetails.tag == 1 {
                cell.uiVwDetails.tag  = 0
                cell.uiVwDetails.isHidden = false
                self?.tblVw.reloadData()
            }
        }
        cell.onClickChatAction = {[weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChattVC") as! ChattVC
            vc.data = orderData
            vc.orderId = orderData?.productlist?.first?.order_id ?? ""
            vc.orderStatus = orderData?.productlist?.first?.order_status ?? ""
            vc.orderDate = orderData?.productlist?.first?.order_date ?? ""
            vc.Productname = orderData?.productlist?.first?.product_name ?? ""
            vc.ProductAvability = orderData?.productlist?.first?.product_availability ?? ""
            vc.CustomerType = orderData?.customer_id ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

//MARK:- API Calling To AllList
//MARK:-
extension MyOrderVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["page"] = "1"
        dictparam["sort_by"] = self.txtFilter?.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToMYOrder(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: my_order, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductMyOrderResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    
                    self.arrList = model.alllist
                    self.tblVw.reloadData()
                    //Success
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:-
//MARK:-
extension MyOrderVC: UIPickerViewDelegate,UIPickerViewDataSource{
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
            txtFilter?.text = filter[row]
            txtFilter?.resignFirstResponder()
            self.arrList?.removeAll()
            self.weServiceCallingToMYOrder()
        default:
            return
        }
    }
    
}
