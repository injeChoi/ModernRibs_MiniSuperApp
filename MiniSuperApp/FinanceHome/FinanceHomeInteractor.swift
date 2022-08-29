import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  // Interactor는 UI와 관련된 것을 모르게 하기 위해 adaptive도 delegate로 처리하기 위한 로직
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self 
  }
  
  // Interactor의 didBecomeActive가 viewDidLoad의 역할과 유사하다 볼 수 있다
  override func didBecomeActive() {
    super.didBecomeActive()
    
    router?.attachSuperPayDashboard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
  
  
  // MARK: - CardOnFileDashboardListener
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }
  
  // MARK: - AddPayementMethodListener
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }
  
  func superPayDashboardDidTapTopup() {
    router?.attachTopup()
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
}
