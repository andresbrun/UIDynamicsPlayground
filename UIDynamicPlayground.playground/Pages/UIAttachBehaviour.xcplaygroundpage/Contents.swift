//: [Previous](@previous)
import UIKit
import PlaygroundSupport
/*:
 # UIAttachmentBehaviour
 */
/*:
 ## Creating the views
 And adding them to the container
 */
let containerView = UIView.createDefaultContainer()
let targetView = UIView.createDefaultView()
let draggableView = UIView.createDefaultView()

containerView.addSubview(targetView)
containerView.addSubview(draggableView)

targetView.centerInSuperview()
draggableView.placeCenteredOnTop(of: targetView, gap: 50)

let animator = UIDynamicAnimator(referenceView: containerView)

/*:
 ### Default attachment
 It simulates a stick between two elements with rotational point
 */
let behaviour = UIAttachmentBehavior(item: draggableView, offsetFromCenter: .zero, attachedTo: targetView, offsetFromCenter: .zero)
behaviour.length = 100
//animator.addBehavior(behaviour)

/*:
 ### slidingAttachment
 It simulates like an stick along axisOfTranslation where the other view can move in. Stick will move if necessary rotating the attached view.
 */
let slidingBehaviour = UIAttachmentBehavior.slidingAttachment(with: targetView, attachedTo: draggableView, attachmentAnchor: targetView.center, axisOfTranslation: CGVector(dx: 1, dy: 0))
animator.addBehavior(slidingBehaviour)

/*:
 ### limitAttachment
 It simulates a rope between two elements
 */
let ropeBehaviour = UIAttachmentBehavior.limitAttachment(with: targetView, offsetFromCenter: .zero, attachedTo: draggableView, offsetFromCenter: .zero)
//animator.addBehavior(ropeBehaviour)

/*:
 ### fixedAttachment
 It simulates a stick between two elements without rotational point
 */
let fixedBehaviour = UIAttachmentBehavior.fixedAttachment(with: targetView, attachedTo: draggableView, attachmentAnchor: .zero)
//animator.addBehavior(fixedBehaviour)

/*:
 ### pinAttachment
 It simulates two object nailed together
 */
let pinAttachment = UIAttachmentBehavior.pinAttachment(with: targetView, attachedTo: draggableView, attachmentAnchor: draggableView.center)
//animator.addBehavior(pinAttachment)


/*:
 ### Attachment behaviour to move the view
 We need to add another UIDynamic behavior to be able to move the view interactively becouse otherwise we would have conflicts with UIDynamics engine
 */
let dragAttachmentBehaviour = UIAttachmentBehavior(item: draggableView, attachedToAnchor: draggableView.center)
animator.addBehavior(dragAttachmentBehaviour)

let pan = UIPanGestureRecognizerHelper(view: draggableView, onChangePan: { (location, _) in
    dragAttachmentBehaviour.anchorPoint = location
})

PlaygroundPage.current.liveView = containerView

//: [Next](@next)
