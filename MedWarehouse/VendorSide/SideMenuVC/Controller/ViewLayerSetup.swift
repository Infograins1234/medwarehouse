//
//  ViewLayerSetup.swift
//  MedWarehouse
//
//  Created by Dr.Mac on 11/08/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ViewLayerSetup: UIView{
    
    @IBInspectable var roundedCorner: Bool = false {
        didSet {
            if roundedCorner == true {
                layer.cornerRadius = (self.bounds.height/2.0)
                self.clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0{
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0{
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false{
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero{
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if roundedCorner == true {
            layer.cornerRadius = (self.bounds.height/2.0)
            self.clipsToBounds = true
        }
    }
}

extension UITextField {
    /// Sets the placeholder color
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
extension UIView {
    @IBInspectable var radiussCorner: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func shadow() {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.6
    }
}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
}


@IBDesignable class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            refreshCorners(value: cornerRadius)
//        }
//    }

    @IBInspectable var customBorderColor: UIColor = UIColor.init (red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet {
            refreshBorderColor(_colorBorder: customBorderColor)
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor = .clear {
        didSet {
            if self.isSelected {
                if selectedBackgroundColor != .clear {
                    self.backgroundColor = selectedBackgroundColor
                }
            }
        }
    }

    func refreshBorderColor(_colorBorder: UIColor) {
        layer.borderColor = _colorBorder.cgColor
    }
    
    func refreshBorder(_borderWidth: CGFloat) {
        layer.borderWidth = _borderWidth
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func sharedInit() {
        // Common logic goes here
//        refreshCorners(value: cornerRadius)
        refreshBorderColor(_colorBorder: customBorderColor)
        refreshBorder(_borderWidth: borderWidth)
//        self.tintColor = UIColor.white
        self.addTarget(self, action: #selector(buttonHighlight(_:)), for: .touchDown)
        
    }
    
    @objc func buttonHighlight(_ sender: UIButton) {
//        backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.backgroundColor = UIColor.black
//        }
        
        if self.isSelected {
            if selectedBackgroundColor != .clear {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
//            backgroundColor = isHighlighted ? #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).withAlphaComponent(0.4) :  UIColor.black
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.backgroundColor = UIColor.black
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            refreshBorder(_borderWidth: borderWidth)
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.cornerRadius = self.rounded ? self.frame.size.height / 2 : 0
            self.layer.masksToBounds = true
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

