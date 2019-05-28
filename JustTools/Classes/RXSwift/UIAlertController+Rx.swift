//
//  UIAlertController+Rx.swift
//  CardWatch
//
//  Created by 叶增峰 on 19/5/17.
//  Copyright © 2017年 叶增峰. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

/*
button.rx.tap
    .asDriver()
    .flatMapLatest { [weak self] _ in
        return UIAlertController.rx.createWithParent(self,
                                                     cancelAction: .cancel,
                                                     actions: [.camera, .photoLibrary],
                                                     type: .actionSheet)
            .asDriver(onErrorJustReturn: .cancel)
    }
    .drive(onNext: { [weak self] action in
        // TODO
    })
    .disposed(by: disposeBag)
*/

extension Reactive where Base: UIAlertController {
    
    enum AlertAction: String {
        case cancel = "取消"
        case camera = "拍照"
        case photoLibrary = "从相册选择"
    }
    
    
    static func createWithParent(_ parent: UIViewController?,
                                 animated: Bool = true,
                                 cancelAction: AlertAction,
                                 actions: [AlertAction],
                                 type: UIAlertController.Style,
        configureAlertController: @escaping (UIAlertController) throws -> () = { x in }) -> Observable<AlertAction> {
        
        return Observable.create { observer in
            let alertView = UIAlertController(title: nil, message: nil, preferredStyle: type)
            do {
                try configureAlertController(alertView)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            alertView.addAction(UIAlertAction(title: cancelAction.rawValue, style: .cancel) { _ in
                observer.on(.completed)
                //observer.on(.next(cancelAction))
            })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.rawValue, style: .default) { _ in
                    observer.on(.next(action))
                })
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(alertView, animated: animated, completion: nil)
            
            return Disposables.create {
                alertView.dismiss(animated: animated, completion: nil)
            }
        }
        
    }
}
