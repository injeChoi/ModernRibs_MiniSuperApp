//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 60157124 on 2022/08/25.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
  var listener: CardOnFileDashboardPresentableListener? { get set }
  
  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol CardOnFileDashboardInteractorDependency {
  var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {
  
  weak var router: CardOnFileDashboardRouting?
  weak var listener: CardOnFileDashboardListener?
  
  private let dependency: CardOnFileDashboardInteractorDependency
  
  private var cancellables: Set<AnyCancellable>
  
  init(
    presenter: CardOnFileDashboardPresentable,
    dependency: CardOnFileDashboardInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.cardsOnFileRepository.cardOnFile.sink { methods in
      let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
      self.presenter.update(with: viewModels)
    }.store(in: &cancellables)
  }
  
  // Interactor가 detach 되기 직전에 이 메소드가 호출된다
  override func willResignActive() {
    super.willResignActive()
    
    // detach 될 때 cancellables를 모두 삭제해주면
    // weak self 없이도 메모리 누수를 방지할 수 있다
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
}
