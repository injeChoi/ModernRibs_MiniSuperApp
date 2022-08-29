//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/29.
//

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

// UI Adaptive를 대신해서(proxy) 받는 객체
final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  
  weak var delegate: AdaptivePresentationControllerDelegate?
  
  // 화면이 dismiss 되면 delegate 받아서 처리되는 optional 메소드
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    
    // 어떤 화면이 dismiss되면 dismiss 시킨 interactor 한테 특정 로직 수행 명령 
    delegate?.presentationControllerDidDismiss()
  }
}
