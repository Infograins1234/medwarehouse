//
//  QuatationSubmissionVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 26/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
class QuoteSubmit : Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.product_name  <- map["product_name"]
        self.quantity      <- map["quantity"]
        self.deliveryDate  <- map["delivered_by"]
        self.price_unit    <- map["price_unit"]
        self.message       <- map["message"]
        self.request_items_id   <- map["request_items_id"]
        self.request_id    <- map["request_id"]
        self.currency      <- map["currency"]
    }
    var price_unit : String?
    var deliveryDate : String?
    var product_name : String?
    var quantity : String?
    var message : String?
    var request_items_id : String?
    var request_id : String?
    var currency : String?
    init(product_name: String, quantity: String,priceperUnit: String, deliveryDate : String, message : String, request_id:String , request_items_id : String, currency : String) {
        self.product_name = product_name
        self.quantity = quantity
        self.price_unit = priceperUnit
        self.deliveryDate = deliveryDate
        self.message  = message
        self.request_id = request_id
        self.request_items_id = request_items_id
        self.currency = currency
    }
}

class QuatationSubmissionVC: UIViewController {
    //MARK:- Ibaction Method(s)
    //MARK:-
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tfMsg: UITextField!
    @IBOutlet weak var tfPriceTotal: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    var arrData : [ResQuoteSubmitModel?] = []
    lazy var arrSelectedUsers: [ResQuoteSubmitModel?] = []
    var arrqutationSubmitData : [QuoteSubmit] = []
    var productname = ""
    var quantity = ""
    var priceperUnit = ""
    var deliveryDate = ""
    var message = ""
    var requestid = ""
    var requestItemid = ""
    var id : String?
    var notes : String?
    var VendorID : String?
    var rs_vendor_id : String?
    var quantityShow : String?
    var priceShow : String?
    var data: GetRequestModel?
    //MARK:- ViewLife Cycle Method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnSubmit.layer.cornerRadius = 10
        webServiceToQuoteSubmissionDetail()
        
    }
    func getTotal() {
        
    }
    @IBAction func btnsideMenuAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnsubmitAction(_ sender: Any) {
        self.webServicecallingToSubmitQuote()
    }
}

//MARK:- TableView Delegate & DataSource Method(s)
//MARK:-
extension QuatationSubmissionVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuatationTableViewCell") as! QuatationTableViewCell
        cell.isUserInteractionEnabled = true
        let data = self.arrData[indexPath.row]
        cell.data = data
      
        if self.arrSelectedUsers.map({$0?.request_items_id}).contains(data?.request_items_id) {
            cell.btnCheck?.setImage(UIImage(named: "Untitled-1"), for: .normal)
        }else {
            cell.btnCheck?.setImage(UIImage(named: "check-box"), for: .normal)
        }
        cell.onChangeProductInfoAction = { [weak self] prodInfo in
            self?.arrData[indexPath.row]?.quantity = prodInfo.quantity
            self?.arrData[indexPath.row]?.price_unit = prodInfo.price_unit
            if let index = self?.arrqutationSubmitData.map({$0.request_items_id}).firstIndex(of: data?.request_items_id ?? "") {
                self?.arrqutationSubmitData[index].quantity = prodInfo.quantity
                self?.arrqutationSubmitData[index].price_unit = prodInfo.price_unit
            }
            
        }
         // cell.quoteSubmitProductName = self.arrqutationSubmitData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrData[indexPath.row]
        if let index = self.arrSelectedUsers.map({$0?.request_items_id}).firstIndex(of: data?.request_items_id ?? "") {
            self.arrSelectedUsers.remove(at: index)
            self.arrqutationSubmitData.remove(at: index)
        }else {
            self.arrSelectedUsers.append(data)
            self.arrqutationSubmitData.append(QuoteSubmit(product_name: data?.description ?? "", quantity: data?.quantity ?? "", priceperUnit: self.priceperUnit, deliveryDate: data?.delivery_date ?? "", message: tfMsg.text ?? "", request_id: data?.request_items_id ?? "", request_items_id: data?.request_items_id ?? "",currency : ""))
        }
        
        tblVw.reloadData()
    }
}

//MARK:- API Calling To getActiveList(s)
//MARK:-
extension QuatationSubmissionVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = data?.request_id
        dictparam["rs_vendor_id"] = data?.rs_vendor_id
        print(dictparam)
        return dictparam
        
    }
    func webServiceToQuoteSubmissionDetail(){
        let params = getAllParam()
        objWebServiceManager.requestPost(strURL: request_for_quotation_data_detail, params: params, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseQuatatSubmitModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrData = model.data!
                    self.tblVw.reloadData()
                    self.lblDescription.text = model.notes
                    
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}

//MARK:- API Calling To webServicecallingToSubmitQuote(s)
//MARK:-
extension QuatationSubmissionVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["item_name"] = self.arrqutationSubmitData.toJSONString()
        print(dictparam)
        return dictparam
        
    }
    func webServicecallingToSubmitQuote(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: request_quotes_submission, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseQuatationSubmitModel>().map(JSON: data) else {
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
