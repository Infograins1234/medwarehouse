//
//  SearchStockVC.swift
//  MedWarehouse
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
import SKCountryPicker

//MARK:- Class Action(s)
//MARK:-
class Product : Mappable {
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        self.product_name <- map["product_name"]
        self.quantity <- map["quantity"]
    
    }
    
    var product_name : String?
    var quantity : String?
    init(product_name: String, quantity: String) {
        self.product_name = product_name
        self.quantity = quantity
    }
}
class ProductOrder : Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.productOrder <- map["product_id"]
        self.quantity <- map["quantity"]
    }
    
    var productOrder : String?
    var quantity : String?
    init(product_id: String, quantity: String) {
        self.productOrder = product_id
        self.quantity = quantity
    }
}
class SearchStockVC: UIViewController {
    
    //MARK:- IBoutlet Action(s)
    //MARK:-
    @IBOutlet weak var txtGlobalSearch: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnFind: UIButton!
    @IBOutlet weak var tblvVW: UITableView!
    @IBOutlet weak var tbladdvVW: UITableView!
    @IBOutlet weak var btnGenerateOrder : UIButton?
    @IBOutlet weak var uiVwTblVw: UIView!
    @IBOutlet weak var uiVwSearchName: UIView!
    
    //MARK:- Variable Action(s)
    //MARK:-
    lazy var arrSelectedUser: [RideHistory?] = []
    var number = Int()
    var arrProductName : [Product] = [Product(product_name: "", quantity: "")]
    var arrProductOrder : [ProductOrder] = []
    var productname = ""
    var quantity = ""
    var productOrder : String?
    var productID : String?
    var arrProduct : [RideHistory?]?
    var arrFilterProduct : [RideHistory?]?
    var searching = false
    let Global = ["Global","Africa","Asia","Europe","North America","South America","Oceania","European Union","Middle East"]
    var globalPickerview = UIPickerView()
    var countryPickerView = UIPickerView()
    var country = ["Default","Afghanistan","Albania","Algeria","Andorra Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Austrian Empire"," Azerbaijan","Baden"," Bahamas","Bahrain","Bangladesh","Barbados","Bavaria"," Belarus","Belgium","Belize","Benin","Bolivia","Bosnia","Herzegovina","Botswana","Brazil","Brunei","Brunswick","Lüneburg","Bulgaria","Burkina Faso","Burma","Burundi","Cabo Verde","Cambodia","Cameroon"," Canada","Cayman Islands","Central African Republic","Central American Federation"," Chad"," Chile","China"," Colombia"," Comoros","Congo Free State"," Costa Rica"," Cote d’Ivoire","Croatia","Cuba"," Cyprus","  Czechia","Czechoslovakia","Democratic Republic of the Congo","Denmark","Djibouti","Dominica","Dominican Republic","Duchy of Parma","East Germany"," Ecuador","Egypt"," El Salvador","Equatorial Guinea","Eritrea","Estonia","Eswatini","Ethiopia","Federal Government of Germany","Fiji","Finland","France","Gabon"," Gambia","Georgia","Germany","Ghana","Grand Duchy of Tuscany","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Hanover","Hanseatic Republics","Hawaii","Hesse","Holy See","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel"," Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya"," Kingdom of Serbia/Yugoslavia","Kiribati","Korea","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Lew Chew","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mecklenburg-Schwerin","Mecklenburg-Strelitz","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Namibia","Nassau","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North German Confederation","North German Union","North Macedonia","Norway","Oldenburg","Oman","Orange Free State","Pakistan","Palau","Panama","Papal States","Papua New Guinea","Paraguay","Peru","Philippines"," Piedmont-Sardinia","Poland","Portugal","Qatar","Republic of Genoa"," South Korea"," Republic of the Congo","Romania"," Russia","Rwanda"," Saint Kitts and Nevis"," Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe"," Saudi Arabia"," Schaumburg-Lippe","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia"," Solomon Islands","Somalia"," South Africa","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Sweden","Switzerland","Syria","Tajikistan","Tanzania","Texas","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Two Sicilies","Uganda","Ukraine","Union of Soviet Socialist Republics","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Vanuatu","Venezuela","Vietnam","Württemberg","Yemen","Zambia","Zimbabwe"]
    var temp =  ""
    
    //MARK:- View Life Cycle Method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        country.insert("", at: 0)
        tbladdvVW.delegate = self
        tbladdvVW.dataSource = self
        btnGenerateOrder?.layer.cornerRadius = 12
        btnFind.layer.cornerRadius = 10
        txtGlobalSearch.inputView = globalPickerview
        txtCountry.inputView = countryPickerView
        txtCountry.textAlignment = .natural
        txtGlobalSearch.textAlignment = .natural
        globalPickerview.delegate = self
        globalPickerview.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        globalPickerview.tag = 1
        countryPickerView.tag = 2
        self.uiVwSearchName.isHidden = true
        self.btnGenerateOrder?.isHidden = true
        
    }
    func isValidate() -> ( Bool,Bool) {//(product name, quantity)
        for obj in self.arrProductName {
            if obj.product_name?.isEmpty ?? true {
                return (false,false)
            } else if obj.quantity?.isEmpty ?? true {
                return (true,false)
            }
        }
        return (true,true)
    }
    
}

//MARK:- Delegate & Datasource Metod(s)
//MARK:-
extension SearchStockVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        if tableView == tbladdvVW {
            return arrProductName.count
        } else  {
            return arrProduct?.count ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbladdvVW {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStockTableViewCell") as! SearchStockTableViewCell
            cell.onClickCancelAction = {[weak self] in
                if ((self?.arrProductName.count ?? 1) != 1)  {
                    self?.arrProductName.remove(at: 1)
                    self?.tbladdvVW.reloadData()
                }
            }
            cell.onChangeProductInfoAction = { [weak self] productData in
                self?.arrProductName[indexPath.row] = productData
            }
            cell.medicalProductName = self.arrProductName[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
            let data = self.arrProduct?[indexPath.row]
            cell.data = data
            if self.arrSelectedUser.map({$0?.id}).contains(data?.id) {
               
                cell.btncheck?.setImage(UIImage(named: "Untitled-1"), for: .normal)
            }else {
                cell.btncheck?.setImage(UIImage(named: "check-box"), for: .normal)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrProduct?[indexPath.row]
        if let index = self.arrSelectedUser.map({$0?.id}).firstIndex(of: data?.id) {
           self.arrSelectedUser.remove(at: index)
           self.arrProductOrder.remove(at: index)
        }else {
            self.arrSelectedUser.append(data)
            self.arrProductOrder.append(ProductOrder(product_id: data?.id ?? "", quantity: data?.quantity ?? ""))
        }
        tableView.reloadData()
        
    }
}
//MARK:-
//MARK:- 
extension SearchStockVC {
    @IBAction func btnaddAction(_ sender : Any) {
        let addAction = Product(product_name: "", quantity: "")
        self.arrProductName.append(addAction)
        self.tbladdvVW.reloadData()
    }
    @IBAction func btnFindSearchAction(_ sender: Any) {
        
        let validate = self.isValidate()
        if !validate.0 {
            // self.show Please enter product name - ye message display krwao yah
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Product  Name", controller: self)
            
        } else if !validate.1 {
            //Please enter quantity - ye show krwao
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the quantity", controller: self)
        } else {
            self.weServiceCallingTSearchProductList()
        }
        self.arrProduct?.removeAll()
        self.tblvVW.reloadData()
    }
    
    @IBAction func btnGenerateOrderAction(_ sender : Any){
        self.weServiceCallingToGenerateOrder()
        
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

//MARK:- API Calling To SearchStock(s)
//MARK:-
extension SearchStockVC{
    func getAllParameter() -> [String:Any] {
        if self.txtCountry.text == "Default" {
            temp = ""
        } else if  self .txtCountry.text == txtCountry.text{
            self.txtCountry.text = temp
        }
        var dictparam = [String:Any]()
        dictparam["id"] = ApplicationPreference.shared.getUserData().id
        dictparam["country"] =  temp
        dictparam["search"] = self.arrProductName.toJSONString()
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingTSearchProductList(){
        let param = getAllParameter()
        objWebServiceManager.requestPost(strURL: search_stock, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //Success
                    self.arrProduct = model.rideHistory
                    self.productID = model.rideHistory?.first?.id ?? ""
                    self.uiVwSearchName.isHidden = false
                    self.tbladdvVW.isHidden = false
                    self.productOrder = model.rideHistory?.first?.id ?? ""
                    self.quantity = model.rideHistory?.first?.quantity ?? ""
                    self.tblvVW.reloadData()
                    //                    self.uiVwTblVw.isHidden = false
                    self.btnGenerateOrder?.isHidden = false
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}

//MARK:- API Calling To GenerateOrder(s)
//MARK:-
extension SearchStockVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["product"] = arrProductOrder.toJSONString()
        print(dictparam)
        return dictparam
        
    }
    func weServiceCallingToGenerateOrder(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: multipleOrder, params: param, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<AllProductHistoryResponse>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    let storyboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
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

////MARK :- Uisearchbar Delegate Method(s)
////MARK -
//extension SearchStockVC : UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        arrFilterProduct = self.arrProduct?.filter({($0?.name?.lowercased().contains(searchText.lowercased()))!})
//        searching = true
//        self.tblvVW.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
//}

//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension SearchStockVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Global.count
        case 2:
            return country.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Global[row]
        case 2:
            return country[row]
        default:
            return "Data not found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txtGlobalSearch.text = Global[row]
            txtGlobalSearch.resignFirstResponder()
        case 2:
            txtCountry.text = country[row]
            txtCountry.resignFirstResponder()
        default:
            return
        }
    }
}

