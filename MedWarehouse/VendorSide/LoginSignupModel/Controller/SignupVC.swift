//
//  SignupVC.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import GooglePlaces
import GoogleMaps
class SignupVC: UIViewController {
    //MARK:- IBOUTLET ACTION(S)
    //MARK:-
    @IBOutlet weak var imgVwlogo: UIImageView!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtManufacture: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtCompanyContact: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var lblImgMsg: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnmanufacture: UIButton!
    @IBOutlet weak var btnImagePic: UIButton!
    @IBOutlet weak var btneye1: UIButton!
    @IBOutlet weak var btneye2: UIButton!
    @IBOutlet weak var lblImagepic: UILabel!
    var strLat = ""
    var strLong = ""
    var pickerData = ["Manufacture","WholeSealer","Broker"]
    var arrImageInfo: [ImageInfo] = []
    var iconClick = true
    //MARK:- VIEW LIFE CYCLE METHOD(S)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnSignup.layer.cornerRadius = 25
        let pickerVw = UIPickerView()
        pickerVw.delegate = self
        txtManufacture.inputView = pickerVw
    }
    
  
    func toSelectImageFromGallery() {
        let camera = Camera(delegate_: self)
        objAppShareData.displayAlertWithHandlerwithSheetStyle(with: "Update your profile Document", message: nil, buttons: ["Camera","Gallery","Cancel",""], viewobj: self, buttonStyles: [.default,.default,.cancel], handler: { (selecteutton) in
            if selecteutton == "Camera"{
                camera.PresentMultyCamera(target: self, canEdit: false)
            }else if selecteutton == "Gallery"{
                camera.PresentPhotoLibrary(target: self, canEdit: true)
            }
        })
    }
    @IBAction func btnimagepicAction(_ sender: Any) {
        self.toSelectImageFromGallery()
    }
    @IBAction func btnTxtAddress(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func iconAction(sender: UIButton) {
            if(iconClick == true) {
                sender.isSelected = true
                txtPassword.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                txtPassword.isSecureTextEntry = true
            }

            iconClick = !iconClick
        }
    @IBAction func iconsAction(sender: UIButton) {
        if(iconClick == true) {
            sender.isSelected = true
            txtConfirmPassword.isSecureTextEntry = false
        } else {
            sender.isSelected = false
            txtConfirmPassword.isSecureTextEntry = true
        }

        iconClick = !iconClick
        }
}
//MARK:- Image Pic stufs here(s)
//MARK:-
extension SignupVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: UIImagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(picture as Any,"doc[]")
    //        self.arrImageInfo.append(picture)
          //  self.arrImageInfo.append(ImageInfo(image: picture, name: "doc[]")
            self.lblImgMsg.text = String("\(arrImageInfo.count) file selected")
            var dictParam = [String:Any]()
            dictParam["id"] = ApplicationPreference.shared.getUserData().id
        }
        picker.dismiss(animated: true, completion: nil)
    }
   
}
//MARK:- BUTTON ACTION(s)
//MARK:-
extension SignupVC{
    @IBAction func btnclickManufacture(_ sender: Any) {
    }
   
    @IBAction func btnclickSignup(_ sender: Any) {
        if self.isValidation() {
            self.webServiseCallingToRegister()
        }
    }
    @IBAction func btnclickLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - PickerView Delegate & Datasource Method(s)
//Mark:-
extension SignupVC: UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtManufacture.text = pickerData[row]
    }
}

//MARK :- Validation in Textfield
//MARK:-
extension SignupVC{
    func isValidation() -> Bool {
        guard self.txtFirstName.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the First Name", controller: self)
            return false
        }
        guard self.txtLastName.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Last Name", controller: self)
            return false
        }
        guard self.txtEmail.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Email", controller: self)
            return false
        }
        guard objAppShareData.objValidation.isValidEmail(with: self.txtEmail.text!) else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the valid  Email", controller: self)
            return false
        }
        guard self.txtManufacture.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Manufacture", controller: self)
            return false
        }
        guard self.txtPassword.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Password", controller: self)
            return false
        }
        guard objAppShareData.objValidation.passwordShouldHave(strPwd: self.txtPassword.text ?? "") else {
            objAppShareData.showAlertVC(title: "Alert", message: "Password should be at least 8 characters in length and should include at least one upper case letter, one number and one special character." , controller: self)
            return false
        }
        guard self.txtConfirmPassword.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Confirm Password", controller: self)
            return false
        }
        guard self.txtPassword.text == self.txtConfirmPassword.text else {
            objAppShareData.showAlertVC(title: "Alert", message: "Password did not Match", controller: self)
            return false
        }
        guard self.txtCompanyName.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Company Name", controller: self)
            return false
        }
        
        guard self.txtCompanyContact.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Company Contact", controller: self)
            return false
        }
        guard self.txtAddress.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Address", controller: self)
            return false
        }
        guard self.txtCity.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the City", controller: self)
            return false
        }
        guard self.txtState.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the State", controller: self)
            return false
        }
        guard self.txtZip.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Zip", controller: self)
            return false
        }
        guard self.txtCountry.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please enter the Country", controller: self)
            return false
        }
        guard self.lblImgMsg.text != "" else {
            objAppShareData.showAlertVC(title: "Alert", message: "Please Select the Document", controller: self)
            return false
        }

        return true
    }
}

extension SignupVC{
    func getAllParam() -> [String:Any] {
        var dicparam = [String:Any]()
        dicparam["first_name"] = self.txtFirstName.text ?? ""
        dicparam["last_name"] = self.txtLastName.text ?? ""
        dicparam["email"] = self.txtEmail.text ?? ""
        dicparam["role"] = "vendor"
        dicparam["password"] = self.txtPassword.text ?? ""
        dicparam["original_password"] = self.txtConfirmPassword.text ?? ""
        dicparam["company_name"] = self.txtCompanyName.text ?? ""
        dicparam["company_contact"] = self.txtCompanyContact.text ?? ""
        dicparam["type"] = self.txtManufacture.text ?? ""
        dicparam["city"] = self.txtCity.text ?? ""
        dicparam["state"] = self.txtState.text ?? ""
        dicparam["country"] = self.txtCountry.text ?? ""
        dicparam["zip"] = self.txtZip.text ?? ""
        dicparam["device_id"] = "213"
        dicparam["device_name"] = "ios"
        dicparam["langitude"] = "22.75"
        dicparam["longitude"] = "75.00"
        dicparam["confirmation_code"] = "sss"
        dicparam["address"] = self.txtAddress.text ?? ""
        
        print(dicparam)
        return dicparam
    }
    func webServiseCallingToRegister() {
        
        let params = getAllParam()
        objWebServiceManager.uploadImage(strUrl: signup, para: params, image: arrImageInfo, showIndicator: true, succes: { (response) in
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    objAppShareData.showAlertVC(title: "Alert", message:model.message!, controller: self)
                } else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            objAppShareData.showAlertVC(title: "Alert", message: error.localizedDescription, controller: self)
        }
        
        
    }
}
//MARK:- GMSAutocompleteViewControllerDelegate
//MARK:-
extension SignupVC:GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.strLat = "\(place.coordinate.latitude)"
        self.strLong = "\(place.coordinate.longitude)"
        txtAddress.text = place.formattedAddress
        
                let postalCode = place.addressComponents?.filter({$0.types.first == "postal_code"}).first?.name
                self.txtZip.text  = postalCode
                let country = place.addressComponents?.filter({$0.types.first == "country"}).first?.name
                self.txtCountry.text = country
        let state = place.addressComponents?.filter({$0.types.first == "administrative_area_level_1"}).first?.name
        self.txtState.text = state
        
        let city = place.addressComponents?.filter({$0.types.first == "administrative_area_level_2"}).first?.name
        self.txtCity.text = city
        let address = place.name
        print("adress is \(address)")
        self.dismiss(animated: true){
            
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //self.showAnnouncement(withMessage: error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
