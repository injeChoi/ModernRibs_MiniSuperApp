//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/29.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  private var navigationControllable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountdRouting: Routing?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
      navigationControllable?.dismiss(completion: nil)
    }
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attachEnterAmount() {
    if enterAmountdRouting != nil {
      return
    }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    enterAmountdRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountdRouting else {
      return
    }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountdRouting = nil
  }
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    if self.navigationControllable == nil {
      return
    }
    
    viewController.dismiss(completion: nil)
    self.navigationControllable = nil
  }
  // MARK: - Private
  
  private let viewController: ViewControllable
}
