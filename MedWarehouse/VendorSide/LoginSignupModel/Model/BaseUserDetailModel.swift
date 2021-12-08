//
//  BaseUserDetailModel.swift
//  MedWarehouse
//
//  Created by Apple on 13/05/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ObjectMapper
import SVProgressHUD

class ResponseLogin: Mappable {
    var message: String?
    var status: Int?
    var data : LoginleModel?
    
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data    <- map["data"]
    }
    
    
}

class LoginleModel:  Mappable {
    var added: String?
    var id: String?
    var first_name : String?
    var last_name : String?
    var email : String?
    var role:String?
    var password:String?
    var company_name:String?
    var company_contact:String?
    var company_address:String?
    var langitude:String?
    var longitude:String?
    var company_city:String?
    var company_state:String?
    var company_zip:String?
    var company_country:String?
    var image: String?
    var modified:String?
    var password_code:String?
    var status:String?
    var type:String?
    var document: String?
    var document_link:[String]?
    var order_id:String?
    var sender_id:String?
    var customer_id:String?
    var vendor_id:String?
    var body:String?
    var files:String?
    var is_read:String?

    
   
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.added                <- map["added"]
        self.id                   <- map["id"]
        self.first_name           <- map["first_name"]
        self.last_name            <- map["last_name"]
        self.email                <- map["email"]
        self.role                 <- map["role"]
        self.password             <- map["password"]
        self.company_name         <- map["company_name"]
        self.company_contact      <- map["company_contact"]
        self.company_address       <- map["company_address"]
        self.langitude            <- map["langitude"]
        self.longitude            <- map["longitude"]
        self.company_city         <- map["company_city"]
        self.company_state        <- map["company_state"]
        self.company_zip          <- map["company_zip"]
        self.company_country      <- map["company_country"]
        self.image                 <- map["image"]
        self.modified             <- map["modified"]
        self.password_code        <- map["password_code"]
        self.type                <- map["type"]
        self.document             <- map["document"]
        self.document_link        <- map["document_link"]
        self.vendor_id        <- map["vendor_id"]
        self.customer_id        <- map["customer_id"]
        self.order_id        <- map["order_id"]
        self.is_read        <- map["is_read"]
        self.body        <- map["body"]
        self.files        <- map["files"]
            
    }
}

class AllProductHistoryResponse: Mappable {
    var rideHistory: [RideHistory]?
    var status: Int?
    var message: String?
    var sample_document : String?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.status         <- map["status"]
        self.rideHistory    <- map["data"]
        self.message        <- map["message"]
        self.sample_document <- map["sample_document"]
    }
}
//"products_name" = "Allacan 10mg Tablet 30 BR";
//"products_quantity" = 0;
//"products_vendor_id" = 83;
//type = Wholesaler;
//"vendors_company_country" = india;
class RideHistory: Mappable {
    var product_id: String?
    var products_name : String?
    var products_quantity : String?
    var products_vendor_id : String?
    var vendors_company_country : String?
    var vendors_company_name : String?
    var type : String?
    var company_name : String?
    var company_country : String?
    var added:String?
    var availability:String?
    var description:String?
    var expiry_months:String?
    var name:String?
    var id:String?
    var on_floor:String?
    var modified:String?
    var quantity:String?
    var searched:String?
    var vendor_id:String?
    var soft_delete:String?
    var slug:String?
    var vendor_category: String?
    //    added = "0000-00-00 00:00:00";
    //    availability = Yes;
    //    description = "";
    //    "expiry_months" = "28/02/1999";
    //    id = 18;
    //    modified = "2021-05-27 03:33:39";
    //    name = Food;
    //    "on_floor" = "";
    //    quantity = 0;
    //    searched = 0;
    //    slug = "";
    //    "soft_delete" = off;
    //    "vendor_id" = 9;
    //
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.vendor_category       <- map["vendor_category"]
        self.product_id            <- map["product_id"]
        self.vendors_company_name  <- map["vendors_company_name"]
        self.products_name         <- map["products_name"]
        self.products_quantity     <- map["products_quantity"]
        self.products_vendor_id    <- map["products_vendor_id"]
        self.type                  <- map["type"]
        self.vendors_company_country <- map["vendors_company_country"]
        self.company_country       <- map["company_country"]
        self.company_name          <- map["company_name"]
        self.added                 <- map["added"]
        self.availability           <- map["availability"]
        self.description            <- map["description"]
        self.expiry_months            <- map["expiry_months"]
        self.name                   <- map["name"]
        self.id                    <- map["id"]
        self.modified              <- map["modified"]
        self.quantity              <- map["quantity"]
        self.searched              <- map["searched"]
        self.slug                  <- map["slug"]
        self.quantity              <- map["quantity"]
        self.soft_delete           <- map["soft_delete"]
        self.on_floor              <- map["on_floor"]
        
    }
}
//MARK: LIST MODEL ALL ORDER
class AllProductlistHistoryResponse: Mappable {
    var alllist: [Productlist]?
    var status: Int?
    var message: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.status     <- map["status"]
        self.alllist    <- map["data"]
        self.message    <- map["message"]
    }
}

class Productlist: Mappable {
    var vc_company_name: String?
    var filter_type :String?
    var v_fname:String?
    var v_lname:String?
    var product_name:String?
    var added:String?
    var modified:String?
    var customer_id:String?
    var product_id:String?
    var pdf_name:String?
    var v_companyname:String?
    var v_companyaddress:String?
    var v_companycountry:String?
    var order_id: String?
    var order_status:String?
   
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.vc_company_name    <- map["vc_company_name"]
        self.order_id           <- map["order_id"]
        self.filter_type        <- map["filter_type"]
        self.v_lname            <- map["v_lname"]
        self.v_fname            <- map["v_fname"]
        self.added              <- map["added"]
        self.modified           <- map["modified"]
        self.v_companyname      <- map["v_companyname"]
        self.v_companycountry   <- map["v_companycountry"]
        self.v_companyaddress   <- map["v_companyaddress"]
        self.pdf_name           <- map["pdf_name"]
        self.customer_id        <- map["customer_id"]
        self.product_id         <- map["product_id"]
        self.product_name       <- map["product_name"]
        self.order_status       <- map["order_status"]
        
    }
}



//MARK: LIST MODEL My ORDER
class AllProductMyOrderResponse: Mappable {
    var alllist: [Orderlist]?
    var status: Int?
    var message: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.status     <- map["status"]
        self.alllist    <- map["data"]
        self.message    <- map["message"]
    }
}
class Orderlist: Mappable {
    var invoice_number :String?
    var invoice_id:String?
    var pdf_name:String?
    var payment_id:String?
    var customer_id:String?
    var customer_first_name:String?
    var customer_last_name:String?
    var customer_name:String?
    var customer_address:String?
    var customer_phone:String?
    var customer_email:String?
    var product_name :String?
    var company_country : String?
    var order_date: String?
    var productlist: [productdetail]?
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.company_country     <- map["company_country"]
        self.productlist         <- map["product_detail"]
        self.invoice_number      <- map["invoice_number"]
        self.invoice_id          <- map["invoice_id"]
        self.pdf_name            <- map["pdf_name"]
        self.payment_id          <- map["payment_id"]
        self.customer_id         <- map["customer_id"]
        self.customer_first_name <- map["customer_first_name"]
        self.customer_last_name  <- map["customer_last_name"]
        self.customer_name       <- map["customer_name"]
        self.customer_address    <- map["customer_address"]
        self.customer_phone      <- map["customer_phone"]
        self.customer_email      <- map["customer_email"]
        self.product_name        <- map["product_name"]
        self.order_date          <- map["order_date"]
        
    }
}
//"product_detail": [
//                {
//                    "product_name": "13022(3)",
//                    "product_availability": "Y",
//                    "product_expiry_months": "31-Aug-2021",
//                    "product_slug": "",
//                    "product_quantity": "0",
//                    "product_description": "",
//                    "product_on_floor": "Y",
//                    "product_id": "443",
//                    "vendor_id": "599",
//                    "seller_company_name": "test",
//                    "order_id": "686",
//                    "order_status": "processing"
//                },
class productdetail: Mappable {
    var product_name :String?
    var product_availability:String?
    var product_expiry_months:String?
    var product_slug:String?
    var product_quantity:String?
    var product_description:String?
    var product_on_floor:String?
    var product_id:String?
    var seller_company_name: String?
    var order_date: String?
    var order_status: String?
    var order_id: String?
    var vc_company_name : String?
    var vendor_id : String?
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.seller_company_name           <- map["seller_company_name"]
        self.vc_company_name               <- map["vc_company_name"]
        self.product_name                  <- map["product_name"]
        self.product_availability          <- map["product_availability"]
        self.product_expiry_months         <- map["product_expiry_months"]
        self.product_slug                  <- map["product_slug"]
        self.product_quantity              <- map["product_quantity"]
        self.product_description           <- map["product_description"]
        self.product_on_floor              <- map["product_on_floor"]
        self.product_id                    <- map["product_id"]
        self.order_date                    <- map["order_date"]
        self.order_status                  <- map["order_status"]
        self.order_id                      <- map["order_id"]
        self.vendor_id                     <- map["vendor_id"]
    }
}

//
//        ]
//    },


//MARK:- Get Chat Model(s)
//MARK:-
class ResponseGetChatModel: Mappable {
    var message: String?
    var status: Int?
    var messges : GetRecieveChatModel?
   
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status         <- map["status"]
        self.message        <- map["message"]
        self.messges       <- map["data"]
        
    }
}

class GetChatModel:  Mappable {
    var added: String?
    var id: String?
    var order_id:String?
    var sender_id:String?
    var customer_id:String?
    var vendor_id:String?
    var body:String?
    var files:String?
    var is_read:String?
    var name : String?
    
   
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.added          <- map["added"]
        self.id             <- map["id"]
        self.vendor_id      <- map["vendor_id"]
        self.customer_id    <- map["customer_id"]
        self.order_id       <- map["order_id"]
        self.is_read        <- map["is_read"]
        self.body           <- map["body"]
        self.files          <- map["files"]
        self.sender_id      <- map["sender_id"]
        self.name           <- map["name"]
            
    }
}



//MARK:- Get RecieveChat Model(s)
//MARK:-
class ResponseRecieveChatModel: Mappable {
    var message: String?
    var status: Int?
    var recievemsg : [GetRecieveChatModel]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.recievemsg <- map["data"]
    }
}

class GetRecieveChatModel:  Mappable {
    var added: String?
    var id: String?
    var order_id:String?
    var sender_id:String?
    var customer_id:String?
    var vendor_id:String?
    var body:String?
    var files:String?
    var is_read:String?
    var files_img : String?
    var name : String?
   
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.added               <- map["added"]
        self.id                  <- map["id"]
        self.vendor_id           <- map["vendor_id"]
        self.customer_id         <- map["customer_id"]
        self.order_id            <- map["order_id"]
        self.is_read             <- map["is_read"]
        self.body                <- map["body"]
        self.files               <- map["files"]
        self.sender_id           <- map["sender_id"]
        self.files_img           <- map["files_img"]
        self.name                <- map["name"]
    }
}



//MARK:- Get Userlist Model(s)
//MARK:-
class ResponseUserlist: Mappable {
    var message: String?
    var status: Int?
    var data : [GetUserlist]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data <- map["data"]
    }
}

class GetUserlist:  Mappable {
    var added: String?
    var id: String?
    var order_id:String?
    var sender_id:String?
    var customer_id:String?
    var vendor_id:String?
    var body:String?
    var files:String?
    var is_read:String?
    var files_img : String?
    var sender_fname : String?
    var fname : String?
    var order_status : String?
    var order_date : String?
    var product_name : String?
    var product_availability : String?
    var custoer_type : String?
//    "id": "397",
//                "order_id": "602",
//                "sender_id": "598",
//                "customer_id": "598",
//                "vendor_id": "87",
//                "body": "khgkjg",
//                "files": "",
//                "is_read": "yes",
//                "added": "2021-08-17 05:43:14",
//                "order_date": "2021-08-17 05:42:43",
//                "order_status": "processing",
//                "sender_fname": null,
//                "fname": "Barbra",
//                "image": "https://medwarehousedev.azurewebsites.net/assets/images/avatar-sender.png",
//                "product_name": "Paracetamol2 500mg Capsule 100 BR",
//                "product_availability": "Y",
//                "custoer_type": "Broker"
//            },
//
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.added               <- map["added"]
        self.id                  <- map["id"]
        self.vendor_id           <- map["vendor_id"]
        self.customer_id         <- map["customer_id"]
        self.order_id            <- map["order_id"]
        self.is_read             <- map["is_read"]
        self.body                <- map["body"]
        self.files               <- map["files"]
        self.sender_id           <- map["sender_id"]
        self.files_img           <- map["files_img"]
        self.sender_fname        <- map["sender_fname"]
        self.fname               <- map["fname"]
        self.order_status        <- map["order_status"]
        self.order_date          <- map["order_date"]
        self.product_name        <- map["product_name"]
        self.product_availability <- map["product_availability"]
        self.custoer_type         <- map["custoer_type"]
    }
}

//MARK:- Get RecieveChat Model(s)
//MARK:-
class ResponseRequestforquatation: Mappable {
    var message: String?
    var status: Int?
    var data : [GetRequestModel]?
    var active : [GetActiveData?]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status   <- map["status"]
        self.message  <- map["message"]
        self.data     <- map["data"]
        self.active   <- map["data"]
    }
}

class GetRequestModel:  Mappable {
    var request_items_id: String?
    var rt_delivery_date: String?
    var rt_description: String?
    var rt_product_id: String?
    var rt_quantity: String?
    var rt_request_id: String?
    var request_id: String?
    var product_id:String?
    var description:String?
    var quantity:String?
    var delivery_date:String?
    var closing_date:String?
    var added:String?
    var modified:String?
    var rs_id:String?
    var rs_vendor_id:String?
    var rs_hidden_for:String?
    var id : String?
    var status : String?
    var vendor_id: String?
    var requestor_countory : String?
    var requestor_type: String?
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.status              <- map["status"]
        self.requestor_type      <- map["requerequestor_typestor_type"]
        self.requestor_countory  <- map["requestor_countory"]
        self.request_items_id  <- map["request_items_id"]
        self.rt_delivery_date  <- map["rt_delivery_date"]
        self.rt_description  <- map["rt_description"]
        self.rt_product_id  <- map["rt_product_id"]
        self.rt_quantity  <- map["rt_quantity"]
        self.rt_request_id  <- map["rt_request_id"]
        self.request_id          <- map["request_id"]
        self.request_items_id    <- map["request_items_id"]
        self.product_id          <- map["product_id"]
        self.description         <- map["description"]
        self.modified            <- map["modified"]
        self.closing_date        <- map["closing_date"]
        self.quantity            <- map["quantity"]
        self.delivery_date       <- map["delivery_date"]
        self.added               <- map["added"]
        self.rs_id               <- map["rs_id"]
        self.rs_vendor_id        <- map["rs_vendor_id"]
        self.rs_hidden_for       <- map["rs_hidden_for"]
        self.id                  <- map["id"]
        self.vendor_id           <- map["vendor_id"]
    }
    
}
class GetActiveData: Mappable {
    var request_items_id: String?
    var id: String?
    var vendor_id: String?
    var request_id:String?
    var quantity:String?
    var price_per_unit:String?
    var message:String?
    var status:String?
    var delivery_by:String?
    var added:String?
    var modified:String?
    var description:String?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.request_items_id    <- map["request_items_id"]
        self.id                  <- map["id"]
        self.vendor_id           <- map["vendor_id"]
        self.request_id          <- map["request_id"]
        self.quantity            <- map["quantity"]
        self.modified            <- map["modified"]
        self.price_per_unit      <- map["price_per_unit"]
        self.quantity            <- map["quantity"]
        self.message             <- map["message"]
        self.added               <- map["added"]
        self.status              <- map["status"]
        self.delivery_by         <- map["delivery_by"]
        self.description         <- map["description"]
    }
    
    
}
//MARK:- Get My Quatation Model(s)
//MARK:-
class ResponseMyQuatationModel: Mappable {
    var message: String?
    var status: Int?
    var data : [GetQuatationModel]?
    var notes : String?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data <- map["data"]
        self.notes <- map["note"]
    }
}

class GetQuatationModel:  Mappable {
    var vendor_id: String?
    var request_id:String?
    var id : String?
    var quantity:String?
    var price_per_unit:String?
    var message:String?
    var status:String?
    var delivery_by:String?
    var added:String?
    var modified:String?
    var vendor_name:String?
    var request_quotes_id : String?
    var total : Int?
    var rt_id : String?
    var rt_product_id : String?
    var rt_description : String?
    var rt_quantity : String?
    var rt_delivery_date : String?
    var request_items_id : String?
    var vendors_company_name : String?
    var rs_closing_date: String?
    var rt_closing_date: String?
    var rs_note:String?
    
   
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.id                  <- map["id"]
        self.rs_note             <- map["rs_note"]
        self.request_items_id    <- map["request_items_id"]
        self.rt_closing_date     <- map["rt_closing_date"]
        self.vendor_id           <- map["vendor_id"]
        self.request_id          <- map["request_id"]
        self.modified            <- map["modified"]
        self.quantity            <- map["quantity"]
        self.price_per_unit      <- map["price_per_unit"]
        self.message             <- map["message"]
        self.status              <- map["status"]
        self.delivery_by         <- map["delivery_by"]
        self.added               <- map["added"]
        self.vendor_name         <- map["vendor_name"]
        self.request_quotes_id   <- map["request_quotes_id"]
        self.total               <- map["total"]
        self.rt_id               <- map["rt_id"]
        self.rt_product_id       <- map["rt_product_id"]
        self.rt_description      <- map["rt_description"]
        self.rt_quantity         <- map["rt_quantity"]
        self.rt_delivery_date    <- map["rt_delivery_date"]
        self.vendors_company_name <- map["vendors_company_name"]
        self.total                <- map["total"]
        self.rs_closing_date      <- map["rs_closing_date"]
    }
}

//MARK:-  Quatation Submit Model(s)
//MARK:-
class ResponseQuatationSubmitModel: Mappable {
    var message: String?
    var status: Int?
    var data : [GetSubmitModel]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data <- map["data"]
    }
}

class GetSubmitModel:  Mappable {
    var id: String?
    var vendor_id: String?
    var request_id:String?
    var quantity:String?
    var rt_request_id:String?
    var description:String?
    var rt_delivery_date:String?
    var rt_quantity:String?
    var added:String?
    var modified:String?
    var rt_id:String?
    var rt_product_id:String?
    var rt_description:String?
    var message: String?
    var price_per_unit: String?
    var delivery_by:String?
    var delivery_date: String?
    var closing_date:String?
//    request_items_id": "1786",
//                "request_id": "52",
//                "product_id": "549",
//                "description": "Warfarin",
//                "quantity": "20",
//                "delivery_date": "0000-00-00 00:00:00",
//                "closing_date": "0000-00-00 00:00:00",
//                "added": "2021-09-30 11:20:58",
//                "modified": "2021-09-30 11:20:58",
//                "rs_id": "52",
//                "rs_vendor_id": "639",
//                "rs_hidden_for": "[\"00000000087\"]"
//    "id": "11",
//               "vendor_id": "605",
//               "request_id": "224",
//               "quantity": "2",
//               "price_per_unit": "10",
//               "message": "",
//               "status": "declined",
//               "delivery_by": "2020-10-21 00:00:00",
//               "added": "2021-09-07 10:46:54",
//               "modified": "2021-09-10 05:22:59"
//    "request_id": "1",
//                "vendor_id": "87",
//                "description": "No aaaaa  given",
//                "added": "2021-08-05 05:27:52",
//                "modified": "2021-08-25 03:00:51",
//                "hidden_for": "[6,\"00000000087\"]",
//                "rt_id": null,
//                "rt_product_id": null,
//                "rt_description": null,
//                "rt_quantity": null,
//                "rt_delivery_date": null,
//                "rt_request_id": null

    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.request_id          <- map["request_id"]
        self.vendor_id           <- map["vendor_id"]
        self.description         <- map["description"]
        self.added               <- map["added"]
        self.modified            <- map["modified"]
        self.rt_id               <- map["rt_id"]
        self.rt_product_id       <- map["rt_product_id"]
        self.rt_description      <- map["rt_description"]
        self.rt_quantity         <- map["rt_quantity"]
        self.rt_delivery_date    <- map["rt_delivery_date"]
        self.rt_request_id       <- map["rt_request_id"]
        self.message             <- map["message"]
        self.delivery_by         <- map["delivery_by"]
        self.price_per_unit      <- map["price_per_unit"]
        self.quantity            <- map["quantity"]
        self.delivery_date       <- map["delivery_date"]
        self.closing_date        <- map["closing_date"]
    }
}
//MARK:-  Quatation Submit Model(s)
//MARK:-
class ResponseQuatatSubmitModel: Mappable {
    var message: String?
    var status: Int?
    var notes: String?
    var data : [ResQuoteSubmitModel]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status  <- map["status"]
        self.message <- map["message"]
        self.data    <- map["data"]
        self.notes   <- map["notes"]
    }
}

class ResQuoteSubmitModel:  Mappable {
    var request_items_id: String?
    var request_id: String?
    var product_id:String?
    var description:String?
    var quantity:String?
    var delivery_date:String?
    var closing_date:String?
    var added:String?
    var modified:String?
    var rs_id:String?
    var rs_vendor_id:String?
    var rs_hidden_for:String?
    var price_unit : String?

    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.price_unit             <- map["price_unit"]
        self.request_items_id       <- map["request_items_id"]
        self.request_id             <- map["request_id"]
        self.product_id             <- map["product_id"]
        self.description            <- map["description"]
        self.quantity               <- map["quantity"]
        self.delivery_date          <- map["delivery_date"]
        self.closing_date           <- map["closing_date"]
        self.added                  <- map["added"]
        self.modified               <- map["modified"]
        self.rs_id                  <- map["rs_id"]
        self.rs_vendor_id           <- map["rs_vendor_id"]
        self.rs_hidden_for          <- map["rs_hidden_for"]

    }
}

//MARK:-  Quatation Detail Model(s)
//MARK:-
class ResponseQuoteslModel: Mappable {
    var message: String?
    var status: Int?
    var data : [QuotesDetaillModel]?
    required init?(map: Map){}
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data <- map["data"]
    }
}
class QuotesDetaillModel:  Mappable {
    var id: String?
    var vendor_id: String?
    var request_id: String?
    var product_id:String?
    var price_per_unit: String?
    var message: String?
    var statusMsg: String?
    var description:String?
    var quantity:String?
    var delivery_by: String?
    var counter_by:String?
    var closing_date:String?
    var added:String?
    var modified:String?
    var currency:String?
    var request_items_id:String?
    var rt_description:String?
    var rt_quantity:String?
    var rt_delivery_date:String?
    var rs_note:String?

    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        self.request_items_id      <- map["request_items_id"]
        self.id                    <- map["id"]
        self.vendor_id             <- map["vendor_id"]
        self.request_id            <- map["request_id"]
        self.price_per_unit        <- map["price_per_unit"]
        self.message               <- map["message"]
        self.statusMsg             <- map["status"]
        self.delivery_by           <- map["delivery_by"]
        self.counter_by            <- map["counter_by"]
        self.currency              <- map["currency"]
        self.rt_description        <- map["rt_description"]
        self.rt_quantity           <- map["rt_quantity"]
        self.rt_delivery_date      <- map["rt_delivery_date"]
        self.rs_note               <- map["rs_note"]
        self.request_id            <- map["request_id"]
        self.product_id            <- map["product_id"]
        self.description           <- map["description"]
        self.quantity              <- map["quantity"]
        self.closing_date          <- map["closing_date"]
        self.added                 <- map["added"]
        self.modified              <- map["modified"]
       
    }
}
