import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let topupBuildable: TopupBuildable
  private var topupRouting: Routing?
  
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    topupBuildable: TopupBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.topupBuildable = topupBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  /*
   자식 riblet을 붙이려면 먼저 빌더의 빌드 메소드를 호출해서 라우터를 받아줘야 한다
   FinanceHome 화면 안에서 superPayDashboard(자식)를 추가할 거니까
   superPayDashboard 빌더를 통해 빌드 메소드를 호출하고
   빌드 메소드를 통해 생성된 VC를 기존 VC에 추가함과 동시에
   나의 자식으로 붙이는 로직
   */
  func attachSuperPayDashboard() {
    
    // 동일한 화면이 2번 이상 붙는 것을 방지하기 위한 로직
    if superPayRouting != nil {
      return
    }
    
    let router = superPayDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    
    viewController.addDashboard(dashboard)
    
    // 동일한 화면이 2번 이상 붙는 것을 방지하기 위한 로직
    self.superPayRouting = router
    
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil {
      return
    }
    
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    addPaymentMethodRouting = router
    attachChild(router)
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    viewControllable.dismiss(completion: nil)
    
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attachTopup() {
    if topupRouting != nil {
      return
    }
    
    let router = topupBuildable.build(withListener: interactor)
    topupRouting = router
    attachChild(router)
  }
  
  func detachTopup() {
    guard let router = topupRouting else {
      return
    }
    
    detachChild(router)
    self.topupRouting = nil
  }
}
