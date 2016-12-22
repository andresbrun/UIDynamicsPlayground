import UIKit

public extension UIView {
    public static func createBallView() -> UIView {
        return BallView(size: 50)
    }
    
    public static func createDefaultView() -> UIView {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0))
        view.backgroundColor = .white
        return view
    }

    public static func createDefaultContainer() -> UIView {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0))
    }
    
    public static func createFakeModal() -> UIView {
        let modalView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 280.0, height: 150.0))
        modalView.backgroundColor = .white
        modalView.applyModalShadow()
        modalView.applyBorder()
        return modalView
    }
    
    public static func createSecondaryModal() -> UIView {
        let modalView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 280.0, height: 50.0))
        modalView.backgroundColor = .white
        modalView.applyModalShadow()
        modalView.applyBorder()
        return modalView
    }

    public func applyModalShadow() {
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    public func applyBorder() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0 / UIScreen.main.scale
    }
    
    public func centerInSuperview(with random: CGFloat = 0) {
        guard let superview = superview else { return }
        center = CGPoint(x: superview.bounds.midX + CGFloat(arc4random_uniform(UInt32(random))),
                         y: superview.bounds.midY + CGFloat(arc4random_uniform(UInt32(random))))
    }
    
    public func placeCenteredOnTop(of view: UIView, gap: CGFloat) {
        center = CGPoint(x: view.center.x,
                         y: view.center.y - view.bounds.midY - bounds.midY - gap)
    }
}

public class BallView: UIImageView {
    public init(size: CGFloat) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        image = UIImage(named: "basketball-png-0")
        contentMode = .scaleToFill
        layer.cornerRadius = size * 0.5
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
