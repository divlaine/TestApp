import UIKit

protocol Router: Presentable {
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, hideBar: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: VoidClosure?)
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, completion: VoidClosure?)
    
    func popModule()
    func popModule(animated: Bool)
    func popModules(count: Int, animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: VoidClosure?)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    
    func popToRootModule(animated: Bool)
    func popToRootModule(animated: Bool, hideBar: Bool)
}

class RouterImpl: Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: VoidClosure]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(_ module: Presentable?) {
        self.present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?) {
        self.push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBar: Bool) {
        self.push(module, animated: false, hideBar: hideBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        self.push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: VoidClosure?) {
        self.push(module, animated: animated, hideBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, completion: VoidClosure?) {
        guard let controller = module?.toPresent(), !(controller is UINavigationController) else { return }
        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.isNavigationBarHidden = hideBar
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule() {
        self.popModule(animated: true)
    }
    
    func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popModules(count: Int, animated: Bool) {
        guard let rootController = rootController else { return }
        let viewControllers = rootController.viewControllers
        if viewControllers.count > count {
            var poppedControllers = [UIViewController]()
            for index in 0 ..< count {
                poppedControllers.append(viewControllers[viewControllers.count - index - 1])
            }
            _ = rootController.popToViewController(viewControllers[viewControllers.count - count - 1], animated: animated)
            poppedControllers.forEach({ runCompletion(for: $0) })
        }
    }
    
    func dismissModule() {
        self.dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: VoidClosure?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?) {
        self.setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: true)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        self.popToRootModule(animated: animated, hideBar: true)
    }
    
    func popToRootModule(animated: Bool, hideBar: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach({ controller in
                runCompletion(for: controller)
            })
            rootController?.isNavigationBarHidden = hideBar
        }
    }
    
    // MARK: - Private
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
