import UIKit
import XCPlayground
import PlaygroundSupport

/*:
 ## UIDynamic
 This playground shows the behaviour and usage of differents behaviours provided by **UIKit Dynamics**
 */

/*:
 ### UIPushBehaviour
 */
let containerPush = UIView.createDefaultContainer()
let viewsPush = (0...3).map { _ in UIView.createRandomView() }
let targetView = viewsPush.first!

viewsPush.forEach { view in
    containerPush.addSubview(view)
    view.centerInSuperview()
}

let animator = UIDynamicAnimator(referenceView: containerPush)

let pushBehaviour = UIPushBehavior(items: [targetView], mode: .continuous)
animator.addBehavior(pushBehaviour)

let collisionBehaviour = UICollisionBehavior(items: viewsPush)
collisionBehaviour.setTranslatesReferenceBoundsIntoBoundary(with: .zero)
animator.addBehavior(collisionBehaviour)

let gesture = UITapGestureRecognizerHelper(view: containerPush) { location in
    let direction = (location - targetView.center) / CGFloat(100.0)
    pushBehaviour.pushDirection = direction
}

PlaygroundPage.current.liveView = containerPush
PlaygroundPage.current.needsIndefiniteExecution = true


/*:
 ### UIGravityBehaviour

 */

/*:
 ### UIAttachBehaviour

 */

/*:
 ### UICollisionBehaviour

 */

/*:
 ### UISpanBehaviour

 */

//let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0))
//
//let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 260.0, height: 150.0))
//view.center = CGPoint(x: container.frame.midX, y: container.frame.midY)
//view.backgroundColor = UIColor.green
//container.addSubview(view)
//
//let dynamicBehaviour = DynamicGestureRecognizerBehaviour()
//dynamicBehaviour.targetView = view
//dynamicBehaviour.onDismiss = {
//    dynamicBehaviour.reset()
//}
//
//PlaygroundPage.current.liveView = container
//PlaygroundPage.current.needsIndefiniteExecution = true
