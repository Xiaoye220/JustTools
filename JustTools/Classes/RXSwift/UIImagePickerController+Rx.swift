//
//  UIImagePickerController+Rx.swift
//  CardWatch
//
//  Created by 叶增峰 on 18/5/17.
//  Copyright © 2017年 叶增峰. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit

/*
使用：
 
button.rx.tap
    .asDriver()
    .flatMapLatest { [weak self] _ in
        return UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .camera
                picker.allowsEditing = true
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .asDriver(onErrorJustReturn: [:])
    }
    .map { info in
        return info[UIImagePickerControllerEditedImage] as? UIImage
    }
    .drive(onNext: { [weak self] image in
        // TODO
    })
    .disposed(by: disposeBag)
*/

let RxImagePickerDelegateProxyRegister: Void = {
    RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
}()

class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}

extension Reactive where Base: UIImagePickerController {
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}


extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> () = { x in }) -> Observable<UIImagePickerController> {
        
        RxImagePickerDelegateProxyRegister
        
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
}



fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}


func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

