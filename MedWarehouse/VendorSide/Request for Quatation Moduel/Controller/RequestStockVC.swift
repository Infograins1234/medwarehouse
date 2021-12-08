//
//  RequestStockVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 25/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class ProductDate : Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.product_name <- map["product_name"]
        self.quantity <- map["quantity"]
        self.deliveryDate <- map["delivered_by"]
        self.closeSubmission <- map["closing_date"]
    }
    var closeSubmission : String?
    var deliveryDate : String?
    var product_name : String?
    var quantity : String?
    init(product_name: String, quantity: String,closeofSubmission: String, deliveryDate : String) {
        self.product_name = product_name
        self.quantity = quantity
        self.closeSubmission = closeofSubmission
        self.deliveryDate = deliveryDate
    }
}

class RequestStockVC: UIViewController {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var btnSubmitRequest: UIButton!
    @IBOutlet weak var txtMsg: UITextField?
    @IBOutlet weak var tblVw: UITableView!
    
    //MARK:- Variable Action(s)
    //MARK:-
    var number = Int()
    var arrProductDateEnquiry : [ProductDate] = [ProductDate(product_name: "", quantity: "", closeofSubmission: "", deliveryDate: "")]
    var productname = ""
    var quantity = ""
    var closeofSubmission : Int?
    var deliveryDate : Int?
    
    //MARK:- View LifeCycle Method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtMsg?.adjustsFontSizeToFitWidth
        btnSubmitRequest.layer.cornerRadius = 12
    }
    func isValidate() -> ( Bool,Bool) {//(product name, quantity)
        for obj in self.arrProductDateEnquiry {
            if obj.product_name?.isEmpty ?? true {
                return (false,false)
            } else if obj.quantity?.isEmpty ?? true {
                return (true,false)
            }
        }
        return (true,true)
    }

    @IBAction func btnSubmitRequest(_ sender: Any) {
        let validate = self.isValidate()
        if !validate.0 {
            // self.show Please enter product name - ye message display krwao yah
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Product  Name", controller: self)

        } else if !validate.1 {
            //Please enter quantity - ye show krwao
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the quantity", controller: self)
        } else {
            self.weServiceCallingToRequestStock()
        }
    }
    
    @IBAction func btnclickSubmitAction(_ sender: Any) {
        
    }
    @IBAction func btnaddAction(_ sender: Any) {
        let addAction = ProductDate(product_name: "", quantity: "",closeofSubmission: "",deliveryDate: "")
        self.arrProductDateEnquiry.append(addAction)
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

//MARK:- TableView Delegate & datasource Action(s)
//MARK:-
extension RequestStockVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductDateEnquiry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestStockTblViewCell") as! RequestStockTblViewCell
        cell.onClickCancelAction = { [weak self] in
            if ((self?.arrProductDateEnquiry.count ?? 1) != 1)  {
                self?.arrProductDateEnquiry.remove(at: 1)
                self?.tblVw.reloadData()
            }
        }
        cell.onChangeProductInfoAction = { [weak self] productData in
            self?.arrProductDateEnquiry[indexPath.row] = productData
        }
        cell.medicalProductName = self.arrProductDateEnquiry[indexPath.row]
        return  cell
    }
}
//MARK:- API Calling To SearchStock(s)
//MARK:-
extension RequestStockVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["item_name"] = self.arrProductDateEnquiry.toJSONString()
        dictparam["request_note"] = self.txtMsg?.text ?? ""
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToRequestStock(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: request_stock, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}

