//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/26.
//

import ModernRIBs

protocol AddPaymentMethodDependency: Dependency {
  var cardsOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
  var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
}

// MARK: - Builder

protocol AddPaymentMethodBuildable: Buildable {
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting
}

final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {
  
  override init(dependency: AddPaymentMethodDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting {
    let component = AddPaymentMethodComponent(dependency: dependency)
    let viewController = AddPaymentMethodViewController()
    let interactor = AddPaymentMethodInteractor(
      presenter: viewController,
      dependency: component)
    interactor.listener = listener
    return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
  }
}
