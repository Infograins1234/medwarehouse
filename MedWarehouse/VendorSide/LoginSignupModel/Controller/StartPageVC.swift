//
//  StartPageVC.swift
//  MedWarehouse
//
//  Created by Apple on 23/04/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class StartPageVC: UIViewController {
    
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var clvVW: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    var arrImage: [UIImage] = [#imageLiteral(resourceName: "header_img"), #imageLiteral(resourceName: "header_img"), #imageLiteral(resourceName: "header_img")]
    var arrName : [String] = ["Upload Stock","Search Live Wholesealer Stock Instantly","Certified Pharmaceutical Companies Only"]
    var Int : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ApplicationPreference.shared.getUserData().id != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: false)
            return
        }
        
        btnNext.layer.cornerRadius = 10
        btnSkip.layer.cornerRadius = 10
        clvVW.delegate = self
        clvVW.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
       
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSkipAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension StartPageVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartPageViewCell", for: indexPath) as! StartPageViewCell
        cell.imgVw?.image = self.arrImage[indexPath.row]
        cell.lblName?.text = self.arrName[indexPath.row]
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in clvVW.visibleCells {
            let indexPath = clvVW.indexPath(for: cell)
            print(indexPath)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.clvVW!.contentOffset, size: self.clvVW!.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.clvVW!.indexPathForItem(at: visiblePoint) {
            self.PageControl?.currentPage = visibleIndexPath.row
        }
    }
}


