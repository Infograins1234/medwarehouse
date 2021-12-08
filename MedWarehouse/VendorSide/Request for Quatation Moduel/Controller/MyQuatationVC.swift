//
//  MyQuatationVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 03/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper

class MyQuatationVC: UIViewController {
    //MARK:- Iboulet Method{s)
    //MARK:
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblCloseSubmission: UILabel!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var lblDeliveredBy: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblVwDetail : UITableView?
    //MARK:- View LifeCycle Method{s)
    //MARK:
    var data : GetRequestModel?
    var arrData : [GetQuatationModel]?
    var requestid = ""
    var requestquoteid = ""
    var notes : String?
    var price : String?
    var quantity : String?
    var delivered : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyQutation()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:-
//MARK:-
extension MyQuatationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrData?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuatationTableViewCell") as! MyQuatationTableViewCell
        let data = self.arrData?[indexPath.row ]
        cell.data = data
        cell.lblStatus.text = data?.status
        if cell.lblStatus.text == "accepted"{
            cell.txtPrice?.isEnabled = false
            cell.txtQuantity?.isEnabled = false
            cell.txtDilevered?.isEnabled = false
            cell.btnAccept.isEnabled = false
            cell.btnCounterOffer.isEnabled = false
        } else {
            cell.txtPrice?.isEnabled = true
            cell.txtQuantity?.isEnabled = true
            cell.txtDilevered?.isEnabled = true
            cell.btnAccept.isEnabled = true
            cell.btnCounterOffer.isEnabled = true
        }
        cell.onClickAcceptRequest = {[weak self] in
            self?.webServiceCallingToAcceptRequest()
        }
        cell.onClickCounter = {[weak self] in
            self?.getCounterDataUpdate()
        }
        cell.onClickChatAction = { [weak self] in
            let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChattVC") as! ChattVC
            vc.orderId = self!.requestid
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.requestid = data?.request_id ?? ""
        self.requestquoteid = data?.request_quotes_id ?? ""
        return cell
    }
}
//MARK:- API Calling To AllList
//MARK:-
extension MyQuatationVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = self.requestid
        print(dictparam)
        return dictparam
        
    }
    func getMyQutation(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: myqutation, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseMyQuatationModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrData = model.data
                    self.tblVwDetail?.reloadData()
                    self.txtNotes.text = model.notes
                    self.lblQuantity.text = model.data?.first?.rt_quantity
                    self.lblDescription.text = model.data?.first?.rt_description
                    if let arr = model.data?.first?.rt_delivery_date?.components(separatedBy: " "), let date = arr.first {
                        self.lblDeliveredBy?.text = date
                    }else {
                        self.lblDeliveredBy?.text = ""
                    }
                    if let arr = model.data?.first?.rt_closing_date?.components(separatedBy: " "), let date = arr.first {
                        self.lblCloseSubmission?.text = date
                    }else {
                        self.lblCloseSubmission.text = ""
                    }
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
extension MyQuatationVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = self.requestid
        dictparam["request_quotes_id"] = self.requestquoteid
        print(dictparam)
        return dictparam
        
    }
    func webServiceCallingToAcceptRequest(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: acceptVendorRequest, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseMyQuatationModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //Success
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

//MARK:- API Calling To CounterUpdate(s)
//MARK:-
extension MyQuatationVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = self.requestid
        dictparam["delivery_by"] = self.delivered
        dictparam["price_per_unit"] = self.price
        dictparam["quantity"] = self.quantity
        print(dictparam)
        return dictparam
        
    }
    func getCounterDataUpdate(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: request_quotes_counter_offer_update, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseQuoteslModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
//                    self.lblMsgNotification?.isHidden = false
//                    self.lblCounterOffer?.text = "Counter Offer"
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestforQuatationVC") as! RequestforQuatationVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
