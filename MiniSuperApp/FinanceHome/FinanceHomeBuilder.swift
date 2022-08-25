import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
  
  var cardsOnFileRepository: CardOnFileRepository
  
  // 잔액을 업데이트 하기 위한 publisher
  private let balancePublisher: CurrentValuePublisher<Double>
  
  // 자식 리블렛에겐 값을 읽을 수만 있는 read only publisher를 넘겨야 한다
  // 고로 연산 프로퍼티로 balancePublisher를 넘겨주면 된다.
  // ReadOnlyCurrentValuePublisher는 CurrentValuePublisher의
  // 자식 클래스이기 때문에 자동으로 타입 캐스팅이 된다
  // 고로 balance를 참조하는 riblet은 read only의 특성을 지니게 된다
  var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
  
  
  init(
    dependency: FinanceHomeDependency,
    balance: CurrentValuePublisher<Double>,
    cardOnFileRepository: CardOnFileRepository
  ) {
    self.balancePublisher = balance
    self.cardsOnFileRepository = cardOnFileRepository
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(10000)
    
    let component = FinanceHomeComponent(
      dependency: dependency,
      balance: balancePublisher,
      cardOnFileRepository: CardOnFileRepositoryImp()
    )
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder
    )
  }
}
