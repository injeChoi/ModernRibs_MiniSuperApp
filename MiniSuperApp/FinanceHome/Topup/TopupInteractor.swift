//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/29.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardsOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  private let dependency: TopupInteractorDependency
  
  private var paymentMethods: [PaymentMethod] {
    dependency.cardsOnFileRepository.cardOnFile.value
  }
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

  init(
    dependency: TopupInteractorDependency
  ) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      router?.attachAddPaymentMethod()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    // attach add card
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
}
