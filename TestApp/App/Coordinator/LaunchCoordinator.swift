class LaunchCoordinator: BaseCoordinator {
    
    var finishFlow: BoolClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        startLaunchFlow()
    }
    
    // MARK: - Current Flow
    private func startLaunchFlow() {
        let screen = screenFactory.makeLaunchScreen()
        screen.onCheckAuthStatus = { [weak self] isAuthed in
            self?.finishFlow?(isAuthed)
        }
        router.setRootModule(screen, hideBar: true)
    }
}
