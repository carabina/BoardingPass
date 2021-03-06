//
//  OnboardingWrapperViewController.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BoardingPass

protocol BackgroundColorProvider {
    var backgroundColor: UIColor { get }
    var currentProgress: NSProgress { get }
}

public extension UIViewControllerTransitionCoordinatorContext {
    var toViewController: UIViewController? {
        return viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    var fromViewController: UIViewController? {
        return viewControllerForKey(UITransitionContextFromViewControllerKey)
    }
}

extension BackgroundColorProvider {
    func animation(container: UIViewController?, animated: Bool) -> (() -> ()) {
        let color = backgroundColor
        let progress = currentProgress
        let progressViewController = container as? OnboardingWrapperViewController
        return {
            progressViewController?.progress = progress
            container?.view.backgroundColor = color
        }
    }

}

class OnboardingWrapperViewController: BoardingNavigationController {

    // We're creating a non-standard progress slider because the UIProgressView
    // has a visual glitch when the animation is cancelled, probably due to
    // CALayer animations
    private let progressSlider = UIView()
    var progress = NSProgress() {
        didSet {
            let progressAmount = CGFloat(progress.fractionCompleted)
            var newTransform = CGAffineTransformIdentity
            newTransform = CGAffineTransformTranslate(newTransform, (-view.frame.width + (view.frame.width * progressAmount)) / 2, 0)
            newTransform = CGAffineTransformScale(newTransform, progressAmount, 1)
            progressSlider.transform = newTransform
        }
    }

    static func sampleOnboarding() -> OnboardingWrapperViewController {
        let onboarding = OnboardingWrapperViewController(viewControllersToPresent: [FirstViewController(), SecondViewController(), ThirdViewController()])
        return onboarding
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addSubview(progressSlider)
        progressSlider.frame.size.height = 4
        progressSlider.frame.size.width = navigationBar.frame.width
        progressSlider.frame.origin.x = navigationBar.frame.origin.x
        progressSlider.frame.origin.y = navigationBar.frame.maxY - progressSlider.frame.height
        progressSlider.backgroundColor = .redColor()
        view.backgroundColor = UIColor.whiteColor()
    }

}
