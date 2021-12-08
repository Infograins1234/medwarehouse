//
//  SideMenuVC.swift
//  MedWarehouse
//
//  Created by Apple on 26/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//


import UIKit
import SideMenu
import ObjectMapper
class SideMenuVC: UIViewController {
    
    var arrOptions : [SideMenuOptions] = [.Profile, .MyProducts, .AddProducts,.OrderRecieved,.SearchStocks,.Requeststock,.RequestforQuotation,.MyQuatation,.MyOrders,.Logout,.Message]
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblName: UILabel!
    
    //MARK:- View life cycle method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func btnbackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
//MARK:-Tableview Delegate & Datasource Methods

extension SideMenuVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        
        let option = self.arrOptions[indexPath.row]
        
        cell.imgVw.image = option.image
        cell.lblName.text = option.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.arrOptions[indexPath.row] {
        
        //
        case .Profile:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        //
        case .MyProducts:
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .AddProducts:
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case .OrderRecieved:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllOrderVC") as! AllOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .SearchStocks:
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchStockVC") as! SearchStockVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .Requeststock :
            let storyboard: UIStoryboard = UIStoryboard(name: "Request", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RequestStockVC") as! RequestStockVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .RequestforQuotation :
            let storyboard: UIStoryboard = UIStoryboard(name: "Request", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RequestforQuatationVC") as! RequestforQuatationVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .MyQuatation :
            let storyboard: UIStoryboard = UIStoryboard(name: "Request", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyQutationListVC") as! MyQutationListVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .MyOrders:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .Logout:
            self.logoutAction()
        case.Message:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestforChatVC") as! RequestforChatVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
}

enum SideMenuOptions {
    case Profile
    case MyProducts
    case AddProducts
    case OrderRecieved
    case SearchStocks
    case Requeststock
    case RequestforQuotation
    case MyQuatation
    case MyOrders
    case Logout
    case Message
    var title: String {
        switch self {
        case .Profile:
            return "Profile"
        case .MyProducts:
            return "My Products"
        case .AddProducts:
            return "Add Products"
        case .OrderRecieved:
            return "Order Recieved"
        case .SearchStocks:
            return "Search Stocks"
        case .Requeststock:
            return "Request Stock"
        case .RequestforQuotation:
            return "RFQ Listings"
        case .MyQuatation:
            return "Your Requests"
        case .MyOrders:
            return "My Orders"
        case .Logout:
            return "logout"
        case.Message:
            return "Message"
        }
    }
    var image: UIImage {
        switch self {
        case .Profile:
            return #imageLiteral(resourceName: "profile-user (1)")
        case .MyProducts:
            return #imageLiteral(resourceName: "prescription")
        case .AddProducts:
            return #imageLiteral(resourceName: "pills (1)")
        case .OrderRecieved:
            return #imageLiteral(resourceName: "order")
        case .SearchStocks:
            return #imageLiteral(resourceName: "search")
        case .Requeststock :
            return #imageLiteral(resourceName: "shelf")
        case .RequestforQuotation :
            return #imageLiteral(resourceName: "warehouse")
        case .MyQuatation :
            return #imageLiteral(resourceName: "quotation")
        case .MyOrders:
            return #imageLiteral(resourceName: "shopping-cart")
        case .Logout:
            return  #imageLiteral(resourceName: "logout")
        case.Message :
            return #imageLiteral(resourceName: "chat")
        }
    }
}

//MARK:- API Calling To Login
extension SideMenuVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        return dictparam
        
    }
    func webserviceCallingToLogout() {
        let params = getAllParam()
        objWebServiceManager.requestPost(strURL: logout, params: params, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    ApplicationPreference.shared.clearAllData()
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:- Logout Alert Action(s)
//MARK:-
extension SideMenuVC{
    func logoutAction() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("Yes Pressed")
            self.webserviceCallingToLogout()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("NO Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
