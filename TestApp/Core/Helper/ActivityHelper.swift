import UIKit

class ActivityHelper {
    
    static let shared = ActivityHelper()
    
    private var activity: UIActivityIndicatorView?
    private var window: UIWindow?
    private var animator: UIViewPropertyAnimator?
    private var items = [String]()
    
    private var level: UIWindow.Level {
        get { return .alert + 200 }
    }
    
    func add(_ requestId: String) {
        initWindow()
        initActivity()
        items.append(requestId)
        show()
    }
    
    func remove(_ requestId: String) {
        if let index = items.firstIndex(where: { $0 == requestId }) {
            items.remove(at: index)
            hide()
        }
    }
    
    func remove(_ requestData: Data?) {
        guard let data = requestData,
              let params = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
              let requestId = params["id"] as? String
        else { return }
        self.remove(requestId)
    }
    
    private func show() {
        animator?.stopAnimation(true)
        window?.isHidden = false
        animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            DispatchQueue.main.async {
                self.window?.alpha = 1
            }
        }
        animator?.startAnimation()
    }
    
    private func hide() {
        DispatchQueue.main.async {
            let isVisible = !(self.window?.isHidden ?? false)
            if self.items.count == 0, isVisible {
                self.animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
                    self.window?.alpha = 0
                }
                self.animator?.addCompletion({ _ in
                    self.window?.isHidden = true
                })
                self.animator?.startAnimation(afterDelay: 0.05)
            }
        }
    }
    	
    private func initWindow() {
        if window == nil {
            if #available(iOS 13.0, *), let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            }
            else {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
            window?.rootViewController = UIViewController()
            window?.backgroundColor = Styles.shared.c.black.withAlphaComponent(0.2)
            window?.windowLevel = level
            window?.makeKeyAndVisible()
            window?.isHidden = true
            window?.alpha = 1
        }
    }
    
    private func initActivity() {
        if activity == nil {
            activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            activity!.center = window!.center
            activity!.startAnimating()
            window?.addSubview(activity!)
        }
    }
}
