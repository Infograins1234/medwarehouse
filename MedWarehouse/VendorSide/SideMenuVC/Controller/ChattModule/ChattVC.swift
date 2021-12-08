//
//  ChattVC.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 11/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper


class ChattVC: UIViewController, UITextViewDelegate  {
    
    //MARK:- IBOutlet(s)
    //MARK:-
    @IBOutlet weak var tblVwComment: UITableView?
    @IBOutlet weak var txtVwComment: UITextView?
    @IBOutlet weak var imgVwUser: UIImageView?
    @IBOutlet weak var btnSend: UIButton?
    @IBOutlet weak var lblName : UILabel?
    //MARK:- Var(s)
    //MARK:-
    //var arrComment = [GetChatModel]()
    var arrRecieveMessage: [GetRecieveChatModel?]?
    var timer: Timer?
    var data: Orderlist?
    var orderId = ""
    var orderDate = ""
    var orderStatus = ""
    var Productname = ""
    var ProductAvability = ""
    var CustomerType = ""
    var activityId: String?
    var arrImageInfo: [ImageInfo] = []
    //MARK:- View life cycle method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwComment?.rowHeight = 44
        tblVwComment?.estimatedRowHeight = UITableView.automaticDimension
        tblVwComment?.clipsToBounds = true
        txtVwComment?.delegate = self
        tblVwComment?.delegate = self
        tblVwComment?.dataSource = self
        self.getCommentList()
        txtVwComment?.layer.cornerRadius = 10
        txtVwComment?.layer.borderWidth = 2
        txtVwComment?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.getCommentList()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (apiTimer) in
            self.getCommentList()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        
    }
    func toSelectImageFromGallery() {
        let camera = Camera(delegate_: self)
        objAppShareData.displayAlertWithHandlerwithSheetStyle(with: "Please Pick the Photo", message: nil, buttons: ["Camera","Gallery","Cancel"], viewobj: self, buttonStyles: [.default,.default,.cancel], handler: { (selecteutton) in
            if selecteutton == "Camera"{
                camera.PresentMultyCamera(target: self, canEdit: false)
            }else if selecteutton == "Gallery"{
                camera.PresentPhotoLibrary(target: self, canEdit: true)
            }
        })
    }
    
}

//MARK:- Image Pic stufs here(s)
//MARK:-
extension ChattVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: UIImagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(picture as Any,"files")
            self.arrImageInfo.append(ImageInfo(data: picture.jpegData(compressionQuality: 0.5), name: "files"))
            //self.txtVwComment?.text = String(arrImageInfo.count)
            //self.imgVwUser?.image = picture
            var dictParam = [String:Any]()
            dictParam["id"] = ApplicationPreference.shared.getUserData().id
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


//MARK:- UITableView delegate & datasource method(s)
//MARK:-
extension ChattVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRecieveMessage?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let data = self.arrComment[indexPath.row]
        let recieve = self.arrRecieveMessage?[indexPath.row]
        if Int(recieve?.sender_id ?? "0") == Int(ApplicationPreference.shared.getUserData().id ?? "0") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
            cell.comment = recieve
            return cell
        } 
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieveTableViewCell") as! RecieveTableViewCell
        cell.comment = recieve
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- IBAction method(s)
//MARK:-
extension ChattVC {
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUserAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
        vc.data = data
        vc.orderId = self.orderId
        vc.orderStatus = self.orderStatus
        vc.orderDate = self.orderDate
        vc.Productname = self.Productname
        vc.ProductAvability = self.ProductAvability
        vc.CustomerType = self.CustomerType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnorderDetailAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addCommentAction(_ sender: UIButton) {
        self.addCommentApi()
        self.txtVwComment?.text = ""
        
    }
    @IBAction func btnimageUploadAction(_ sender: UIButton) {
        self.toSelectImageFromGallery()
    }
}

//MARK:- Api method(s)
//MARK;-

extension ChattVC{
    func getAllParameters() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["order_id"] = data?.productlist?.first?.order_id
        dictparam["sender_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["customer_id"] = data?.customer_id
        dictparam["files"] = "p.ng"
        dictparam["body"] = self.txtVwComment?.text ?? ""
        print(dictparam)
        return dictparam
        
    }
  
    func addCommentApi() {
        
        let params = getAllParameters()
//        let data: Data = self.arrImageInfo.image?.jpegData(compressionQuality: 0.5) ?? Data()
        objWebServiceManager.uploadImage(strUrl: add_chat, para: params, image: arrImageInfo, showIndicator: true, succes: { (response) in
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseGetChatModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    DispatchQueue.main.async {
                        self.arrRecieveMessage?.append(model.messges)
                        self.tblVwComment?.reloadData()
                        self.getCommentList()
//                        objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                    }
                  
                } else {
//                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            objAppShareData.showAlertVC(title: "Alert", message: error.localizedDescription, controller: self)
        }
        
        
    }
    
}


//MARK:- Api method(s)
//MARK;-

extension ChattVC{
    func getAllParam() -> [String:Any] {
        var dictparam = [String:Any]()
        dictparam["vendor_id"] = ApplicationPreference.shared.getUserData().id
        dictparam["order_id"] = self.orderId
        print(dictparam)
        return dictparam
    }
    
    func getCommentList(){
        let param = getAllParam()
        objWebServiceManager.requestPost(strURL: get_chats, params: param, showIndicator: false, success: { (response) in
            //
            if let data = response as? [String : Any] {
                guard let model = Mapper<ResponseRecieveChatModel>().map(JSON: data) else {
                    return
                }
                if model.status == 200 {
                    DispatchQueue.main.async {
                        self.arrRecieveMessage = model.recievemsg!
                        self.tblVwComment?.reloadData()
                
                    }
                }else {
//                    objAppShareData.showAlertVC(title: "Alert", message: model.message!, controller: self)
                }
            }
        }) { (error) in
            //
        }
    }
}
