//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/30.
//

import UIKit

extension UIViewController {
  
  func setupNavigationItem(target: Any?, action: Selector?) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark",
                     withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
      style: .plain,
      target: target,
      action: action
    )
  }
  
}
