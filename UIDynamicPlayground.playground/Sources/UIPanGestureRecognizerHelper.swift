import UIKit

public class UIPanGestureRecognizerHelper: NSObject {

    public typealias OnPanAction = (_ location: CGPoint, _ velocity: CGPoint) -> Void

    var panGesture: UIPanGestureRecognizer!
    let onFinishPan: OnPanAction
    let onChangePan: OnPanAction
    let onStartPan: OnPanAction
    let view: UIView

    public init(view: UIView,
                onStartPan: @escaping OnPanAction = {_,_ in },
                onChangePan: @escaping OnPanAction = {_,_ in },
                onFinishPan: @escaping OnPanAction = {_,_ in }) {
        self.view = view
        self.onChangePan = onChangePan
        self.onFinishPan = onFinishPan
        self.onStartPan = onStartPan
        super.init()

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }

    @objc func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: view.superview)
        let location = panGesture.location(in: view.superview)
        
        switch panGesture.state {
        case .began:
            onStartPan(location, velocity)
        case .changed:
            onChangePan(location, velocity)
        case .cancelled, .ended:
            onFinishPan(location, velocity)
        default:
            break
        }
    }
}
