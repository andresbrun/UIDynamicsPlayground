//: [Previous](@previous)
import UIKit
import PlaygroundSupport
/*:
 # UIPushBehaviour, UICollisionBehavior and UIGravityBehavior
 */
/*:
 ## Creating the views
 And adding them to the container
 */
let containerView = UIView.createDefaultContainer()
let balls = (0...5).map { _ in UIView.createBallView() }
let targetBall = balls.first!
targetBall.backgroundColor = .white

balls.forEach { view in
    containerView.addSubview(view)
    view.centerInSuperview(with: 50)
}
/*:
 ## Creating the animator
 */
let animator = UIDynamicAnimator(referenceView: containerView)
/*:
 ## Creating the push behaviour
 With a tap gesture it will change `pushDirection` when tap is detected
 */
let pushContinousBehaviour = UIPushBehavior(items: [targetBall], mode: .continuous)
animator.addBehavior(pushContinousBehaviour)

let tapGesture = UITapGestureRecognizerHelper(view: containerView) { location in
    let direction = (location - targetBall.center) / CGFloat(100.0)
    pushContinousBehaviour.pushDirection = direction
}
/*:
 ## Adding a collision bounds
 It will add boundaries to avoid the ball getting out of the screen
 */
let collisionBehaviour = UICollisionBehavior(items: balls)
collisionBehaviour.setTranslatesReferenceBoundsIntoBoundary(with: .zero)
animator.addBehavior(collisionBehaviour)
/*:
 ## Adding elasticity and friction
 It will provide a more natural effect
 */
let dynamicBehaviour = UIDynamicItemBehavior(items: balls)
dynamicBehaviour.elasticity = 0.8
dynamicBehaviour.friction = 5.0
animator.addBehavior(dynamicBehaviour)
/*:
 ### Other parameters
 - `angularVelocity`, `linearVelocity`, `density`, `resistance`, `angularResistance`, `charge`
 - `isAnchored`, `allowsRotation`
 */

/*:
 ## Adding Gravity
 Because we are on earth, aren't we?
 */
let gravityBehaviour = UIGravityBehavior(items: balls)
gravityBehaviour.magnitude = 1.0
gravityBehaviour.angle = .pi / 2.0
animator.addBehavior(gravityBehaviour)
/*:
 ## Extra: Adding a shot gesture
 */
let panShot = UIPanGestureRecognizerHelper(view: targetBall, onFinishPan: { (_, velocity) in
    let pushDirection = velocity.vector / CGFloat(100.0)
    let pushInstantBehaviour = UIPushBehavior(items: [targetBall], mode: .instantaneous)
    pushInstantBehaviour.pushDirection = pushDirection
    animator.addBehavior(pushInstantBehaviour)
})

PlaygroundPage.current.liveView = containerView
//: [Next](@next)
