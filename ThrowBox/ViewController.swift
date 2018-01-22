//
//  ViewController.swift
//  ThrowBox
//
//  Created by muukii on 1/22/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var boxView: UIView!

  private var boxViewInitialFrame: CGRect = .zero

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let _gesture = UIPanGestureRecognizer(target: self, action: #selector(gesture))

    view.addGestureRecognizer(_gesture)

  }

  @objc
  func gesture(gesture: UIPanGestureRecognizer) {

    switch gesture.state {
    case .began:
      boxViewInitialFrame = boxView.frame
    case .changed:

      let point = gesture.translation(in: boxView)

//      boxView.transform = boxView.transform.translatedBy(x: point.x, y: point.y)
      boxView.center.y += point.y
      boxView.center.x += point.x

      gesture.setTranslation(.zero, in: boxView)

    case .ended:

      let gestureVelocity = gesture.velocity(in: boxView)

      let base = CGVector(
        dx: boxViewInitialFrame.midX - boxView.frame.midX,
        dy: boxViewInitialFrame.midY - boxView.frame.midY
      )

      print("base", base)
      print("gesture", gestureVelocity)

      let velocity = CGVector(
        dx: gestureVelocity.x / base.dx,
        dy: gestureVelocity.y / base.dy
      )

      let provider = UISpringTimingParameters(
        mass: 20,
        stiffness: 1000,
        damping: 1000,
        initialVelocity: velocity
      )

      let animator = UIViewPropertyAnimator(
        duration: 0.5,
        timingParameters: provider
      )

      animator.addAnimations {
        self.boxView.frame = self.boxViewInitialFrame
      }

      animator.startAnimation()

    default:
      break
    }
  }

}

