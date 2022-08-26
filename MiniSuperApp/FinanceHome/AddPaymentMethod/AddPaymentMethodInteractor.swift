//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/26.
//

import ModernRIBs

protocol AddPaymentMethodRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
  var listener: AddPaymentMethodPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {
  
  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: AddPaymentMethodPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  // VC로 부터 전달받은 요청: 화면 내려달라
  // 화면 내리는 로직은 부모가 담당해야 하므로 부모 interactor에게 요청 전달
  func didTapClose() {
    listener?.addPaymentMethodDidTapClose()
  }
}
