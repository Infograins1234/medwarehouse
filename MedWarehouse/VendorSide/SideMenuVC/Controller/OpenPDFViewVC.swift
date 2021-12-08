//
//  OpenPDFViewVC.swift
//  MedWarehouse
//
//  Created by Apple on 14/06/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import PDFKit
@available(iOS 11.0, *)
@available(iOS 11.0, *)
class OpenPDFViewVC: UIViewController {
    //MARK:- IBOutlet(s)
    @IBOutlet weak var pdfView: PDFView?
    //MARK:- Variable(s)
    //MARK:-
    var pdfUrl: String?
    private var document: PDFDocument?
    private var outline: PDFOutline?
    
    //MARK:- View life cycle method(s)
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        self.openPDF()
    }
    
    fileprivate func openPDF() {
        guard let _ = self.pdfUrl else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let url = URL(string: pdfUrl!), let document = PDFDocument(url: url) {
            print("Now showing")
            self.pdfView?.document = document
            self.outline = self.document?.outlineRoot
        }
        
        self.pdfView?.displayDirection = .vertical
        self.pdfView?.usePageViewController(true)
        self.pdfView?.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.pdfView?.autoScales = true
    }
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
