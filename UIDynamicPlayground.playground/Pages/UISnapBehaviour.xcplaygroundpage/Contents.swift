//: [UIAttachmentBehaviour](@previous)
import UIKit
import PlaygroundSupport
/*:
 # UISnapBehaviour
 */
/*:
 ## Creating the view
 And adding them to the container
 */
let containerView = UIView.createWiderContainer()
let targetView = UIView.createDefaultView()

containerView.addSubview(targetView)
targetView.centerInSuperview()

/*:
 ### Creating the behaviour
 Changing `snapPoint` to where the user taps
 */
let animator = UIDynamicAnimator(referenceView: containerView)
animator.setValue(true, forKey: "debugEnabled")

let snap = UISnapBehavior(item: targetView, snapTo: targetView.center)
animator.addBehavior(snap)

let tapGesture = UITapGestureRecognizerHelper(view: containerView) { location in
    snap.snapPoint = location
}

PlaygroundPage.current.liveView = containerView

//: [UIFieldBehavior](@next)
