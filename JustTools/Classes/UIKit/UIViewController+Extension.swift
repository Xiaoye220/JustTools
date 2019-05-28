//
//  UIViewController+Navigation.swift
//
//  Created by YZF on 2019/5/27.
//

import Foundation
import UIKit

let navigationBarViewTag = 999
let statusBarViewTag = 998

public extension UIViewController {
    
    class func currentViewController(root: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return currentViewController(root: nav.visibleViewController)
        }
        if let tabBar = root as? UITabBarController {
            return currentViewController(root: tabBar.selectedViewController)
        }
        if let presented = root?.presentedViewController {
            return currentViewController(root: presented)
        }
        return root
    }
    
}


// MARK: - Navigation 相关
public extension UIViewController {
    
    /// 设置 NavigationBar 透明
    func setNavigationBarClear() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        //去除边框阴影
        navigationBar.shadowImage = UIImage()
        //背景透明
        navigationBar.isTranslucent = true
        //背景颜色
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    /// 自定义 NavigationBarView
    func setNavigationBarView(_ includeStatusBar: Bool = true, closure: (UIView) -> Void) {
        guard let navigationController = self.navigationController else {
            return
        }
        
        if let view = navigationController.view.viewWithTag(navigationBarViewTag) {
            closure(view)
            return
        }
        
        let rect = navigationController.navigationBar.bounds
        let viewHeight = rect.height + (includeStatusBar ? UIApplication.shared.statusBarFrame.height : 0)
        let navigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: viewHeight))
        navigationBarView.tag = navigationBarViewTag
        closure(navigationBarView)
        navigationController.view.insertSubview(navigationBarView, at: 1)
    }
    
    /// 定义 StatusBarView
    func setStatusBarView(closure: (UIView) -> Void) {
        guard let navigationController = self.navigationController else {
            return
        }
        
        if let view = navigationController.view.viewWithTag(statusBarViewTag) {
            closure(view)
            return
        }
        
        let rect = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: rect)
        statusBarView.tag = statusBarViewTag
        closure(statusBarView)
        navigationController.view.insertSubview(statusBarView, at: 1)
    }
    
    /// 允许侧滑返回
    func enableInteractivePopGestureRecognizer() {
        guard let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer else {
            return
        }
        interactivePopGestureRecognizer.isEnabled = true
        interactivePopGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
    }
}
