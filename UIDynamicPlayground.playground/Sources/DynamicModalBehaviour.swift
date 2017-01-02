import UIKit
import XCPlayground

public class DynamicModalBehaviour: NSObject {
    private var animator: UIDynamicAnimator?
    private var dragAttachmentBehaviour: UIAttachmentBehavior!
    private var itemsCollisionBehaviour: UICollisionBehavior!
    private var modalViewExitBehaviour: UIDynamicItemBehavior!
    private var itemsAttachmentBehaviours: [UIAttachmentBehavior]!
    private var snapBehaviours: [UISnapBehavior]!
    private var gravityBehaviour: UIGravityBehavior!
    private var panGesture: UIGestureRecognizer!
    private var superview: UIView {
        return targetView.superview!
    }
    private var allViews: [UIView] {
        return participantViews + [targetView]
    }
    
    private struct Constants {
        static let gravity = CGFloat(4.0)
        static let pushForceRatio = CGFloat(1.0/100.0)
        static let magnitudeThreshold = CGFloat(500)
        static let boundariesOffset = CGFloat(500)
    }

    public var participantViews: [UIView] = []
    public weak var targetView: UIView! {
        didSet {
            addPanGesture(to: targetView)
        }
    }
    public var shouldAllowDismiss: Bool = true
    public var onDismiss: (() -> Void)?

    deinit {
        animator?.removeAllBehaviors()
        targetView.removeGestureRecognizer(panGesture)
    }

    public func reset() {
        animator?.addBehaviors(snapBehaviours)
    }

    private func addPanGesture(to view: UIView) {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panTargetViewGestureRecognizer(sender:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createDynamicBehaviours() {
        animator = UIDynamicAnimator(referenceView: superview)

        snapBehaviours = allViews.map { UISnapBehavior(item: $0, snapTo: $0.center) }
        gravityBehaviour = UIGravityBehavior(items: allViews)
        gravityBehaviour.magnitude = Constants.gravity
        itemsCollisionBehaviour = UICollisionBehavior(items: allViews)
        itemsAttachmentBehaviours = createItemAttachments()
        
        modalViewExitBehaviour = UIDynamicItemBehavior(items: [targetView])
        modalViewExitBehaviour.action = { [unowned self] _ in
            if !self.allViews.contains(where: { $0.frame.intersects(self.superview.bounds) }) {
                self.configureForViewWentOutOfTheFrame()
                self.onDismiss?()
            }
        }
        animator?.addBehavior(modalViewExitBehaviour)
    }

    private func createItemAttachments() -> [UIAttachmentBehavior] {
        return zip(allViews.dropFirst(), allViews.dropLast()).map { (firstView, secondView) -> UIAttachmentBehavior in
            let attachment = UIAttachmentBehavior(item: firstView, attachedTo: secondView)
            attachment.length = (firstView.center - secondView.center).module
            return attachment
        }
    }
    
    private dynamic func panTargetViewGestureRecognizer(sender: UIPanGestureRecognizer) {
        if animator == nil {
            createDynamicBehaviours()
        }

        let location = sender.location(in: superview)
        let velocity = sender.velocity(in: superview)
        let offset = UIOffset(horizontal: location.x - targetView.center.x,
                              vertical: location.y - targetView.center.y)

        switch sender.state {
        case .began:
            configureForStartDragging(with: offset, location: location)
        case .changed:
            drag(to: location)
        case .cancelled, .ended, .failed:
            configureForFinishDragging(with: velocity, offset: offset)
        case .possible:
            break
        }
    }
    
    // mark - gesture phases
    private func configureForStartDragging(with offsetFromCenter: UIOffset, location: CGPoint) {
        animator?.removeBehaviors(snapBehaviours)
        
        dragAttachmentBehaviour = UIAttachmentBehavior(item: targetView,
                                                       offsetFromCenter: offsetFromCenter,
                                                       attachedToAnchor: location)
        animator?.addBehavior(dragAttachmentBehaviour)
        animator?.addBehavior(itemsCollisionBehaviour)
        animator?.addBehaviors(itemsAttachmentBehaviours)
    }
    
    private func drag(to location: CGPoint) {
        dragAttachmentBehaviour.anchorPoint = location
    }
    
    private func configureForFinishDragging(with velocity: CGPoint, offset: UIOffset) {
        if shouldDismiss(with: velocity) {
            dismiss(view: targetView, withVelocity: velocity, offset: offset)
        } else {
            animator?.addBehaviors(snapBehaviours)
        }
        animator?.removeBehavior(dragAttachmentBehaviour)
    }
    
    fileprivate func configureForViewWentOutOfTheFrame() {
        animator?.removeBehavior(gravityBehaviour)
        animator?.removeBehavior(itemsCollisionBehaviour)
    }
    
    private func shouldDismiss(with velocity: CGPoint) -> Bool {
        guard shouldAllowDismiss else { return false }
        let magnitude = velocity.vector.module
        return magnitude > Constants.magnitudeThreshold
    }
    
    private func dismiss(view: UIView, withVelocity velocity: CGPoint, offset: UIOffset) {
        let pushBehaviour = UIPushBehavior(items: [view], mode: .instantaneous)
        pushBehaviour.pushDirection = velocity.vector * Constants.pushForceRatio
        pushBehaviour.setTargetOffsetFromCenter(offset, for: view)
        animator?.addBehavior(pushBehaviour)
        
        animator?.addBehavior(gravityBehaviour)
        
        animator?.removeBehaviors(itemsAttachmentBehaviours)
    }
}


// mark - Handy extensions
public extension UIDynamicAnimator {
    func removeBehaviors(_ behaviors: [UIDynamicBehavior]) {
        behaviors.forEach { removeBehavior($0) }
    }
    
    func addBehaviors(_ behaviors: [UIDynamicBehavior]) {
        behaviors.forEach { addBehavior($0) }
    }
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x - rhs.x,
                    dy: lhs.y - rhs.y)
}

public func /(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx / rhs,
                    dy: lhs.dy / rhs)
}

public func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs,
                    dy: lhs.dy * rhs)
}

public extension CGPoint {
    var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
}

public extension CGVector {
    var module: CGFloat {
        return CGFloat(sqrtf(powf(Float(dx), 2) + powf(Float(dy), 2)))
    }
}
