//
//  ProfileVC.swift
//  MedWarehouse
//
//  Created by Apple on 27/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SideMenu
import ObjectMapper
import SDWebImage

class ProfileVC: UIViewController {
    @IBOutlet weak var uiVwCamera: UIView!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var TxtAddress: UITextField!
    @IBOutlet weak var btnUpdateSubmit: UIButton!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtAdded: UITextField!
    @IBOutlet weak var txtUpdated: UITextField!
    @IBOutlet weak var tblVw: UITableView?
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var uiVwUpdated: UIView!
    @IBOutlet weak var uiVwAdded: UIView!
    @IBOutlet weak var tablVwHeight : NSLayoutConstraint!
    var arrImageInfo: [ImageInfo] = []
    var arrImageCount:[String]?
    var strImageName :String?
    
    var isProfileUpdate: Bool?
    //MARK:- View life cycle method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.webserviceCallingToProfile()
        btnEditProfile.layer.cornerRadius = 25
        uiVwCamera.layer.cornerRadius = 30
        btnUpdateSubmit.isHidden = true
        uiVwCamera.isHidden = true
        imgVwProfile.layer.cornerRadius = imgVwProfile.frame.height/2
        self.toMakeEditable(toggle: false)
    }
    
    // Do any additional setup after loading the view.
    //MARK:- View life cycle method(s)
    //MARK:-
    func toMakeEditable(toggle:Bool) {
        self.txtName.isUserInteractionEnabled = toggle
        self.txtEmail.isUserInteractionEnabled = toggle
        self.txtCompanyName.isUserInteractionEnabled = toggle
        self.txtContact.isUserInteractionEnabled = toggle
        self.TxtAddress.isUserInteractionEnabled = toggle
        self.txtLastName.isUserInteractionEnabled = toggle
        self.txtCity.isUserInteractionEnabled = toggle
        self.txtZip.isUserInteractionEnabled = toggle
        self.txtState.isUserInteractionEnabled = toggle
        self.txtCountry.isUserInteractionEnabled = toggle
        self.txtAdded.isUserInteractionEnabled = toggle
        self.txtUpdated.isUserInteractionEnabled = toggle
        
    }
    override func  viewDidLayoutSubviews(){
        
   }
    @IBAction func btnchooseimageAction(_ sender: Any) {
        self.isProfileUpdate = false
        toSelectImageFromGallery(imageName: "")
    }
    //MARK:-
    //MARK:-
    func toSelectImageFromGallery(imageName: String?) {
        let camera = Camera(delegate_: self)
        objAppShareData.displayAlertWithHandlerwithSheetStyle(with: "Update your profile picture", message: nil, buttons: ["Camera","Gallery","Cancel","Document"], viewobj: self, buttonStyles: [.default,.default,.cancel], handler: { (selectebutton) in
            if selectebutton == "Camera"{
                camera.PresentMultyCamera(target: self, canEdit: false)
            }else if selectebutton == "Gallery"{
                camera.PresentPhotoLibrary(target: self, canEdit: false)
            } else if selectebutton == "Document" {
                let documentsPicker = UIDocumentPickerViewController(documentTypes: ["public.image", "public.jpeg", "public.png"], in: .open)
                documentsPicker.delegate = self
                documentsPicker.allowsMultipleSelection = false
                documentsPicker.modalPresentationStyle = .fullScreen
                self.present(documentsPicker, animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func btnEditProfileAction(_ sender: Any) {
        toMakeEditable(toggle: true)
        self.btnEditProfile.isHidden = true
        btnUpdateSubmit.isHidden = false
        uiVwCamera.isHidden = false
        uiVwAdded.isHidden = true
        uiVwUpdated.isHidden = true
        self.tblVw?.reloadData()
    }
    @IBAction func btnupdatePhotpCameraAction(_ sender: Any) {
        toSelectImageFromGallery(imageName: strImageName)
        self.isProfileUpdate = true
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
    @IBAction func btnUpdateProfile(_ sender: Any) {
        self.webserviceCallingToUpdateProfile()
        
    }
}

//MARK: UIImagePickerController delegate
//MARK:-
extension ProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        let video = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        print(picture as Any,"image")
        if self.isProfileUpdate ?? false {
            self.imgVwProfile.image = picture
        }else {
            self.webserviceCallingToUpdateDocument(data: picture?.jpegData(compressionQuality: 0.5) ?? Data())
            print(picture as Any,"doc")
           
            
        }
        var dictParam = [String:Any]()
        dictParam["id"] = ApplicationPreference.shared.getUserData().id
        picker.dismiss(animated: true, completion: nil)
        self.isProfileUpdate = false
    }
}
//MARK:- API Calling To Login
extension ProfileVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        return dictparam
    }
    func webserviceCallingToProfile() {
        let params = getAllParam()
        objWebServiceManager.requestPost(strURL: profile, params: params, showIndicator: true, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    //objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    self.txtEmail.text = model.data?.email
                    self.txtName.text = model.data?.first_name
                    self.txtContact.text = model.data?.company_contact
                    self.txtCompanyName.text = model.data?.company_name
                    self.TxtAddress.text = model.data?.company_address
                    self.txtLastName.text = model.data?.last_name
                    self.txtState.text = model.data?.company_state
                    self.txtCountry.text = model.data?.company_country
                    self.txtZip.text = model.data?.company_zip
                    self.txtCity.text = model.data?.company_city
                    self.txtAdded.text = model.data?.added
                    self.txtUpdated.text = model.data?.modified
                    if let strImage = model.data?.image, let url = URL(string: strImage) {
                        self.imgVwProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile-user (1)"))
                    }
                    
                    self.arrImageCount = model.data?.document_link
                    self.tblVw?.reloadData()
                    self.tablVwHeight.constant = (self.tblVw?.contentSize.height)!
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
//MARK:- API Calling To Login
extension ProfileVC{
    func getAllParameter() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["profile_image"] = "d.png"
        dictparam["first_name"] = self.txtName.text ?? ""
        dictparam["last_name"] = self.txtLastName.text ?? ""
        dictparam["company_contact"] = self.txtContact.text ?? ""
        dictparam["company_name"] = self.txtCompanyName.text ?? ""
        dictparam["city"] = self.TxtAddress.text ?? ""
        dictparam["state"] = self.txtState.text ?? ""
        dictparam["country"] = self.txtCountry.text ?? ""
        dictparam["zip"] = self.txtZip.text ?? ""
        dictparam["doc[]"] = "p.ng"
        return dictparam
        
    }
    
    func webserviceCallingToUpdateProfile() {
        let params = getAllParameter()
        let data: Data = self.imgVwProfile.image?.jpegData(compressionQuality: 0.5) ?? Data()
        objWebServiceManager.uploadImage(strUrl: updateProfile, para: params, image: [ImageInfo(data: data, name: "image")], showIndicator: true, succes: { (response) in
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return }
                if model.status == 200 {
                    self.btnUpdateSubmit.isHidden = true
                    self.toMakeEditable(toggle: false)
                    self.uiVwCamera.isHidden = true
                    self.btnEditProfile.isHidden = false
                    self.tblVw?.reloadData()
                    self.uiVwAdded.isHidden = false
                    self.uiVwUpdated.isHidden = false
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            objAppShareData.showAlertVC(title: "Alert", message: error.localizedDescription, controller: self)
        }
    }
    
}
//MARK:-
//MARK:-
extension ProfileVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrImageCount?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        let data = self.arrImageCount?[indexPath.row]
        if let imageNameArr = data?.components(separatedBy: "/"), let name = imageNameArr.last {
            cell.data = name
        }
        if self.btnEditProfile.isHidden {
            cell.uiVwChooseImage.isHidden = false
            cell.uiVwImage.isHidden = true
            
        }else {
            cell.uiVwChooseImage.isHidden = true
            cell.uiVwImage.isHidden = false
        }
        cell.onClickUpdateProfileAction = {
            if let imageNameArr = data?.components(separatedBy: "/"), let name = imageNameArr.last {
                self.strImageName = name
                self.toSelectImageFromGallery(imageName: name)
            }
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cell
//    }
}
//MARK:- API Calling To Update Profile Pic(s)
//MARK:-
extension ProfileVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["image_name"] = self.strImageName ?? ""
        print(dictparam)
        return dictparam
    }
    func webserviceCallingToUpdateDocument(data: Data) {
        let params = getAllParameters()
        objWebServiceManager.uploadImage(strUrl: updateprofilepic, para: params, image: [ ImageInfo(data: data, name: "doc", self.strImageName)], showIndicator: true, succes: { (response) in
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseLogin>().map(JSON: data) else {
                    return }
                if model.status == 200 {
                    
                }else {
                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            objAppShareData.showAlertVC(title: "Alert", message: error.localizedDescription, controller: self)
        }
    }
    
}
