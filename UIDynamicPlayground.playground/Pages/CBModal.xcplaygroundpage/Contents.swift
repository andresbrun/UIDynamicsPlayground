//: [Previous](@previous)
import UIKit
import PlaygroundSupport
/*:
 # Dismiss Modal Behaviour
 UIPushBehaviour, UICollisionBehavior, UIAttachBehaviour and UIGravityBehavior
 */
/*:
 ## Creating the views
 And adding them to the container. Placing extra one on top of the main one
 */
let containerPush = UIView.createDefaultContainer()
containerPush.backgroundColor = .gray
let modalView = UIView.createFakeModal()
let extraModalView = UIView.createSecondaryModal()

containerPush.addSubview(modalView)
containerPush.addSubview(extraModalView)
modalView.centerInSuperview()
extraModalView.placeCenteredOnTop(of: modalView, gap: 10)

/*:
 ## Adding the behaviour
 on dismiss we just reset the behaviour
 */
let dynamicBehaviour = DynamicModalBehaviour()
dynamicBehaviour.targetView = modalView
dynamicBehaviour.participantViews = [extraModalView]
dynamicBehaviour.onDismiss = {
    dynamicBehaviour.reset()
}


PlaygroundPage.current.liveView = containerPush
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
