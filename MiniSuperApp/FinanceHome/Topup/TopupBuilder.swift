//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/29.
//

import ModernRIBs
import Combine

protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
  var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>,
                            TopupInteractorDependency,
                            AddPaymentMethodDependency,
                            EnterAmountDependency,
                            CardOnFileDependency {
    
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    
  var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
  fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }

  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init (
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TopupListener) -> TopupRouting {
    
    let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    
    let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuildable: cardOnFileBuilder
    )
  }
}
