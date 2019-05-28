//
//  UIViewExtence.swift
//
//  Created by YZF on 2016/12/6.
//  Copyright © 2016年 YZF. All rights reserved.
//

import UIKit

public extension UIView {
    /// 截图
    func captureView(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 当前 view 所在的 ViewController
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
}

public extension UIView {
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setX(x:CGFloat) {
        self.frame = CGRect(x:x, y:self.y(), width:self.width(), height:self.height())
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setY(y:CGFloat) {
        self.frame = CGRect(x:self.x(), y:y, width:self.width(), height:self.height())
    }
    
    func width() -> CGFloat {
        return self.frame.width
    }
    
    func setWidth(width:CGFloat) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:width, height:self.height())
    }
    
    func height() -> CGFloat{
        return self.frame.height
    }
    
    func setHeight(height:CGFloat) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:self.width(), height:height)

    }
    
    func size() -> CGSize {
        return self.frame.size
    }
    
    func setSize(size: CGSize) {
        self.frame = CGRect(x:self.x(), y:self.y(), width:size.width, height:size.height)
    }
    
    func origin() -> CGPoint {
        return self.frame.origin
    }
    
    func setOrigin(origin: CGPoint) {
        self.frame = CGRect(x:origin.x, y:origin.y, width:self.width(), height:self.height())
    }
    
}



