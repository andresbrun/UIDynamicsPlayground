//: [UIASnapBehaviour](@previous)
import UIKit
import PlaygroundSupport
/*:
 # UIFieldBehaviour
 Everything has been tested in Xcode 8.2.1
 */
/*:
 ## Creating the view
 And adding them to the container
 */
let containerView = UIView.createLargerContainer()
let targetView = UIView.createDefaultRoundedView()

containerView.addSubview(targetView)
targetView.centerInSuperview()

let animator = UIDynamicAnimator(referenceView: containerView)
animator.setValue(true, forKey: "debugEnabled")

/*:
 With values simulating outer space
 */
let itemBehavior = UIDynamicItemBehavior(items: [targetView])
itemBehavior.charge = 10.0
itemBehavior.elasticity = 0.2
itemBehavior.friction = 0.0
itemBehavior.resistance = 0
itemBehavior.density = 10
animator.addBehavior(itemBehavior)

/*:
 Avoid the item of leaving the screen
 */
let collision = UICollisionBehavior(items: [targetView])
collision.setTranslatesReferenceBoundsIntoBoundary(with: .zero)
animator.addBehavior(collision)

/*:
 ### SpringField
 It creates a field that is stronger as farther from the center the item is.
 */
let springField = UIFieldBehavior.springField()
springField.addItem(targetView)
springField.strength = 1
springField.position = containerView.relativeCenter
//animator.addBehavior(springField)

/*:
 ### NoiseField
 */
let noiseField = UIFieldBehavior.noiseField(smoothness: 0.95, animationSpeed: 0.6)
noiseField.strength = 1.0
noiseField.position = containerView.relativeCenter
noiseField.region = UIRegion(radius: 200)
noiseField.addItem(targetView)
//animator.addBehavior(noiseField)

/*:
 ### TurbulenceField
 NOTE: Not displayed in Debug
 */
let turbulenceField = UIFieldBehavior.turbulenceField(smoothness: 0.95, animationSpeed: 0.6)
turbulenceField.strength = 1.0
turbulenceField.position = containerView.relativeCenter
turbulenceField.region = UIRegion(radius: 200)
turbulenceField.addItem(targetView)
//animator.addBehavior(turbulenceField)

/*:
 ### Radial Gravity Field
 It creates a field that is stronger as closer from the center the item is.
 */
let radialGravityField = UIFieldBehavior.radialGravityField(position: containerView.relativeCenter)
radialGravityField.region = UIRegion(radius: 400.0)
radialGravityField.addItem(targetView)
radialGravityField.strength = 1
radialGravityField.minimumRadius = 50
animator.addBehavior(radialGravityField)

/*:
 ### Vortex Field
  NOTE: Not working as expected in exact center.
 */
let vortexField = UIFieldBehavior.vortexField()
//vortexField.region = UIRegion(radius: 200)
vortexField.addItem(targetView)
vortexField.position = containerView.relativeCenter
vortexField.position = CGPoint(x: 239, y: 235)
vortexField.strength = 1
//animator.addBehavior(vortexField)

/*:
 ### Velocity Field
 Apply a linear velocity
 NOTE: Not shown in Debug mode.
 */
let velocityField = UIFieldBehavior.velocityField(direction: CGVector(dx: 2, dy: 0))
velocityField.region = UIRegion(radius: 150)
velocityField.addItem(targetView)
velocityField.position = containerView.relativeCenter
//animator.addBehavior(velocityField)

/*:
 ### Electric Field
 NOTE: it doesn't work properly with exact center. Not shown in Debug mode.
 */
let electric = UIFieldBehavior.electricField()
electric.addItem(targetView)
electric.strength = -10 // it is directly related with item charge
electric.position = CGPoint(x: 241, y: 242)
animator.addBehavior(electric)

/*:
 ### Magnetic Field
 Note: it doesn't work properly with exact center. Not shown in Debug mode.
 So far I have seen it working just in combination with other behaviours
 like electric field (electromagnetic field)
 */
let magnetic = UIFieldBehavior.magneticField()
magnetic.addItem(targetView)
magnetic.strength = -10
magnetic.position = CGPoint(x: 241, y: 242)
//animator.addBehavior(magnetic)

/*:
 ### Attachment behaviour to move the view
 We need to add another UIDynamic behavior to be able to move the view interactively becouse otherwise we would have conflicts with UIDynamics engine
 */
let dragAttachmentBehaviour = UIAttachmentBehavior(item: targetView, attachedToAnchor: containerView.relativeCenter)

let pan = UIPanGestureRecognizerHelper(view: targetView,
                                       onStartPan: { (location, _) in
                                        dragAttachmentBehaviour.anchorPoint = location
                                        animator.addBehavior(dragAttachmentBehaviour)
}, onChangePan: { (location, _) in
    dragAttachmentBehaviour.anchorPoint = location
}, onFinishPan: {(_, velocity) in
    animator.removeBehavior(dragAttachmentBehaviour)
})

PlaygroundPage.current.liveView = containerView

//: [Combining behaviors Modal](@next)
