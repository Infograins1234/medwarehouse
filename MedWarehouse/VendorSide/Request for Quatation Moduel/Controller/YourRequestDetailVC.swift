//
//  YourRequestDetailVC.swift
//  MedWarehouse
//
//  Created by mac on 03/12/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper

class YourRequestDetailVC: UIViewController {
    //MARK:- Iboulet Method{s)
    //MARK:
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var tblVwDetail : UITableView?
    //MARK:- View LifeCycle Method{s)
    //MARK:
    var data : GetRequestModel?
    var arrData : [GetQuatationModel]?
    var requestid = ""
    var requestquoteid = ""
    var notes : String?
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
extension YourRequestDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourRequestTableViewCell") as! YourRequestTableViewCell
        let data = self.arrData?[indexPath.row ]
        cell.data = data
        cell.onClickAcceptRequest = {[weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MyQuatationVC") as! MyQuatationVC
            vc.requestid = self!.requestid
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        self.requestid = data?.request_items_id ?? ""
        self.requestquoteid = data?.request_quotes_id ?? ""
        return cell
    }
}
//MARK:- API Calling To AllList
//MARK:-
extension YourRequestDetailVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["request_id"] = data?.rt_request_id
        print(dictparam)
        return dictparam
        
    }
    func getMyQutation(){
        let param = getAllParameters()
        objWebServiceManager.requestPost(strURL: your_request_product_details, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseMyQuatationModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrData = model.data
                    self.tblVwDetail?.reloadData()
                    self.txtNotes.text = model.notes
                    
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
