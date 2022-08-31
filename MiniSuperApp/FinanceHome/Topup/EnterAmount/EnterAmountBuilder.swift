//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/29.
//

import ModernRIBs

protocol EnterAmountDependency: Dependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountIteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { dependency.selectedPaymentMethod }

}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
  func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {
  
  override init(dependency: EnterAmountDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
    let component = EnterAmountComponent(dependency: dependency)
    let viewController = EnterAmountViewController()
    let interactor = EnterAmountInteractor(presenter: viewController, dependency: component)
    interactor.listener = listener
    return EnterAmountRouter(interactor: interactor, viewController: viewController)
  }
}
