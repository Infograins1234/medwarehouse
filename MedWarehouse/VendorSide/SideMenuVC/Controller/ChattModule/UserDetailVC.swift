//
//  UserDetailVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 18/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
class UserDetailVC: UIViewController {
    //MARK:- IBOutlet(s)
    //MARK:-
    @IBOutlet weak var tblDetail : UITableView?
    
    //MARK:- Variable(s)
    //MARK:-
    var arrRecieveUserlist: [GetUserlist?]?
    var orderId = ""
    var orderDate = ""
    var orderStatus = ""
    var Productname = ""
    var ProductAvability = ""
    var CustomerType = ""
    
    //MARK:- View Life Cycles(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDetail?.rowHeight = 44
        tblDetail?.estimatedRowHeight = UITableView.automaticDimension
        self.getUserlist()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Tableview Delegate & Datasource(s)
//MARK:-
extension UserDetailVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrRecieveUserlist?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as! UserDetailTableViewCell
        let data = self.arrRecieveUserlist?[indexPath.row ]
        cell.data = data
        
        cell.onClickNextAction =  { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChattVC") as! ChattVC
            vc.orderId = data?.order_id ?? ""
            vc.orderDate = data?.order_date ?? ""
            vc.orderStatus = data?.order_status ?? ""
            vc.orderId = data?.order_id ?? ""
            vc.CustomerType = data?.custoer_type ?? ""
            vc.Productname = data?.product_name ?? ""
            vc.ProductAvability = data?.product_availability ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK:- Api method(s)
//MARK;-
extension UserDetailVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        print(dictparam)
        return dictparam
    }
    
    func getUserlist(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: Userlist, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseUserlist>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    self.arrRecieveUserlist = model.data
                    self.tblDetail?.reloadData()
                    
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
