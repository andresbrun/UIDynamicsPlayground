import UIKit

public class UITapGestureRecognizerHelper: NSObject {

    public typealias OnTapAction = (CGPoint) -> Void

    var tapGesture: UITapGestureRecognizer!
    let onTap: OnTapAction
    let view: UIView

    public init(view: UIView, onTap: @escaping OnTapAction) {
        self.view = view
        self.onTap = onTap
        super.init()

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func tapGestureRecognizer(tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: view)
        onTap(location)
    }
}
